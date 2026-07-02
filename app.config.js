// ============================================================
//  APP CONFIG  —  This is the ONLY file you edit per app.
//  Change these values, swap the icon in icons/, rebuild.
// ============================================================
module.exports = {
  // The web app you want to wrap:
  url: "https://drive.proton.me",

  // Display name (shows in title bar, launcher, panel tooltip):
  name: "Proton Drive",

  // Wayland/X11 window identity. MUST match productName in package.json
  // and StartupWMClass in the .desktop file so KDE keeps your icon.
  wmClass: "Proton Drive",

  // Initial window size:
  width: 1280,
  height: 800,

  // Open external links (e.g. links that leave the app's domain)
  // in your real browser instead of inside the app window:
  openExternalInBrowser: true,

  // Restrict in-app navigation to these host suffixes. Anything else
  // opens in the external browser. Keeps the wrapper feeling like ONE app.
  // Leave as [] to allow all in-app navigation.
  allowedHosts: ["proton.me"],

  // PRIVACY HARDENING (default: ON). Disables Chromium's background
  // networking, domain-reliability beacons, component updates, network-time
  // queries, translate, optimization hints, and crash metrics, so the app
  // only talks to Proton. Set to true only if something breaks.
  disableHardening: false
};
