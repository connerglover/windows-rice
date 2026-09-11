# Dot-sourced by Configure.ps1; uses the installer's backup-aware Put-File.
# Copy themes only; activation remains an application-level step.
$musicThemes = @(
    @{ Source = 'Spicetify'; Root = "$env:APPDATA\spicetify"; Destination = "$env:APPDATA\spicetify\Themes\Everforest-Fusion" },
    @{ Source = 'Cider'; Root = "$env:APPDATA\C2Windows"; Destination = "$env:APPDATA\C2Windows\themes\Everforest-Fusion" }
)
foreach ($theme in $musicThemes) {
    if (Test-Path -LiteralPath $theme.Root -PathType Container) {
        Get-ChildItem -LiteralPath "$runtime\$($theme.Source)\Everforest-Fusion" -File | ForEach-Object {
            Put-File $_.FullName (Join-Path $theme.Destination $_.Name)
        }
        $notes.Add("$($theme.Source): Everforest Fusion theme copied. See docs/MUSIC-THEMES.md to activate it.")
    } else {
        $notes.Add("$($theme.Source): optional theme available in $runtime\$($theme.Source)\Everforest-Fusion. See docs/MUSIC-THEMES.md for installation.")
    }
}
