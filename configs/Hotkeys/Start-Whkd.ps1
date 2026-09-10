$ErrorActionPreference='Stop'
$exe='C:\Program Files\whkd\bin\whkd.exe'
if(Get-Process whkd -ErrorAction SilentlyContinue){exit}
& $exe --config (Join-Path $PSScriptRoot 'whkdrc') *> (Join-Path $PSScriptRoot 'whkd.log')
