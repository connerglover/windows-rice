# Restores an explicit installer backup; never removes installed applications.
param([Parameter(Mandatory)][string]$Backup)
$ErrorActionPreference='Stop'
$Backup=(Resolve-Path -LiteralPath $Backup).Path
$rows=@(Get-Content "$Backup\files.json" -Raw|ConvertFrom-Json)
[array]::Reverse($rows)
foreach($row in $rows){
 if($row.Existed){
  New-Item -ItemType Directory -Force (Split-Path $row.Path)|Out-Null
  if(Test-Path -LiteralPath $row.Backup -PathType Container){Copy-Item -LiteralPath $row.Backup -Destination ($row.Path+'.restored') -Recurse -Force;Write-Warning "Directory backup staged at $($row.Path).restored; review before replacing."}
  else{Copy-Item -LiteralPath $row.Backup -Destination $row.Path -Force}
 }elseif(Test-Path -LiteralPath $row.Path -PathType Leaf){Remove-Item -LiteralPath $row.Path}
}
Get-ChildItem $Backup -Filter '*.reg'|ForEach-Object{& reg.exe import $_.FullName;if($LASTEXITCODE -ne 0){throw "Could not restore $($_.Name); run as administrator."}}
if(Test-Path "$Backup\startup-task.xml"){Register-ScheduledTask -TaskName 'Everforest V2 Desktop' -Xml (Get-Content "$Backup\startup-task.xml" -Raw) -Force|Out-Null}else{Unregister-ScheduledTask -TaskName 'Everforest V2 Desktop' -Confirm:$false -ErrorAction SilentlyContinue}
Write-Output 'Restored backed-up files and registry values. Sign out and back in. Applications remain installed.'
