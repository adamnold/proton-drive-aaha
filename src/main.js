const { app, BrowserWindow, shell, Menu } = require("electron");
const path = require("path");
const cfg = require("./app.config.js");

// Set the Wayland/X11 app id BEFORE the app is ready so KDE associates
// the window with the correct .desktop entry and keeps your custom icon.
app.setName(cfg.name);
if (process.platform === "linux") {
  // This is what KDE Plasma reads as the WM class on Wayland.
  app.commandLine.appendSwitch("class", cfg.wmClass);
}

let mainWindow;

function hostMatches(urlString) {
  if (!cfg.allowedHosts || cfg.allowedHosts.length === 0) return true;
  try {
    const host = new URL(urlString).hostname;
    return cfg.allowedHosts.some(
      (h) => host === h || host.endsWith("." + h)
    );
  } catch (e) {
    return false;
  }
}

function createWindow() {
  mainWindow = new BrowserWindow({
    width: cfg.width,
    height: cfg.height,
    title: cfg.name,
    autoHideMenuBar: true,
    icon: path.join(__dirname, "icon.png"),
    webPreferences: {
      contextIsolation: true,
      nodeIntegration: false,
      spellcheck: true
    }
  });

  mainWindow.loadURL(cfg.url);

  // Links that open a NEW window/tab -> send to system browser if external.
  mainWindow.webContents.setWindowOpenHandler(({ url }) => {
    if (cfg.openExternalInBrowser && !hostMatches(url)) {
      shell.openExternal(url);
      return { action: "deny" };
    }
    return { action: "allow" };
  });

  // In-page navigation to a foreign host -> bounce to system browser.
  mainWindow.webContents.on("will-navigate", (event, url) => {
    if (cfg.openExternalInBrowser && !hostMatches(url)) {
      event.preventDefault();
      shell.openExternal(url);
    }
  });
}

// Single-instance lock: clicking the panel icon focuses the existing
// window instead of spawning a second copy.
const gotLock = app.requestSingleInstanceLock();
if (!gotLock) {
  app.quit();
} else {
  app.on("second-instance", () => {
    if (mainWindow) {
      if (mainWindow.isMinimized()) mainWindow.restore();
      mainWindow.focus();
    }
  });

  app.whenReady().then(() => {
    Menu.setApplicationMenu(null); // clean, app-like (no menu bar)
    createWindow();
    app.on("activate", () => {
      if (BrowserWindow.getAllWindows().length === 0) createWindow();
    });
  });

  app.on("window-all-closed", () => {
    if (process.platform !== "darwin") app.quit();
  });
}
