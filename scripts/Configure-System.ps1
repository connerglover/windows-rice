Export-Key 'HKCU\Control Panel\Cursors' 'cursors';Export-Key 'HKCU\Software\Microsoft\Windows\DWM' 'dwm';Export-Key 'HKCU\AppEvents\Schemes' 'sounds'
$cursor="$runtime\Cursors\Bibata-Everforest-Windows";$key='HKCU:\Control Panel\Cursors'
$map=@{Arrow='Pointer.cur';Help='Help.cur';AppStarting='Work.ani';Wait='Busy.ani';Crosshair='Cross.cur';IBeam='Text.cur';NWPen='Handwriting.cur';No='Unavailable.cur';SizeNS='Vert.cur';SizeWE='Horz.cur';SizeNWSE='Dgn1.cur';SizeNESW='Dgn2.cur';SizeAll='Move.cur';Hand='Link.cur';UpArrow='Alternate.cur'}
foreach($name in $map.Keys){Set-ItemProperty $key $name "$cursor\$($map[$name])"};Set-Item $key 'Everforest Bibata'
New-Item 'HKCU:\Software\Microsoft\Windows\DWM' -Force|Out-Null
New-ItemProperty 'HKCU:\Software\Microsoft\Windows\DWM' AccentColor -Value ([uint32]4286628007) -PropertyType DWord -Force|Out-Null
& "$runtime\Apply-Sound-Scheme.ps1"
$mods=@{Taskbar='windows-11-taskbar-styler';StartMenu='windows-11-start-menu-styler';NotificationCenter='windows-11-notification-center-styler';TaskbarSize='taskbar-icon-size';SpotifyControls='cef-titlebar-enabler-universal'}
foreach($name in $mods.Keys){
 $path='HKLM:\SOFTWARE\Windhawk\Engine\Mods\'+$mods[$name]
 if(!(Test-Path $path)){$notes.Add("Install Windhawk mod $($mods[$name]) and rerun installer.");continue}
 Export-Key ('HKLM\SOFTWARE\Windhawk\Engine\Mods\'+$mods[$name]) $mods[$name]
 $key=New-Item "$path\Settings" -Force
 $config=Get-Content "$runtime\Windhawk\$name.json" -Raw|ConvertFrom-Json
 foreach($property in $config.PSObject.Properties){$type=if($property.Value -is [int]){'DWord'}else{'String'};New-ItemProperty $key.PSPath $property.Name -Value $property.Value -PropertyType $type -Force|Out-Null}
 Set-ItemProperty $path SettingsChangeTime ([int][DateTimeOffset]::Now.ToUnixTimeSeconds())
 if($name -eq 'SpotifyControls'){$notes.Add('Restart Spotify to apply transparent native window controls. Enable CEF/Spotify Tweaks in Windhawk if it is disabled.')}
}
$redirect='HKLM:\SOFTWARE\Windhawk\Engine\Mods\icon-resource-redirect'
if(Test-Path $redirect){Export-Key 'HKLM\SOFTWARE\Windhawk\Engine\Mods\icon-resource-redirect' 'icon-resource-redirect';Set-ItemProperty "$redirect\Settings" 'themePaths[0]' "$runtime\Icons";Set-ItemProperty $redirect SettingsChangeTime ([int][DateTimeOffset]::Now.ToUnixTimeSeconds())}else{$notes.Add('Install Icon Resource Redirect in Windhawk and rerun.')}
if(Test-Path 'C:\Program Files\Nilesoft Shell\imports'){Put-File "$runtime\NileSoft-Shell\theme.nss" 'C:\Program Files\Nilesoft Shell\imports\theme.nss'}
$notes.Add('Sign out and back in to refresh shell resources and the cursor scheme.')
if(Test-Path "$runtime\Wallpapers\wallhaven-85mqwy-colorized.png"){
 Export-Key 'HKCU\Control Panel\Desktop' 'desktop'
 Add-Type -TypeDefinition 'using System.Runtime.InteropServices; public static class EverforestDesktop { [DllImport("user32.dll", CharSet=CharSet.Unicode)] public static extern bool SystemParametersInfo(int action,int value,string data,int flags); }'
 [EverforestDesktop]::SystemParametersInfo(20,0,"$runtime\Wallpapers\wallhaven-85mqwy-colorized.png",3)|Out-Null
}
