# Everforest Fusion media themes

ImageGlass 10: import `dist/Everforest-Fusion.conner.igtheme.zip`, or close ImageGlass and run `scripts/Install-MediaThemes.ps1`. The theme colors all six supported palette fields and recolors the complete Kobe toolbar SVG set: sage navigation, gold zoom, cream editing, soft red destructive actions. Image content and color management are untouched. Some native dialogs and title-bar colors remain controlled by Windows/ImageGlass.

MPV: uosc 5.13.0 supplies the controller, searchable menus, volume/speed sliders, timeline, chapter markers and borderless window controls. Tab toggles the UI, right-click opens its menu, Ctrl+P opens the playlist and Ctrl+O opens the file browser. Its custom palette uses sage foregrounds, cream menu text and charcoal panels. Media color processing and subtitle styles remain unchanged.

Reinstall both with `powershell -NoProfile -ExecutionPolicy Bypass -File scripts/Install-MediaThemes.ps1`. Close ImageGlass first. Backups are stored under `.local/Media-theme-backup-*`. Restore the backed-up MPV directory and ImageGlass settings to undo. Existing MPV input settings are retained outside a managed block. For portable MPV use `-MpvConfig` with its actual portable_config path; for portable ImageGlass use `-ImageGlassConfig` with the folder containing igconfig.json. Other OSC scripts must be disabled separately if present.

uosc release archive: https://github.com/tomasklaen/uosc/releases/tag/5.13.0
Archive SHA256: 4BE9DA3289285300FA374496C3F1BFD7BB20AC08E890D25BD5A06B28EEBE4882
Source including the bundled helper: https://github.com/tomasklaen/uosc/tree/5.13.0
The release's scripts and fonts are preserved unmodified under assets/mpv. See docs/licenses/uosc-LICENSE (LGPL). ImageGlass Kobe SVGs are derived from ImageGlass 10.0.6.906 by Duong Dieu Phap; see docs/licenses/ImageGlass-LICENSE (GPL). Palette, theme configuration and preview composition by conner and OpenAI Codex.

Validation: ImageGlass theme loaded in installed Store version 10; MPV loaded uosc and the options without configuration errors. The custom UI was inspected in the desktop apps. ImageGlass accepts only its documented theme fields, so this is not a replacement of every native Windows dialog.
