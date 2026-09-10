local wezterm = require 'wezterm'
local config = wezterm.config_builder()
config.default_prog = {os.getenv('LOCALAPPDATA') .. '\\Microsoft\\WindowsApps\\pwsh.exe', '-NoLogo'}
config.default_cwd = wezterm.home_dir
config.font = wezterm.font_with_fallback {'JetBrainsMono Nerd Font', 'Cascadia Mono', 'Segoe UI Emoji'}
config.font_size = 11.5
config.line_height = 1.08
config.initial_cols = 112
config.initial_rows = 30
config.window_padding = {left=18, right=18, top=14, bottom=12}
config.window_background_opacity = 1.0
config.use_fancy_tab_bar = false
config.tab_max_width = 26
config.hide_tab_bar_if_only_one_tab = false
config.default_cursor_style = 'BlinkingBar'
config.audible_bell = 'Disabled'
config.scrollback_lines = 10000
config.colors = {
 foreground='#D3C6AA', background='#272E33', cursor_bg='#A7C080', cursor_fg='#272E33', cursor_border='#A7C080',
 selection_bg='#47534A', selection_fg='#D3C6AA', split='#475258',
 ansi={'#374145','#E67E80','#A7C080','#DBBC7F','#7FBBB3','#D699B6','#83C092','#D3C6AA'},
 brights={'#859289','#E67E80','#B5CB94','#E5C890','#8FCBC3','#E3A6C4','#93D0A2','#E4D8BE'},
 tab_bar={background='#232A2E', active_tab={bg_color='#A7C080',fg_color='#272E33',intensity='Bold'},
 inactive_tab={bg_color='#2F383E',fg_color='#D3C6AA'},inactive_tab_hover={bg_color='#414B50',fg_color='#D3C6AA'},
 new_tab={bg_color='#232A2E',fg_color='#A7C080'},new_tab_hover={bg_color='#374145',fg_color='#D3C6AA'}}
}
config.window_frame = {active_titlebar_bg='#272E33',inactive_titlebar_bg='#272E33'}
wezterm.on('update-right-status', function(window,pane)
 window:set_right_status(wezterm.format {{Foreground={Color='#859289'}},{Text='  EVERFOREST  ·  ' .. wezterm.strftime('%H:%M') .. '  '}})
end)
config.window_decorations = 'RESIZE'
return config

