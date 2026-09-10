#requires -Version 5.1
[CmdletBinding()]
param([switch]$Plan,[switch]$SkipPackages,[switch]$SkipSystem,[switch]$NoStartup,[string]$InstallRoot="$env:LOCALAPPDATA\Everforest-W11-Rice-V2")
$ErrorActionPreference='Stop';$repo=$PSScriptRoot
if($Plan){Write-Output "Target: $InstallRoot";Write-Output 'Install missing packages; backup and render configs; configure desktop, shell and available Windhawk mods. Browser imports and missing mods are reported for follow-up.';(Get-Content "$repo\packages.json" -Raw|ConvertFrom-Json).winget;return}
if(!$SkipSystem -and !([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)){
 $arguments=@('-NoProfile','-ExecutionPolicy','Bypass','-File',('"'+$PSCommandPath+'"'),'-InstallRoot',('"'+$InstallRoot+'"'))
 foreach($flag in @('SkipPackages','NoStartup')){if((Get-Variable $flag -ValueOnly)){$arguments+='-'+$flag}}
 $p=Start-Process powershell.exe -Verb RunAs -WindowStyle Hidden -ArgumentList $arguments -Wait -PassThru
 if($p.ExitCode -ne 0){throw "Installer failed: $($p.ExitCode)"}
 if(Test-Path "$InstallRoot\NEXT-STEPS.txt"){Get-Content "$InstallRoot\NEXT-STEPS.txt"}
 return
}
New-Item -ItemType Directory -Force $InstallRoot|Out-Null
$state=Join-Path $InstallRoot ('backups\'+(Get-Date -Format yyyyMMdd-HHmmss));New-Item -ItemType Directory -Force $state|Out-Null
$script:files=@();$notes=[Collections.Generic.List[string]]::new()
function Save-File([string]$Path){
 if($script:files.Path -contains $Path){return};$saved=Join-Path $state ([guid]::NewGuid().ToString());$exists=Test-Path -LiteralPath $Path
 if($exists){Copy-Item -LiteralPath $Path -Destination $saved -Recurse}
 $script:files+=@{Path=$Path;Backup=$saved;Existed=$exists};$script:files|ConvertTo-Json -Depth 5|Set-Content "$state\files.json"
}
function Put-File([string]$Source,[string]$Destination){Save-File $Destination;New-Item -ItemType Directory -Force (Split-Path $Destination)|Out-Null;Copy-Item -LiteralPath $Source -Destination $Destination -Force}
function Export-Key([string]$Key,[string]$Name){& reg.exe export $Key "$state\$Name.reg" /y 2>$null|Out-Null}
Start-Transcript "$state\install.log"|Out-Null
try{
 if(!$SkipPackages){
  if(!(Get-Command winget.exe -ErrorAction SilentlyContinue)){throw 'Install Microsoft App Installer, then rerun.'}
  foreach($id in (Get-Content "$repo\packages.json" -Raw|ConvertFrom-Json).winget){
   & winget.exe list --id $id --exact --accept-source-agreements --disable-interactivity *> "$state\package-check.txt"
   if($LASTEXITCODE -eq 0){continue}
   & winget.exe install --id $id --exact --source winget --silent --accept-package-agreements --accept-source-agreements --disable-interactivity
   if($LASTEXITCODE -ne 0){$notes.Add("Package needs attention: $id ($LASTEXITCODE)")}
  }
 }
 $env:Path=[Environment]::GetEnvironmentVariable('Path','Machine')+';'+[Environment]::GetEnvironmentVariable('Path','User')
 $runtime=Join-Path $InstallRoot 'theme'
 foreach($tree in @('configs','assets')){Get-ChildItem "$repo\$tree" -Recurse -File|ForEach-Object{
  $rel=$_.FullName.Substring(("$repo\$tree\").Length);$dest=Join-Path $runtime $rel;Save-File $dest;New-Item -ItemType Directory -Force (Split-Path $dest)|Out-Null
  if($_.Extension -in @('.json','.jsonc','.yaml','.toml','.ini','.lua','.ps1','.css','.nss','.xaml') -or $_.Name -eq 'whkdrc'){
   $text=[IO.File]::ReadAllText($_.FullName)
   $tokens=@{'{{RICE_ROOT_JSON}}'=$runtime.Replace('\','\\');'{{RICE_ROOT_POSIX}}'=$runtime.Replace('\','/');'{{RICE_ROOT}}'=$runtime;'{{USERPROFILE_JSON}}'=$env:USERPROFILE.Replace('\','\\');'{{USERPROFILE_POSIX}}'=$env:USERPROFILE.Replace('\','/');'{{USERPROFILE}}'=$env:USERPROFILE}
   foreach($token in $tokens.Keys){$text=$text.Replace($token,$tokens[$token])}
   $encoding=if($rel -eq 'Alt-Tabby\config.ini'){[Text.Encoding]::Unicode}else{[Text.UTF8Encoding]::new($false)}
   [IO.File]::WriteAllText($dest,$text,$encoding)
  }else{Copy-Item $_.FullName $dest -Force}
 }}
 if(!$SkipPackages){. "$repo\scripts\Download-Extras.ps1"}
 . "$repo\scripts\Configure.ps1"
 if(!$SkipSystem){. "$repo\scripts\Configure-System.ps1"}
 if(!$NoStartup -and !$SkipSystem){& "$repo\scripts\Register-Startup.ps1" -Root $runtime}
 elseif(!$NoStartup){$notes.Add('Startup registration requires elevation; rerun without -SkipSystem.')}
 $notes.Add('Browser extension imports and Store apps: see docs/INSTALL.md.')
 $notes|Set-Content "$InstallRoot\NEXT-STEPS.txt";Write-Output "Installed. Backup: $state";Write-Output "Checklist: $InstallRoot\NEXT-STEPS.txt"
}finally{Stop-Transcript|Out-Null}
