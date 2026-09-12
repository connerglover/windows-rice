# SumatraPDF: Everforest Fusion

Custom theme for SumatraPDF 3.6 and later: charcoal surfaces, cream text, sage links and selection, gold highlights, sage underlines, mauve squiggles and rose strikeouts. Uses the supported native control colorization; exact hover and title-bar styling is controlled by SumatraPDF.

Close SumatraPDF, then run `powershell -NoProfile -ExecutionPolicy Bypass -File scripts/Install-SumatraTheme.ps1` from the repository. Portable installations can supply `-SettingsPath` pointing to their settings file.

The installer preserves document history, other custom themes and unrelated preferences. It backs up the settings under `.local/Sumatra-theme-backup-*`. Restore that file while SumatraPDF is closed to undo. This is a standalone installer; it does not install the application.

Theme by conner and OpenAI Codex, using the Everforest palette. [SumatraPDF 3.6 settings reference](https://www.sumatrapdfreader.org/settings/settings3-6.html).

The Recently Opened start page is disabled because SumatraPDF 3.6.1 hard-codes its promotional footer to white. Saved document history is preserved. Set ShowStartPage = true to restore the page (and footer).
