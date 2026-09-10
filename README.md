# Everforest W11 Rice V2

A sage, charcoal and warm-cream Windows 11 desktop, assembled by **conner** with implementation assistance from **OpenAI Codex**.

Built from MrDLingters’ Everforest Windows themes, with a compact YASB bar, app dock, fullscreen power menu, Ryoku-inspired Alt shortcuts, WezTerm, Starship/Fastfetch, themed shell menus, cursors, icons and original soft notification sounds.

## Install

Windows 11 x64, WinGet/App Installer, internet access and an administrator account are required. Extract or clone the repository into a permanent location, then double-click **Install.cmd**. Approve the Windows elevation prompt. The installer skips packages already installed and records unsuccessful steps rather than silently claiming success.

Preview without changing anything:

```powershell
.\Install.ps1 -Plan
```

Reapply themes without downloading applications:

```powershell
.\Install.ps1 -SkipPackages
```

The default installation lives in `%LOCALAPPDATA%\Everforest-W11-Rice-V2`. Existing configuration files are backed up before replacement. Read [installation details](docs/INSTALL.md) for the remaining Windhawk, browser and Store steps. This is a mostly automated installer, **not a verified zero-click fresh-Windows deployment**.

## Included

- YASB: compact bottom bar, 12-hour clock, pinned app icons, blurred power menu, fullscreen hiding and reserved desktop space.
- Komorebi + whkd: Alt-based navigation; Alt+W closes; Alt+Plus/Minus resizes by 80. Flow uses Alt+Space.
- WezTerm without a title bar, Starship prompt, square Windows Fastfetch logo, zoxide/eza/bat/fzf/btop/CAVA styling.
- Windhawk Start, taskbar, notification-center and resource-icon settings; Nilesoft menu styling.
- Bibata Everforest cursors, app/system icon assets and Soft Chimes sounds.
- VSCodium, Vencord/System24, Helium, Bonjourr and Dark Reader theme files.

Spicetify, Sigma, the retired AHK hotkey layer, and the broken Explorer Styler layout are excluded from deployment. The installer does not uninstall Windows Terminal or any other application.

## Repository layout

| Path | Purpose |
|---|---|
| `Install.ps1`, `Install.cmd` | Installer and double-click entry point |
| `Restore.ps1` | Restore an explicit installer backup |
| `configs/` | Portable configuration templates |
| `assets/` | Icons, resource-only DLLs, cursors and sounds |
| `scripts/` | Configuration, downloads and startup helpers |
| `tests/` | Read-only validation |
| `docs/` | Installation, credits, asset provenance and limitations |
| `.local/` | Ignored machine-specific working archive; not part of a clone |

The DLLs under `assets/Icons` contain icon resources, not application executables. Application installers are downloaded from their upstream package sources. Wallpapers are linked separately in [asset provenance](docs/ASSETS.md).

## Restore

```powershell
.\Restore.ps1 -Backup "$env:LOCALAPPDATA\Everforest-W11-Rice-V2\backups\<timestamp>"
```

Use an elevated PowerShell when restoring system registry settings. Restore does not uninstall packages. Directory backups are staged for review rather than recursively deleting user data.

See [credits](CREDITS.md) and [licensing](NOTICE.md). No ownership of upstream artwork, application logos or Windows resources is claimed.
