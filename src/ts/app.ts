import { app, BrowserWindow } from "electron";
let mainWindow: BrowserWindow | null = null;
let isDev = process.env.APP_DEV ? process.env.APP_DEV.trim() == "true" : false;

app.on("window-all-closed", () => app.quit());

if (isDev) require("electron-reload")(__dirname);

app.whenReady().then(() => {
  mainWindow = new BrowserWindow({
    width: 225,
    height: 225,
    transparent: true,
    frame: false,
    alwaysOnTop: true,
    resizable: false,
  });
  mainWindow.loadURL("file://" + __dirname + "/index.html");
  mainWindow.on("closed", () => {
    mainWindow = null;
  });
});
