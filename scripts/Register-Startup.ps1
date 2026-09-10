# Run elevated, under the account whose desktop is being configured.
param([Parameter(Mandatory)][string]$Root,[switch]$StartNow)
$ErrorActionPreference='Stop'
$Root=(Resolve-Path -LiteralPath $Root).Path
$controller=Join-Path $PSScriptRoot 'Start-Desktop.ps1'
$backup=Join-Path $Root ('Backup\Startup-'+(Get-Date -Format yyyyMMdd-HHmmss))
New-Item -ItemType Directory -Force $backup|Out-Null
$user=[Security.Principal.WindowsIdentity]::GetCurrent().Name
# The controller owns Flow startup; retain unrelated Run entries.
$flow=Join-Path $env:APPDATA 'FlowLauncher\Settings\Settings.json'
if(Test-Path $flow){
 Copy-Item $flow (Join-Path $backup 'Flow-settings.json')
 Get-Process Flow.Launcher -ErrorAction SilentlyContinue|Stop-Process
 $settings=Get-Content $flow -Raw|ConvertFrom-Json
 $settings|Add-Member -NotePropertyName StartFlowLauncherOnSystemStartup -NotePropertyValue $false -Force
 $settings|Add-Member -NotePropertyName HideOnStartup -NotePropertyValue $true -Force
 $settings|ConvertTo-Json -Depth 80|Set-Content $flow -Encoding UTF8
}
& reg.exe export 'HKCU\Software\Microsoft\Windows\CurrentVersion\Run' (Join-Path $backup 'Run.reg') /y 2>$null|Out-Null
$run=[Microsoft.Win32.Registry]::CurrentUser.OpenSubKey('Software\Microsoft\Windows\CurrentVersion\Run',$true)
if($run){$run.DeleteValue('Flow.Launcher',$false);$run.Close()}
# Retire only known competing entries, preserving their definitions for rollback.
$retired=@('Komorebi Elevated','Everforest Ryoku whkd','Everforest Desktop Bar','Everforest Alt-Tabby','Everforest V2 Desktop','Alt-Tabby')
foreach($name in $retired){
 $task=Get-ScheduledTask -TaskName $name -ErrorAction SilentlyContinue
 if($task){Export-ScheduledTask -TaskName $name|Set-Content (Join-Path $backup ($name+'.xml'));Disable-ScheduledTask -TaskName $name|Out-Null}
}
foreach($stage in @('Core','Desktop')){
 $name="Everforest Startup $stage"
 if(Get-ScheduledTask -TaskName $name -ErrorAction SilentlyContinue){Export-ScheduledTask -TaskName $name|Set-Content (Join-Path $backup ($name+'.xml'))}
 $action=New-ScheduledTaskAction -Execute "$env:WINDIR\System32\WindowsPowerShell\v1.0\powershell.exe" -Argument ('-NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File "'+$controller+'" -Root "'+$Root+'" -Stage '+$stage) -WorkingDirectory $Root
 $trigger=New-ScheduledTaskTrigger -AtLogOn -User $user
 $trigger.Delay=if($stage -eq 'Core'){'PT5S'}else{'PT8S'}
 $level=if($stage -eq 'Core'){'Highest'}else{'Limited'}
 $principal=New-ScheduledTaskPrincipal -UserId $user -LogonType Interactive -RunLevel $level
 $settings=New-ScheduledTaskSettingsSet -MultipleInstances IgnoreNew -ExecutionTimeLimit ([timespan]::Zero) -StartWhenAvailable -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -RestartCount 2 -RestartInterval (New-TimeSpan -Minutes 1)
 Register-ScheduledTask -TaskName $name -Action $action -Trigger $trigger -Principal $principal -Settings $settings -Force|Out-Null
}
if($StartNow){Start-ScheduledTask -TaskName 'Everforest Startup Core';Start-ScheduledTask -TaskName 'Everforest Startup Desktop'}
Write-Output "Registered startup. Previous task definitions: $backup"
