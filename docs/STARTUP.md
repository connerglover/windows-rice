# Coordinated startup

`scripts/Register-Startup.ps1 -Root <rendered-theme-folder>` registers two stages for the current interactive user. Run it elevated under that same account. Add `-StartNow` to exercise the sequence without signing out.

1. **Everforest Startup Core** starts after a five-second sign-in delay, at the highest available privilege. It waits for Explorer, preserves stale Komorebi IPC data only when Komorebi is absent, starts the daemon directly, and checks its IPC response before starting whkd. Direct invocation avoids the nested PowerShell quoting problem in `komorebic start`.
2. **Everforest Startup Desktop** starts after eight seconds with normal user privileges. It waits up to 45 seconds for Komorebi, then starts the writable Alt-Tabby installation, Flow, Taskbar Hide and YASB. Taskbar Hide gets three seconds to change the native AppBar state before YASB reserves its space. If Komorebi fails, the desktop stage logs the problem and still provides a usable bar.

Each stage has a session mutex and the scheduler ignores overlapping runs. Already-running processes are preserved. Failed task runs have two retries, one minute apart. This is bounded startup recovery, not a watchdog that reopens applications you deliberately close.

Old known Komorebi/Everforest tasks are backed up as XML and disabled. Unrelated startup apps are left alone. Flow's native Run entry is backed up and removed to avoid a second launcher racing the coordinator.

Logs live under `<theme>/logs`: `startup-Core.log`, `startup-Desktop.log`, and separate daemon stdout/stderr files. A scheduler result of zero alone is not enough to establish health; look for `Komorebi IPC ready` and each stage's `Completed` entry. The socket quarantine is retained next to `%LOCALAPPDATA%\komorebi`.

Alt-Tabby must have exactly one `[Setup]` section, `FirstRunCompleted=true`, `RunAsAdmin=false`, and `ExePath` pointing to the executable beside its writable config. An unrelated Program Files installation can remain installed, but must not also start automatically.

The installer writes Alt-Tabby's INI as UTF-16LE for compatibility with Windows INI APIs. The full current-version template is included so startup does not need to reconstruct a partial file. Launcher diagnostics are enabled; `%TEMP%\tabby_launcher.log` records mutex acquisition and GUI/worker readiness.

Live verification on September 9, 2026: both tasks returned zero; Komorebi returned a valid IPC state; Alt-Tabby acquired its mutex and started its GUI and pump from the writable theme folder. Repeating startup preserved existing process IDs. A new sign-in remains the final boot-specific check.

Display changes: the desktop stage starts Watch-DisplayLayout.ps1. It waits for monitor/resolution change events, lets changes settle for four seconds, and reloads an already-running YASB to rebuild its appbar reservation. A session mutex prevents duplicate watchers. This handles stale reserved space after virtual-display connections; it does not change streaming resolution or restart Komorebi.

Startup recovery: Core retries Komorebi readiness up to six times to tolerate foreground-access denial during login. The display watcher polls fresh monitor bounds every three seconds, waits for three matching readings, then reloads YASB and retiles Komorebi. Its log is in LOCALAPPDATA/Everforest-display-layout.log. Reboot and remote-resolution transitions still require live acceptance testing.
