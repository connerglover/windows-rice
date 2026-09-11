# Refresh YASB once after display changes settle (remote connect/disconnect).
$ErrorActionPreference='Stop'
$mutex=[Threading.Mutex]::new($false,'Local\EverforestDisplayLayout')
if(!$mutex.WaitOne(0)){exit 0}
try {
 Add-Type -AssemblyName System.Windows.Forms
 Register-ObjectEvent -InputObject ([Microsoft.Win32.SystemEvents]) -EventName DisplaySettingsChanged -SourceIdentifier EverforestDisplayChanged | Out-Null
 while($true){
  $event=Wait-Event -SourceIdentifier EverforestDisplayChanged -Timeout 30
  if(!$event){continue}
  Remove-Event -SourceIdentifier EverforestDisplayChanged -ErrorAction SilentlyContinue
  # Virtual displays often change size and position in several successive steps.
  do {
   Start-Sleep -Seconds 4
   $pending=@(Get-Event -SourceIdentifier EverforestDisplayChanged -ErrorAction SilentlyContinue)
   Remove-Event -SourceIdentifier EverforestDisplayChanged -ErrorAction SilentlyContinue
  } while($pending.Count)
  if(Get-Process yasb -ErrorAction SilentlyContinue){
   & 'C:\Program Files\YASB\yasbc.exe' reload | Out-Null
  }
 }
} finally {
 Unregister-Event -SourceIdentifier EverforestDisplayChanged -ErrorAction SilentlyContinue
 $mutex.ReleaseMutex();$mutex.Dispose()
}
