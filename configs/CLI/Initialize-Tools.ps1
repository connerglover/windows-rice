# Refresh newly installed per-user command paths in already-running terminal hosts.
foreach($entry in (([Environment]::GetEnvironmentVariable('Path','Machine')+';'+[Environment]::GetEnvironmentVariable('Path','User')) -split ';')) {
    if($entry -and ($env:Path -split ';') -notcontains $entry){$env:Path+=';'+$entry}
}
$env:BAT_THEME='Everforest Fusion'
$env:BAT_STYLE='numbers,changes,header'
$env:EZA_COLORS='di=38;2;167;192;128:ex=38;2;219;188;127:ln=38;2;127;187;179:fi=38;2;211;198;170'
$env:FZF_DEFAULT_OPTS='--height=40% --layout=reverse --border=rounded --color=bg:#272e33,bg+:#374145,fg:#d3c6aa,fg+:#d3c6aa,hl:#a7c080,hl+:#b5cb94,border:#475258,prompt:#a7c080,pointer:#dbbc7f,marker:#d699b6,info:#859289,spinner:#a7c080'
if(Get-Command eza.exe -ErrorAction SilentlyContinue){
    function global:Invoke-EverforestList { & eza.exe --icons=auto --group-directories-first @args }
    Set-Alias -Name ls -Value Invoke-EverforestList -Scope Global -Force
    function global:ll { & eza.exe --long --header --icons=auto --group-directories-first @args }
    function global:lt { & eza.exe --tree --level=2 --icons=auto @args }
}
if(Get-Command bat.exe -ErrorAction SilentlyContinue){Set-Alias -Name cat -Value bat.exe -Scope Global -Force}
if(Get-Command zoxide.exe -ErrorAction SilentlyContinue){Invoke-Expression (& zoxide.exe init powershell --cmd cd | Out-String)}
if(Get-Command btop4win.exe -ErrorAction SilentlyContinue){Set-Alias -Name btop -Value btop4win.exe -Scope Global -Force}
if(Get-Command cava.exe -ErrorAction SilentlyContinue){
    $global:EverforestCavaConfig=Join-Path $PSScriptRoot 'cava-config'
    function global:cava { & cava.exe -p $global:EverforestCavaConfig @args }
}
# Interactive file picker; returns the selected path without opening it.
function global:ff { & fzf.exe @args }
