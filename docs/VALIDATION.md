# Validation record

Validated locally on Windows 11 on September 9, 2026:

- All deployable PowerShell files parsed successfully.
- Installer `-Plan` completed without applying settings or installing packages.
- 34 configuration templates passed JSON/YAML and path checks, including a simulated username containing a space.
- All nine YASB dock icon references resolve to included assets.
- Bar widget references, 36-pixel reservation, 12-hour format, unique dock entries and removal of separators were checked.
- Pinned Alt-Tabby and Taskbar Hide downloads were fetched and SHA256 values recorded.
- The existing desktop snapshot was copied into the ignored `.local/current` directory. Existing Everforest task paths and live theme references were migrated there. The original directory is retained for loaded resources and compatibility.

Not yet verified: end-to-end fresh Windows installation, every WinGet installer, interactive browser imports, and restore of a complete Windows desktop. CI only validates templates and scripts. A successful dry run must not be represented as a successful clean-machine installation.
