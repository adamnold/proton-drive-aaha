# Proton Drive (AAHA)

A native **Proton Drive desktop app for Linux**, built with Electron by
**Adam And His Agents (AAHA)**. It wraps the official Proton Drive web app
(`https://drive.proton.me`) in a clean, standalone window that behaves like
a real desktop application — including a **stable taskbar icon that KDE
Plasma on Wayland will NOT swap for the generic browser icon**.

It also ships as a reusable scaffold: the same pattern wraps any web app
(see "Reuse for another app" below).

> **Unofficial / not affiliated with Proton.** This is a third-party
> wrapper. It is not endorsed by or affiliated with Proton AG. "Proton"
> and "Proton Drive" are trademarks of Proton AG. See `NOTICE` for details.
> Your use of Proton Drive remains subject to Proton's own Terms of Service.

---

## Why this exists

KDE on Wayland picks an app's panel icon from the window's `app_id`
(WM class) and matches it to a `.desktop` file. Chromium-based PWAs all
share Chromium's identity, so KDE falls back to the generic browser icon.

A real Electron app sets its **own** `app_id` (`app.setName()` + `--class`)
and ships a `.desktop` file whose `StartupWMClass` matches exactly. KDE
finds a unique match, so your icon sticks. That's the whole trick — done
properly instead of hacking icon themes.

---

## Requirements (Fedora / KDE example)

Node.js + npm, plus FUSE for running AppImages:

```bash
sudo dnf install nodejs npm fuse fuse-libs
```

(On Debian/Ubuntu: `sudo apt install nodejs npm libfuse2`.)

---

## Build & install

From the project folder:

```bash
chmod +x *.sh          # one time, make scripts executable
./build.sh             # installs deps, builds dist/ (first run downloads Electron, ~150MB)
./install.sh           # registers icon + .desktop with your desktop environment
```

Then open your app launcher, search "Proton Drive", launch it, and
pin it to your taskbar/panel. The icon stays.

Build outputs:
- `dist/linux-unpacked/` — the native unpacked app (what `install.sh` wires up)
- `dist/*.AppImage` — a portable single-file version you can move anywhere

To remove it later: `./uninstall.sh`

---

## Reuse for another app

This repo doubles as a scaffold. To wrap a different web app:

```bash
./new-app.sh "Notesnook" https://app.notesnook.com
cd ../notesnook
# drop a 512x512 PNG into icons/icon.png  (DevTools > Application > Manifest > Icons)
./build.sh && ./install.sh
```

`new-app.sh` copies the scaffold to a sibling folder and rewrites the
name / URL / appId / window class for you. You only supply the icon.

---

## Configuration (`app.config.js`)

| Field                   | Meaning                                                        |
|-------------------------|----------------------------------------------------------------|
| `url`                   | The web app to load.                                           |
| `name`                  | Display name (title, launcher, tooltip).                       |
| `wmClass`               | Window id — must equal `StartupWMClass` in package.json.       |
| `width` / `height`      | Initial window size.                                           |
| `openExternalInBrowser` | Send off-domain links to your real browser.                    |
| `allowedHosts`          | Host suffixes kept in-app; `[]` = allow all in-app navigation. |

> Note: `build.sh` syncs `app.config.js` and `icons/icon.png` into `src/`
> before building so they get packed into the app bundle (`app.asar`).
> Always edit the top-level `app.config.js` / `icons/icon.png`.

---

## Notes / gotchas

- **Disk:** each app bundles its own Electron runtime (~150–250 MB). Fine
  for a handful of pinned apps; don't wrap dozens.
- **Single instance:** clicking the icon focuses the existing window
  instead of opening duplicates.
- **No menu bar:** the app launches clean and chrome-less. Remove the
  `Menu.setApplicationMenu(null)` line in `src/main.js` if you want one.
- **Updates:** the bundled Electron does not auto-update. To refresh it,
  `npm install electron@latest --save-dev` then rebuild.

---

## License

Copyright 2026 **Adam And His Agents (AAHA)**.

The wrapper/launcher code in this repository is licensed under the
**Apache License, Version 2.0** — see `LICENSE`. This license applies only
to the code authored here; it does not cover Proton Drive, Proton's
software/service, or Proton's trademarks and logos. See `NOTICE`.

---

## Privacy hardening (v1.1+, on by default)

This app launches with Chromium background/phone-home subsystems disabled:
`disable-background-networking`, `disable-domain-reliability`,
`disable-component-update`, `disable-features=NetworkTimeServiceQuerying,
Translate,OptimizationHints,MediaRouter`, and `disable-breakpad`. The app
should only talk to Proton. To opt out, set `disableHardening: true` in
`app.config.js`. Verify with:

```bash
sudo tcpdump -n -i any 'port 53 or port 443' | grep -Ei 'google|gstatic|gvt|1e100'
```
