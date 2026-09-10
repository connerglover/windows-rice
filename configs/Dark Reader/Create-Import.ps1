param([Parameter(Mandatory=$true)][string]$ExportedSettings)
$ErrorActionPreference='Stop'
$settings=Get-Content -LiteralPath $ExportedSettings -Raw | ConvertFrom-Json
if(!$settings.PSObject.Properties['theme']){throw 'Choose a settings export from Dark Reader, not a theme or CSS export.'}
$theme=Get-Content -LiteralPath (Join-Path $PSScriptRoot 'Everforest.theme.json') -Raw | ConvertFrom-Json
foreach($property in $theme.PSObject.Properties){
    $settings.theme | Add-Member -NotePropertyName $property.Name -NotePropertyValue $property.Value -Force
}
$output=Join-Path $PSScriptRoot 'Everforest.import.json'
$settings | ConvertTo-Json -Depth 100 | Set-Content -LiteralPath $output -Encoding utf8
Write-Output "Created $output. Import it in Dark Reader > Settings > Manage settings. Your original export is unchanged."
