$ErrorActionPreference='Stop'
$root=Split-Path $PSScriptRoot
$errors=@()
Get-ChildItem $root -Recurse -Filter '*.ps1'|Where-Object {$_.FullName -notlike '*\.local\*' -and $_.FullName -notlike '*\.cache\*'}|ForEach-Object {
 $tokens=$null;$parse=$null
 [Management.Automation.Language.Parser]::ParseFile($_.FullName,[ref]$tokens,[ref]$parse)|Out-Null
 $errors+=@($parse)
}
if($errors.Count){$errors|Format-List|Out-String|Write-Error;exit 1}
& "$root\Install.ps1" -Plan
Write-Output 'PASS: PowerShell parsing and read-only installer plan.'
