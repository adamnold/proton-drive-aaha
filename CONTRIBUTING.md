# Contributing to Proton Drive (AAHA)

Thanks for your interest in improving this project. It's a small, focused
Electron wrapper maintained by **Adam And His Agents (AAHA)**, and
contributions are welcome.

> Reminder: this is an **unofficial** wrapper, not affiliated with Proton AG.
> Please don't open issues here about Proton Drive's web app or service
> itself — those belong with Proton. Issues here should be about the
> wrapper, build scripts, packaging, or desktop integration.

---

## Ways to contribute

- **Bug reports** — something fails to build, install, or launch.
- **Desktop integration fixes** — icon/`.desktop`/WM-class behavior on a
  specific desktop environment (GNOME, KDE, XFCE) or display server
  (Wayland vs X11).
- **Packaging** — improving the AppImage build, adding `.rpm`/`.deb`
  targets, or other distro support.
- **Docs** — clarifying the README or these guidelines.

---

## Reporting a bug

Please open an issue and include:

1. **Distro + version** (e.g. Fedora KDE 44) and **display server**
   (`echo $XDG_SESSION_TYPE` → `wayland` or `x11`).
2. **Node version** (`node -v`) and how you installed it.
3. **What you ran** and the **full terminal output**, especially anything
   printed when you run the unpacked binary directly:
   ```bash
   ./dist/linux-unpacked/proton-drive
   ```
4. What you expected vs. what happened.

The single most useful thing is the terminal output from running the
binary directly — most launch issues (missing modules, Wayland/Ozone,
GPU) show their root cause there.

---

## Development setup

```bash
git clone https://github.com/adamnold/proton-drive-aaha.git
cd proton-drive-aaha
chmod +x *.sh
npm install          # install dependencies
npm start            # run the app unpackaged for quick iteration
```

Build a distributable:

```bash
./build.sh           # produces dist/linux-unpacked/ and dist/*.AppImage
./install.sh         # registers icon + .desktop locally
./uninstall.sh       # removes the local install
```

### Project layout

| Path             | Purpose                                                  |
|------------------|----------------------------------------------------------|
| `src/main.js`    | Electron main process (window, WM class, link handling). |
| `app.config.js`  | Per-app settings (url, name, window class, size).         |
| `package.json`   | electron-builder config + the generated `.desktop` fields.|
| `build.sh`       | Sync config/icon into `src/`, install deps, build.        |
| `install.sh`     | Install icon + `.desktop`, refresh desktop caches.        |
| `new-app.sh`     | Clone the scaffold to wrap a different web app.           |

> `build.sh` copies `app.config.js` and `icons/icon.png` into `src/` so
> they get packed into `app.asar`. Edit the **top-level** files, not the
> copies in `src/`.

---

## Pull requests

1. Fork the repo and create a branch: `git checkout -b fix/short-description`.
2. Keep changes focused; one logical change per PR.
3. Test the locked build, disposable default/custom install roots, guarded
   uninstall, profile preservation, explicit purge, and application launch.
4. Describe what you changed and on which distro/DE you tested it.
5. Open the PR against `master`.

---

## License of contributions

By contributing, you agree that your contributions are licensed under the
**Apache License, Version 2.0**, the same license as this project
(see `LICENSE`). Do not contribute code you don't have the right to
license this way.
