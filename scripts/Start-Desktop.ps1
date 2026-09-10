param([Parameter(Mandatory)][string]$Root)
$ErrorActionPreference='Continue'
$env:Path=[Environment]::GetEnvironmentVariable('Path','Machine')+';'+[Environment]::GetEnvironmentVariable('Path','User')
if(!(Get-Process komorebi -ErrorAction SilentlyContinue)){& 'C:\Program Files\komorebi\bin\komorebic.exe' start --config "$env:USERPROFILE\komorebi.json"}
if(!(Get-Process whkd -ErrorAction SilentlyContinue)){Start-Process powershell.exe -WindowStyle Hidden -ArgumentList ('-NoProfile -ExecutionPolicy Bypass -File "'+$Root+'\Hotkeys\Start-Whkd.ps1"')}
if((Test-Path "$Root\Alt-Tabby\AltTabby.exe") -and !(Get-Process AltTabby -ErrorAction SilentlyContinue)){Start-Process "$Root\Alt-Tabby\AltTabby.exe" -WorkingDirectory "$Root\Alt-Tabby"}
if(!(Get-Process Flow.Launcher -ErrorAction SilentlyContinue) -and (Test-Path "$env:LOCALAPPDATA\FlowLauncher\Flow.Launcher.exe")){Start-Process "$env:LOCALAPPDATA\FlowLauncher\Flow.Launcher.exe" -WindowStyle Hidden}
& "$Root\Start-Desktop-Bar.ps1"
