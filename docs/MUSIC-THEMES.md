# Everforest Fusion music themes

Both themes use the rice's charcoal `#272E33`, sage `#A7C080`, warm cream `#D3C6AA` and muted green-gray surfaces. They retain album artwork, native navigation and player layout, with square panel edges and gold keyboard focus outlines. No external CSS, fonts or JavaScript are loaded.

## Installer behavior

Run `Install.ps1 -SkipPackages` to deploy alongside the rice. If `%APPDATA%\spicetify` or `%APPDATA%\C2Windows` exists, the installer copies that theme using its normal file backups. Otherwise it leaves the theme in the runtime `theme\Spicetify` or `theme\Cider` directory and records a next step. It does not install music apps, activate themes, or patch Spotify automatically. Custom/portable profile locations need manual copying.

## Spotify / Spicetify

Install and initialize Spotify and [Spicetify](https://spicetify.app/docs/getting-started) first. The theme follows the [official theme format](https://spicetify.app/docs/development/themes).

1. Copy `configs\Spicetify\Everforest-Fusion` into `%APPDATA%\spicetify\Themes`, unless the rice installer already copied it. The resulting folder must directly contain `color.ini` and `user.css`. Back up an existing folder of the same name before a manual replacement.
2. Record your current settings with `spicetify config` so you can switch back.
3. In a normal, non-administrator PowerShell, run:

```powershell
spicetify config current_theme Everforest-Fusion color_scheme Everforest
spicetify config inject_css 1 replace_colors 1
spicetify apply
```

On a first-time Spicetify setup, use `spicetify backup apply` instead of the last command. After Spotify updates, follow Spicetify's update guidance if applying fails. To switch back, restore your previous theme, scheme and injection settings and run `spicetify apply`; `spicetify restore` removes Spicetify's modifications entirely.

### Windows title-bar controls

Install and enable [CEF/Spotify Tweaks](https://windhawk.net/mods/cef-titlebar-enabler-universal) in Windhawk. The rice installer applies `configs/Windhawk/SpotifyControls.json` when the mod is installed: native frames off, Spotify window controls visible, and their background transparent. Other mod preferences are preserved. Restart Spotify afterward.

If the mod is missing, the installer records a reminder to install it and rerun. This configuration runs in the system settings stage, so `-SkipSystem` skips it. CSS alone cannot reliably recolor these native controls; the ineffective CSS overlay has been removed.

## Cider 2


Requires Cider 2.5.0 or newer, per [Cider ThemeKit](https://github.com/ciderapp/Cider-ThemeKit). This is a ThemeKit theme for [Cider 2](https://github.com/ciderapp/Cider-2), not the legacy Cider 1 format.

1. Open Cider once, then fully quit it.
2. Copy `configs\Cider\Everforest-Fusion` into `%APPDATA%\C2Windows\themes`, unless the installer already copied it. The resulting folder must directly contain `theme.yml` and `main.css`. Back up an existing folder of the same name before a manual replacement. For a different Cider profile location, use its themes directory instead.
3. Reopen Cider, select dark appearance, and select **Everforest Fusion / Everforest Dark** in its theme controls. Labels and placement can vary by release.

To undo, disable the theme in Cider or select your previous theme. The overrides only apply to dark appearance. Acrylic and artwork-driven surfaces can still affect the result.

## Validation and compatibility

The theme manifests and installer wiring were checked locally. Neither player was available for live visual verification. Spotify class names and Cider component markup can change between releases; the Cider theme uses documented viewport/NavigationButton hooks plus semantic controls, but not every app surface is guaranteed to expose those hooks. Check the library, search, queue, menus, player controls and keyboard focus after activation. Report the player version and affected screen if a surface retains its default styling.

