"use strict";
module.exports = {
  schemaVersion: 2, configured: true,
  repoName: "proton-drive-aaha", productName: "Proton Drive",
  appId: "com.adamandhisagents.protondrive", executable: "proton-drive-aaha",
  iconName: "proton-drive-aaha", profileName: "Proton Drive",
  legacyProfileNames: [], compatibilityDesktopIds: ["proton-drive"],
  url: "https://drive.proton.me", trustedNavigationHosts: ["proton.me"], trustedAuthHosts: [],
  permissions: { "clipboard-sanitized-write": ["proton.me"] },
  blockedHosts: ["clients2.google.com", "clients4.google.com", "update.googleapis.com", "safebrowsing.googleapis.com", "optimizationguide-pa.googleapis.com", "redirector.gvt1.com", "google-analytics.com", "www.google-analytics.com", "stats.g.doubleclick.net"],
  externalProtocols: ["http:", "https:", "mailto:"], openExternalLinks: true,
  width: 1360, height: 860, category: "Network;FileTransfer;",
  comment: "Encrypted cloud storage by Proton", keywords: "drive;storage;files;proton;"
};
