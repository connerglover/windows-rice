param([string]$SettingsPath = "$env:LOCALAPPDATA\SumatraPDF\SumatraPDF-settings.txt")
$ErrorActionPreference = 'Stop'
if (Get-Process SumatraPDF -ErrorAction SilentlyContinue) { throw 'Close SumatraPDF before applying the theme.' }
if (!(Test-Path -LiteralPath $SettingsPath)) { throw "Settings not found: $SettingsPath. Open SumatraPDF once, or supply -SettingsPath for a portable installation." }
$repo = Split-Path $PSScriptRoot
$text = [IO.File]::ReadAllText($SettingsPath)
$theme = [IO.File]::ReadAllText((Join-Path $repo 'configs\SumatraPDF\Everforest-Fusion.txt')).Trim()
$pattern = '(?ms)^Themes\s*\[\r?\n(.*?)^\]'
$match = [regex]::Match($text, $pattern)
if (!$match.Success) { throw 'Expected Themes section not found; settings were not changed.' }
$existing = [regex]::Replace($match.Groups[1].Value, '(?ms)^\s*\[\s*\r?\n\s*Name = Everforest Fusion\s*\r?\n.*?^\s*\]\s*\r?\n?', '')
$replacement = "Themes [`r`n$existing$theme`r`n]"
$text = $text.Remove($match.Index, $match.Length).Insert($match.Index, $replacement)
$values = @{
 Theme = 'Everforest Fusion'; MainWindowBackground = '#272E33'; UseSysColors = 'false'; ShowStartPage = 'false'
 SelectionColor = '#A7C080'; HighlightColor = '#DBBC7F'; UnderlineColor = '#A7C080'
 SquigglyColor = '#D699B6'; StrikeOutColor = '#E67E80'
}
foreach ($key in $values.Keys) {
 $text = [regex]::Replace($text, "(?m)^(\s*" + [regex]::Escape($key) + ' = )[^\r\n]*', '${1}' + $values[$key])
}
$backup = Join-Path $repo ('.local\Sumatra-theme-backup-' + (Get-Date -Format yyyyMMdd-HHmmss-fff))
New-Item -ItemType Directory -Path $backup -Force | Out-Null
Copy-Item -LiteralPath $SettingsPath -Destination $backup
[IO.File]::WriteAllText($SettingsPath, $text, [Text.UTF8Encoding]::new($false))
Write-Output "Applied Everforest Fusion. Backup: $backup"
