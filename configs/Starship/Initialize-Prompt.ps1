# Only decorate interactive shells; keep scripts and redirected output clean.
$fusionArguments = [Environment]::GetCommandLineArgs()
if ($fusionArguments -match '^-(NonInteractive|Command|EncodedCommand|File|c|f|ec)$') { return }
if ([Console]::IsOutputRedirected) { return }
if ($global:EverforestPromptInitialized) { return }
$global:EverforestPromptInitialized = $true
$env:STARSHIP_CONFIG = Join-Path $PSScriptRoot 'starship.toml'
$fusionStarship = (Get-Command starship.exe -ErrorAction SilentlyContinue).Source
if ($fusionStarship) {
    Invoke-Expression (& $fusionStarship init powershell --print-full-init | Out-String)
}
$fusionFetch = Join-Path $env:LOCALAPPDATA 'Microsoft\WinGet\Links\fastfetch.exe'
if (Test-Path -LiteralPath $fusionFetch) {
    & $fusionFetch --config (Join-Path $PSScriptRoot 'fastfetch.jsonc')
}

