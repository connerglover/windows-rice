$ErrorActionPreference='Stop'
$mutex=[Threading.Mutex]::new($false,'Local\EverforestDisplayLayout')
if(!$mutex.WaitOne(0)){exit 0}
$log=Join-Path $env:LOCALAPPDATA 'Everforest-display-layout.log'
try {
 Add-Type -AssemblyName System.Windows.Forms
 $last='';$candidate='';$stable=0
 while($true){
  try {
   # A fresh process avoids System.Windows.Forms.Screen's cached boot-time geometry.
   $current=(& powershell.exe -NoProfile -Command 'Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.Screen]::AllScreens | ForEach-Object { $_.DeviceName + $_.Bounds.ToString() }') -join ';'
   if($current -eq $candidate){$stable++}else{$candidate=$current;$stable=0}
   if($current -and $current -ne $last -and $stable -ge 2){
    if(Get-Process yasb -ErrorAction SilentlyContinue){
     & 'C:\Program Files\YASB\yasbc.exe' reload | Out-Null
     if($LASTEXITCODE -ne 0){throw 'YASB reload failed'}
    }
    if(Get-Process komorebi -ErrorAction SilentlyContinue){
     & 'C:\Program Files\komorebi\bin\komorebic.exe' retile | Out-Null
     if($LASTEXITCODE -ne 0){throw 'Komorebi retile failed'}
    }
    Add-Content $log ((Get-Date -Format o)+" Refreshed display bounds: $current")
    $last=$current
   }
  }catch{Add-Content $log ((Get-Date -Format o)+" ERROR: $_")}
  Start-Sleep -Seconds 3
 }
} finally {$mutex.ReleaseMutex();$mutex.Dispose()}
