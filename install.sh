#!/usr/bin/env bash
# Installs the built Electron app into your user environment so KDE Plasma
# shows it as a real, pinnable app with the correct icon on Wayland.
#
# Run AFTER ./build.sh, from the project root:  ./install.sh
set -euo pipefail
cd "$(dirname "$0")"

# ---- Read identity from app.config.js (kept in sync, single source) ----
APP_NAME="$(node -p "require('./app.config.js').name")"
WM_CLASS="$(node -p "require('./app.config.js').wmClass")"
APP_URL="$(node -p "require('./app.config.js').url")"

# slug: lowercase, spaces -> dashes  (e.g. "Proton Drive" -> "proton-drive")
SLUG="$(echo "$APP_NAME" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')"

# ---- Locate the built unpacked binary ----
BIN_DIR="$PWD/dist/linux-unpacked"
BIN_PATH="$BIN_DIR/$SLUG"
if [[ ! -x "$BIN_PATH" ]]; then
  # electron-builder sometimes names the binary after productName lowercased
  BIN_PATH="$(find "$BIN_DIR" -maxdepth 1 -type f -executable | head -n1 || true)"
fi
if [[ -z "${BIN_PATH:-}" || ! -x "$BIN_PATH" ]]; then
  echo "ERROR: Could not find the built executable in $BIN_DIR"
  echo "Did you run ./build.sh first?"
  exit 1
fi
echo ">> Using binary: $BIN_PATH"

# ---- Install the icon into the hicolor theme (512x512) ----
ICON_DEST="$HOME/.local/share/icons/hicolor/512x512/apps"
mkdir -p "$ICON_DEST"
cp "icons/icon.png" "$ICON_DEST/$SLUG.png"
echo ">> Icon installed: $ICON_DEST/$SLUG.png"

# ---- Write the .desktop file ----
APPS_DIR="$HOME/.local/share/applications"
mkdir -p "$APPS_DIR"
DESKTOP_FILE="$APPS_DIR/$SLUG.desktop"

cat > "$DESKTOP_FILE" <<EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=$APP_NAME
Comment=$APP_NAME desktop app
Exec="$BIN_PATH" %U
Icon=$SLUG
Terminal=false
Categories=Network;
StartupWMClass=$WM_CLASS
StartupNotify=true
EOF
echo ">> Desktop entry written: $DESKTOP_FILE"

# ---- Refresh caches so KDE picks it up immediately ----
update-desktop-database "$APPS_DIR" 2>/dev/null || true
gtk-update-icon-cache "$HOME/.local/share/icons/hicolor" 2>/dev/null || true
kbuildsycoca6 2>/dev/null || kbuildsycoca5 2>/dev/null || true

echo
echo ">> Installed '$APP_NAME'."
echo "   Search for it in the KDE launcher, open it, then right-click its"
echo "   panel entry -> Pin to Task Manager. The icon should stick."
