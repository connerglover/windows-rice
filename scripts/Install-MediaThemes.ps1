param(
 [string]$MpvConfig = "$env:APPDATA\mpv",
 [string]$ImageGlassConfig
)
$ErrorActionPreference = 'Stop'
$repo = Split-Path $PSScriptRoot
if (Get-Process ImageGlass -ErrorAction SilentlyContinue) { throw 'Close ImageGlass before installing its theme so it cannot overwrite the settings.' }
if (!$ImageGlassConfig) {
 $store = "$env:LOCALAPPDATA\Packages\9662DuongDieuPhap.ImageGlass_xjrmsrdc1fgj6\LocalCache\Local\ImageGlass"
 $ImageGlassConfig = if (Test-Path "$store\igconfig.json") { $store } else { "$env:LOCALAPPDATA\ImageGlass" }
}
$backup = Join-Path $repo ('.local\Media-theme-backup-' + (Get-Date -Format yyyyMMdd-HHmmss-fff))
New-Item -ItemType Directory -Force $backup | Out-Null
if (Test-Path $MpvConfig) { Copy-Item $MpvConfig "$backup\mpv" -Recurse }
New-Item -ItemType Directory -Force $MpvConfig | Out-Null
Copy-Item "$repo\assets\mpv\*" $MpvConfig -Recurse -Force
Copy-Item "$repo\configs\MPV\script-opts" $MpvConfig -Recurse -Force
Copy-Item "$repo\configs\MPV\everforest.conf" $MpvConfig -Force
foreach ($name in @('mpv.conf','input.conf')) {
 $path = Join-Path $MpvConfig $name
 $text = if (Test-Path $path) { [IO.File]::ReadAllText($path) } else { '' }
 $text = [regex]::Replace($text, '(?ms)^# BEGIN EVERFOREST MEDIA.*?^# END EVERFOREST MEDIA\r?\n?', '')
 $block = if ($name -eq 'mpv.conf') { 'include=~~/everforest.conf' } else { Get-Content "$repo\configs\MPV\input.conf" -Raw }
 [IO.File]::WriteAllText($path, "$text`n# BEGIN EVERFOREST MEDIA`n$block`n# END EVERFOREST MEDIA`n", [Text.UTF8Encoding]::new($false))
}
$settings = Join-Path $ImageGlassConfig 'igconfig.json'
if (Test-Path $settings) {
 Copy-Item $settings $backup
 $theme = Join-Path $ImageGlassConfig '_themes\Everforest-Fusion.conner'
 if (Test-Path $theme) { Copy-Item $theme "$backup\ImageGlass-theme" -Recurse }
 New-Item -ItemType Directory -Force (Split-Path $theme) | Out-Null
 Copy-Item "$repo\configs\ImageGlass\Everforest-Fusion.conner" (Split-Path $theme) -Recurse -Force
 $config = Get-Content $settings -Raw | ConvertFrom-Json
 foreach ($pair in @(@('DarkTheme','Everforest-Fusion.conner'),@('LightTheme','Everforest-Fusion.conner'),@('BackgroundColor','#272E33'),@('WindowBackdrop','None'))) {
  $config | Add-Member -NotePropertyName $pair[0] -NotePropertyValue $pair[1] -Force
 }
 $config | ConvertTo-Json -Depth 80 | Set-Content $settings -Encoding UTF8
} else { Write-Warning 'Open ImageGlass 10 once, close it, then rerun to apply the theme.' }
Write-Output "Media themes installed. Backups: $backup. Reopen the apps to load them."
