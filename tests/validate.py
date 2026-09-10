"""Read-only template and asset checks. Run with Python + PyYAML."""
from pathlib import Path
import json
import yaml

ROOT = Path(__file__).resolve().parents[1]
runtime = r"C:\Users\Test User\AppData\Local\Everforest-W11-Rice-V2\theme"
home = r"C:\Users\Test User"
tokens = {
    "{{RICE_ROOT_JSON}}": runtime.replace("\\", "\\\\"),
    "{{RICE_ROOT_POSIX}}": runtime.replace("\\", "/"),
    "{{RICE_ROOT}}": runtime,
    "{{USERPROFILE_JSON}}": home.replace("\\", "\\\\"),
    "{{USERPROFILE_POSIX}}": home.replace("\\", "/"),
    "{{USERPROFILE}}": home,
}

def render(text):
    for key, value in tokens.items():
        text = text.replace(key, value)
    return text

count = 0
for path in (ROOT / "configs").rglob("*"):
    if not path.is_file():
        continue
    text = render(path.read_text(encoding="utf-8-sig"))
    assert "Documents/Codex/" not in text, path
    assert "Documents\\Codex\\" not in text, path
    assert "{{RICE_ROOT" not in text, path
    if path.suffix == ".json":
        json.loads(text)
    if path.suffix == ".yaml":
        yaml.safe_load(text)
    count += 1

bar = yaml.safe_load(render((ROOT / "configs/YASB/config.yaml").read_text(encoding="utf-8")))
for name, settings in bar["bars"].items():
    assert settings["dimensions"]["height"] == 36
    assert settings["window_flags"]["windows_app_bar"]
    for widgets in settings["widgets"].values():
        assert all(widget in bar["widgets"] for widget in widgets), name
apps = bar["widgets"]["pinned_apps"]["options"]["app_list"]
assert len({app["name"] for app in apps}) == len(apps)
for app in apps:
    icon = app["icon"]
    assert icon.startswith(runtime), icon
    relative = icon[len(runtime) + 1:].replace("\\", "/")
    assert (ROOT / "assets" / relative).is_file(), relative
assert "%I:%M %p" in bar["widgets"]["clock"]["options"]["label"]
assert "lines" not in bar["bars"]["primary-bar"]["widgets"]["left"]
assert "AutoHotkey" not in (ROOT / "packages.json").read_text()
assert not (ROOT / "configs/Hotkeys/Backup").exists()
print(f"PASS: {count} templates; dock assets, schema parsing, paths with spaces, bar invariants.")
