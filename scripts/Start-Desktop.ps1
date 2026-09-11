param([Parameter(Mandatory)][string]$Root,[ValidateSet('Core','Desktop')][string]$Stage='Desktop')
$ErrorActionPreference='Stop'
$Root=[IO.Path]::GetFullPath($Root)
$logs=Join-Path $Root 'logs';New-Item -ItemType Directory -Force $logs|Out-Null
$mutex=[Threading.Mutex]::new($false,"Local\EverforestStartup-$Stage")
if(!$mutex.WaitOne(0)){exit 0}
function Log([string]$Message){Add-Content (Join-Path $logs "startup-$Stage.log") ((Get-Date -Format o)+' '+$Message)}
function Wait-Ready {
 param([int]$Seconds=30)
 $end=(Get-Date).AddSeconds($Seconds)
 do{
  if(Get-Process komorebi -ErrorAction SilentlyContinue){
   $probe=Start-Process 'C:\Program Files\komorebi\bin\komorebic.exe' -ArgumentList 'state' -WindowStyle Hidden -PassThru -RedirectStandardOutput "$logs\probe-$Stage.json" -RedirectStandardError "$logs\probe-$Stage.err"
   if($probe.WaitForExit(2000)){
    # Windows PowerShell can report a null ExitCode after WaitForExit.
    # Validate the fresh IPC payload instead of trusting that property.
    try{$state=Get-Content "$logs\probe-$Stage.json" -Raw|ConvertFrom-Json;if($null -ne $state.monitors){return $true}}catch{}
   }
   if(!$probe.HasExited){$probe.Kill()}
  }
  Start-Sleep -Milliseconds 500
 }while((Get-Date) -lt $end)
 return $false
}
function Launch([string]$Name,[string]$Exe){
 if(Get-Process $Name -ErrorAction SilentlyContinue){Log "$Name already running";return}
 if(!(Test-Path -LiteralPath $Exe)){Log "MISSING $Exe";return}
 Start-Process $Exe -WorkingDirectory (Split-Path $Exe) -WindowStyle Hidden;Log "Started $Name"
}
try{
 Log 'Starting'
 $end=(Get-Date).AddSeconds(45)
 while(!(Get-Process explorer -ErrorAction SilentlyContinue)){
  if((Get-Date) -gt $end){throw 'Explorer did not become available'}
  Start-Sleep 1
 }
 if($Stage -eq 'Core'){
  if(!(Get-Process komorebi -ErrorAction SilentlyContinue)){
   # Preserve stale IPC data; never touch a running window manager's socket.
   $data=Join-Path $env:LOCALAPPDATA 'komorebi'
   if(Test-Path -LiteralPath "$data\komorebi.sock"){
    $quarantine=$data+'.stale-'+(Get-Date -Format yyyyMMdd-HHmmss)
    [IO.Directory]::Move($data,$quarantine);Log "Preserved stale IPC directory: $quarantine"
   }
   New-Item -ItemType Directory -Force $data|Out-Null
   Start-Process 'C:\Program Files\komorebi\bin\komorebi.exe' -ArgumentList ('--config "'+$env:USERPROFILE+'\komorebi.json"') -WorkingDirectory $env:USERPROFILE -WindowStyle Hidden -RedirectStandardOutput "$logs\komorebi.stdout.log" -RedirectStandardError "$logs\komorebi.stderr.log"
  }
  if(!(Wait-Ready 35)){throw 'Komorebi failed readiness; see komorebi.stderr.log'}
  Log 'Komorebi IPC ready'
  if(!(Get-Process whkd -ErrorAction SilentlyContinue)){
   Start-Process 'C:\Program Files\whkd\bin\whkd.exe' -ArgumentList ('--config "'+$Root+'\Hotkeys\whkdrc"') -WorkingDirectory "$Root\Hotkeys" -WindowStyle Hidden -RedirectStandardOutput "$logs\whkd.stdout.log" -RedirectStandardError "$logs\whkd.stderr.log"
  }
 }else{
  if(!(Wait-Ready 45)){Log 'WARNING Komorebi is offline; continuing with usable desktop'}
  Launch 'AltTabby' "$Root\Alt-Tabby\AltTabby.exe"
  Launch 'Flow.Launcher' "$env:LOCALAPPDATA\FlowLauncher\Flow.Launcher.exe"
  $thide="$Root\TaskbarHide\thide.exe"
  if(!(Test-Path $thide)){$thide='C:\Program Files\thide\bin\thide.exe'}
  Launch 'thide' $thide
  Start-Sleep 3
  if(Get-Process yasb -ErrorAction SilentlyContinue){& 'C:\Program Files\YASB\yasbc.exe' reload|Out-Null}else{Launch 'yasb' 'C:\Program Files\YASB\yasb.exe'}
  Start-Process powershell.exe -WindowStyle Hidden -ArgumentList ('-NoProfile -ExecutionPolicy Bypass -File "'+$PSScriptRoot+'\Watch-DisplayLayout.ps1"')
 }
 Log 'Completed'
}catch{Log "ERROR $_";exit 1}finally{$mutex.ReleaseMutex();$mutex.Dispose()}
