# One ordered, per-user sign-in startup for Taskbar Hide and YASB.
$ErrorActionPreference='Stop'
$log=Join-Path $PSScriptRoot 'startup-bar.log'
try {
    $deadline=(Get-Date).AddSeconds(45)
    while(!(Get-Process explorer -ErrorAction SilentlyContinue) -and (Get-Date) -lt $deadline) { Start-Sleep 1 }
    if(!(Get-Process thide -ErrorAction SilentlyContinue)) {
        $thide=Join-Path $PSScriptRoot 'TaskbarHide\thide.exe'
        if(!(Test-Path $thide)){$thide='C:\Program Files\thide\bin\thide.exe'}
        if(Test-Path $thide){Start-Process $thide -WindowStyle Hidden}
    }
    # Taskbar Hide changes the shell's AppBar state. Reserve YASB's space afterwards.
    Start-Sleep 3
    if(Get-Process yasb -ErrorAction SilentlyContinue) {
        & 'C:\Program Files\YASB\yasbc.exe' reload
    } else {
        Start-Process 'C:\Program Files\YASB\yasb.exe' -WindowStyle Hidden
    }
    ('{0:yyyy-MM-dd HH:mm:ss} Taskbar Hide started before YASB; AppBar enabled.' -f (Get-Date)) | Add-Content $log
} catch { ('{0:yyyy-MM-dd HH:mm:ss} ERROR {1}' -f (Get-Date),$_) | Add-Content $log;exit 1 }
