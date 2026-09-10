foreach($pair in @(@('YASB\config.yaml',"$env:USERPROFILE\.config\yasb\config.yaml"),@('YASB\styles.css',"$env:USERPROFILE\.config\yasb\styles.css"),@('Hotkeys\whkdrc',"$env:USERPROFILE\.config\whkdrc"),@('Komorebi\komorebi.json',"$env:USERPROFILE\komorebi.json"),@('WezTerm\wezterm.lua',"$env:USERPROFILE\.wezterm.lua"))){Put-File "$runtime\$($pair[0])" $pair[1]}
if(!(Test-Path "$env:USERPROFILE\applications.json")){
 Save-File "$env:USERPROFILE\applications.json"
 try{Invoke-WebRequest 'https://raw.githubusercontent.com/LGUG2Z/komorebi-application-specific-configuration/master/applications.json' -OutFile "$env:USERPROFILE\applications.json" -UseBasicParsing}catch{$notes.Add('Download Komorebi applications.json using komorebic fetch-asc before starting the window manager.')}
}
$profilePath=Join-Path ([Environment]::GetFolderPath('MyDocuments')) 'PowerShell\Microsoft.PowerShell_profile.ps1'
Save-File $profilePath;New-Item -ItemType Directory -Force (Split-Path $profilePath)|Out-Null
$profileText=if(Test-Path $profilePath){[IO.File]::ReadAllText($profilePath)}else{''}
$profileText=[regex]::Replace($profileText,'(?ms)^# BEGIN EVERFOREST V2.*?^# END EVERFOREST V2\r?\n?','')
$profileText+="`r`n# BEGIN EVERFOREST V2`r`n. '$runtime\CLI\Initialize-Tools.ps1'`r`n. '$runtime\Starship\Initialize-Prompt.ps1'`r`n# END EVERFOREST V2`r`n"
[IO.File]::WriteAllText($profilePath,$profileText,[Text.UTF8Encoding]::new($true))
Put-File "$runtime\CLI\Everforest Fusion.tmTheme" "$env:APPDATA\bat\themes\Everforest Fusion.tmTheme"
if(Get-Command bat.exe -ErrorAction SilentlyContinue){& bat.exe cache --build}
$flow="$env:APPDATA\FlowLauncher\Settings\Settings.json"
Put-File "$runtime\Flow Launcher\Everforest Fusion.xaml" "$env:APPDATA\FlowLauncher\Themes\Everforest Fusion.xaml"
if(Test-Path $flow){Save-File $flow;$settings=Get-Content $flow -Raw|ConvertFrom-Json;$settings|Add-Member -NotePropertyName Theme -NotePropertyValue 'Everforest Fusion' -Force;$settings|Add-Member -NotePropertyName Hotkey -NotePropertyValue 'Alt + Space' -Force;$settings|ConvertTo-Json -Depth 80|Set-Content $flow -Encoding UTF8}else{$notes.Add('Open Flow Launcher once, then rerun to select its theme and Alt+Space.')}
if(Test-Path "$env:APPDATA\Vencord\themes"){Get-ChildItem "$runtime\Vencord" -Filter '*.css'|ForEach-Object{Put-File $_.FullName "$env:APPDATA\Vencord\themes\$($_.Name)"}}else{$notes.Add('Install Vencord through its official installer, then enable the included theme.')}
$extension=Join-Path $env:USERPROFILE '.vscode-oss\extensions\everforest-fusion';Save-File $extension;New-Item -ItemType Directory -Force $extension|Out-Null;Copy-Item "$runtime\VSCode\everforest-fusion\*" $extension -Recurse -Force
$notes.Add('VSCodium: select Everforest Fusion using Preferences: Color Theme. Existing JSONC settings are preserved.')
$btop=Get-Command btop4win.exe -ErrorAction SilentlyContinue
if($btop){Put-File "$runtime\CLI\Everforest.theme" (Join-Path (Split-Path $btop.Source) 'themes\Everforest.theme');$notes.Add('btop: select Everforest in its theme settings.')}
