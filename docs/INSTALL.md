# Installation and remaining steps

Run Install.cmd from a permanent checkout on Windows 11 x64. Elevation must use the same Windows account: signing in as a different administrator would configure that administrator's profile. Package installers may request their own elevation. `-Plan` is read-only; `-SkipPackages`, `-SkipSystem` and `-NoStartup` support incremental setup.

## First-time steps

1. In Windhawk, install Windows 11 Taskbar Styler, Windows 11 Start Menu Styler, Windows 11 Notification Center Styler, Taskbar height and icon size (`taskbar-icon-size`), and Resource Redirect. Rerun `Install.ps1 -SkipPackages` to apply their saved settings. The installer deliberately does not inject unsupported Windhawk installation state or compile unreviewed mods. Explorer Styler is excluded because the previous layout broke caption buttons.
2. Import `configs/Helium` as an unpacked browser theme using the directory containing manifest.json. Install Bonjourr and Dark Reader through the browser's extension store, then use their import controls. Dark Reader's JSON is a theme fragment: merge it with an exported settings file rather than replacing all preferences.
3. Install Vencord through its official installer if wanted, then enable the provided theme. Spicetify is excluded. Browser/Discord security controls are not bypassed.
4. Select Everforest Fusion in VSCodium and Everforest in btop. Open Flow once and rerun if its settings did not exist. Close Flow before reapplying its settings so it cannot overwrite the change on exit.
5. Fluver and FluentFlyout are optional Microsoft Store applications. Their current icons and integration details are in the private snapshot; packaged Start-menu artwork is not automatically replaced. No Store account is signed into automatically.
6. The installer downloads and sets the primary garden wallpaper. Choose another image from ASSETS.md if preferred. Select the same image for the lock screen through Windows Personalization; no lock-screen system files are patched.

## Behavior and limits

- Installer package failures and missing integrations are listed in `%LOCALAPPDATA%\Everforest-W11-Rice-V2\NEXT-STEPS.txt`.
- Taskbar Hide and Alt-Tabby are downloaded from pinned, SHA256-checked releases. Font installation is handled by WinGet.
- Startup runs Komorebi, whkd and the bar. Taskbar Hide starts before YASB reserves 36 pixels. App processes are checked to reduce duplicate launches.
- Existing custom startup entries from another rice may still conflict. Do not enable additional whkd/YASB startup mechanisms alongside this one.
- Templates include conner's application choices, two-monitor layout and app-specific rules. Adjust Komorebi's monitor list and the YASB dock for your system. Icons do not install the applications they depict.
- Icon redirection maps use installed file/resource paths. App updates and different installation locations can require regeneration.
- There is no clean-VM end-to-end verification yet. Parser, template and dry-run checks do not prove that every third-party installer will succeed.

## Restore

Pass a timestamped backup folder to Restore.ps1. File and registry backups are captured before replacement. Directory backups are staged as `.restored` for review; packages are never uninstalled. Sign out after a system restore. New registry subkeys may remain because importing .reg files restores values rather than deleting every added key.
