#!/usr/bin/env bash
# Clone this scaffold into a fresh app project so you can reuse it forever.
# Usage:
#   ./new-app.sh "Notesnook" https://app.notesnook.com
#
# It copies the scaffold to ../<slug>/, rewrites app.config.js and the
# package.json identity fields, and leaves you to drop in icons/icon.png.
set -euo pipefail
cd "$(dirname "$0")"

NAME="${1:-}"
URL="${2:-}"
if [[ -z "$NAME" || -z "$URL" ]]; then
  echo "Usage: ./new-app.sh \"App Name\" https://app.url"
  exit 1
fi

SLUG="$(echo "$NAME" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')"
DEST="../$SLUG"

if [[ -e "$DEST" ]]; then
  echo "ERROR: $DEST already exists."
  exit 1
fi

echo ">> Creating $DEST from scaffold..."
mkdir -p "$DEST"
cp -r src build.sh install.sh uninstall.sh new-app.sh package.json app.config.js "$DEST/"
mkdir -p "$DEST/icons" "$DEST/build"

# Rewrite app.config.js
cat > "$DEST/app.config.js" <<EOF
module.exports = {
  url: "$URL",
  name: "$NAME",
  wmClass: "$NAME",
  width: 1280,
  height: 800,
  openExternalInBrowser: true,
  allowedHosts: []  // tighten to e.g. ["notesnook.com"] if you want
};
EOF

# Rewrite the identity bits in package.json (name/productName/appId/exec)
APPID="com.adamandhisagents.$(echo "$SLUG" | tr -d '-')"
node - "$DEST/package.json" "$SLUG" "$NAME" "$APPID" <<'NODE'
const fs = require("fs");
const [file, slug, name, appId] = process.argv.slice(2);
const pkg = JSON.parse(fs.readFileSync(file, "utf8"));
pkg.name = slug;
pkg.productName = name;
pkg.description = name + " desktop app (Electron wrapper)";
pkg.build.appId = appId;
pkg.build.productName = name;
pkg.build.linux.executableName = slug;
pkg.build.linux.desktop.Name = name;
pkg.build.linux.desktop.Comment = name + " desktop app";
pkg.build.linux.desktop.StartupWMClass = name;
fs.writeFileSync(file, JSON.stringify(pkg, null, 2) + "\n");
NODE

echo
echo ">> Done. Next steps:"
echo "   1. Save a 512x512 PNG to $DEST/icons/icon.png"
echo "   2. cd $DEST"
echo "   3. ./build.sh   then   ./install.sh"
