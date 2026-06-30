#!/usr/bin/env bash
# Build the Electron app into an unpacked native directory + AppImage.
# Run from the project root:  ./build.sh
set -euo pipefail
cd "$(dirname "$0")"

# Keep the bundled copies in sync with the editable top-level files.
# main.js requires ./app.config.js and ./icon.png from INSIDE src/ so they
# get packed into app.asar. We refresh them from the top-level originals
# here, so you can keep editing app.config.js / icons/icon.png as documented.
echo ">> Syncing config + icon into src/ (so they bundle into the asar)..."
cp -f app.config.js src/app.config.js
[ -f icons/icon.png ] && cp -f icons/icon.png src/icon.png

echo ">> Installing dependencies (first run downloads Electron, ~150MB)..."
npm install

echo ">> Building Linux targets (dir + AppImage)..."
npm run dist

echo
echo ">> Done. Outputs are in ./dist/"
echo "   - Unpacked app:  ./dist/linux-unpacked/   (run the executable inside)"
echo "   - AppImage:      ./dist/*.AppImage         (portable single file)"
echo
echo "Next: run ./install.sh to register the app with KDE (icon + .desktop)."
