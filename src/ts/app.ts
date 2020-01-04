const { app, BrowserWindow } = require("electron");
var mainWindow = null;
var isDev = process.env.APP_DEV ? (process.env.APP_DEV.trim() == "true") : false;

app.on("window-all-closed", function() {
  app.quit();
});

if (isDev) {
  require("electron-reload")(__dirname);
}

app.on("ready", function() {
  mainWindow = new BrowserWindow({
    width: 225,
    height: 225,
    transparent: true,
    frame: false,
    alwaysOnTop: true,
    resizable: false
  });
  mainWindow.loadURL("file://" + __dirname + "/index.html");
  mainWindow.on("closed", function() {
    mainWindow = null;
  });
});
