# Pinned upstream releases, verified before extraction/execution.
$cache=Join-Path $InstallRoot 'downloads';New-Item -ItemType Directory -Force $cache|Out-Null
$downloads=@(
 @{Name='AltTabby.exe';Url='https://github.com/cwilliams5/Alt-Tabby/releases/download/v0.9.3/AltTabby.exe';Sha='520493D12413E23B8B4D03F706DE0615939504D2B100D8040B93FCD3CB02FFAE'},
 @{Name='thide.zip';Url='https://github.com/amnweb/thide/releases/download/v0.1.3/thide-0.1.3-x64-portable.zip';Sha='D33BDC8B0468265924E7374286E578657A29C8C85EDCA4A9BDDB197850AFD97F'}
)
foreach($item in $downloads){
 try{
  $file=Join-Path $cache $item.Name
  if(!(Test-Path $file)){Invoke-WebRequest $item.Url -OutFile $file -UseBasicParsing}
  if((Get-FileHash $file -Algorithm SHA256).Hash -ne $item.Sha){throw 'SHA256 mismatch; remove cached download and retry.'}
  if($item.Name -eq 'AltTabby.exe'){Put-File $file "$runtime\Alt-Tabby\AltTabby.exe"}
  else{Expand-Archive $file "$cache\thide" -Force;$exe=Get-ChildItem "$cache\thide" -Recurse -Filter thide.exe|Select-Object -First 1;Put-File $exe.FullName "$runtime\TaskbarHide\thide.exe"}
 }catch{$notes.Add("Download $($item.Name) failed: $_")}
}
try{
 $wallpaper="$runtime\Wallpapers\wallhaven-85mqwy-colorized.png"
 New-Item -ItemType Directory -Force (Split-Path $wallpaper)|Out-Null
 Save-File $wallpaper
 Invoke-WebRequest 'https://raw.githubusercontent.com/MrDLingters/EverforestWin11/88f430bd2d1d32a9ba3070f4531ece36c96e133c/Wallpapers/wallhaven-85mqwy-colorized.png' -OutFile $wallpaper -UseBasicParsing
 if((Get-FileHash $wallpaper).Hash -ne '581B7C148E191B95B67967C4392FE8C1404655F7BE91FCCEB35CFEB04BEF7A66'){Move-Item -LiteralPath $wallpaper -Destination ($wallpaper+'.invalid') -Force;throw 'Wallpaper checksum mismatch.'}
}catch{$notes.Add("Wallpaper download needs attention: $_")}
