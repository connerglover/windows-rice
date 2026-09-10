$ErrorActionPreference='Stop'
$backup=Join-Path $PSScriptRoot 'Backup\Sounds'
New-Item -ItemType Directory -Path $backup -Force | Out-Null
if(!(Test-Path (Join-Path $backup 'AppEvents.reg'))){ & reg.exe export 'HKCU\AppEvents\Schemes' (Join-Path $backup 'AppEvents.reg') /y | Out-Null }
$name='EverforestFusion'
$base='HKCU:\AppEvents\Schemes'
New-Item "$base\Names\$name" -Force | Out-Null
Set-Item "$base\Names\$name" -Value 'Everforest — Soft Chimes'
# Copy every current assignment to the named scheme before replacing selected cues.
Get-ChildItem "$base\Apps" | ForEach-Object {Get-ChildItem $_.PSPath} | ForEach-Object {
    $current=Join-Path $_.PSPath '.Current'
    if(Test-Path $current){$value=(Get-Item $current).GetValue('');$dest=Join-Path $_.PSPath $name;New-Item $dest -Force | Out-Null;Set-Item $dest -Value ([string]$value)}
}
$map=@{
    'Notification.Default'='Dew';'SystemNotification'='Dew';'Notification.IM'='Rain';'Notification.SMS'='Rain';
    'Notification.Mail'='Dew';'MailBeep'='Dew';'DeviceConnect'='Fern';'DeviceDisconnect'='Falling Leaf';
    'DeviceFail'='Ember';'SystemAsterisk'='Rain';'SystemExclamation'='Amber';'SystemHand'='Ember';
    'SystemQuestion'='Rain';'PrintComplete'='Bloom';'Notification.Reminder'='Amber'
}
foreach($event in $map.Keys){
    $file=Join-Path $PSScriptRoot ('Sounds\'+$map[$event]+'.wav')
    if(!(Test-Path -LiteralPath $file)){throw "Missing sound $file"}
    foreach($scheme in @('.Current',$name)){$key="$base\Apps\.Default\$event\$scheme";New-Item $key -Force | Out-Null;Set-Item $key -Value $file}
}
Set-Item $base -Value $name
'Applied 15 event assignments. Battery alarms, security prompts, looping alarms and calls retain their previous sounds.' | Set-Content (Join-Path $PSScriptRoot 'Sounds\applied.txt')
