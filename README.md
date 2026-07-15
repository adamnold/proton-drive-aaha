# Proton Drive for Linux — AAHA

Unofficial Proton Drive Electron desktop app for Fedora KDE with a stable Wayland taskbar icon.

## Privacy notice

Electron is Chromium-based. The wrapper reduces optional Chromium background traffic and adds no AAHA telemetry, but Proton Drive, authentication, CDNs, Docs/Sheets, and sharing services remain required. It cannot promise a completely Google-free or independently auditable runtime. See PRIVACY.md.

File/folder upload, drag-and-drop, download, ZIP download, sharing, and Proton authentication use the web application’s normal browser mechanisms without exposing Node APIs.

Run `./build.sh` and then `./install.sh`. The AppImage can run directly from any
location. Optional desktop integration defaults to
`~/.local/opt/aaha/proton-drive-aaha`; pass
`--install-root /absolute/path/proton-drive-aaha` to choose another
per-application root. Normal uninstall preserves `~/.config/Proton Drive`;
`--purge` removes it only after receipt and marker validation.

This project is unofficial and is not affiliated with Proton.
