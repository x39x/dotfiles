local hk = require("hs.hotkey")
local lanuchOrFocusApp = require("app").lanuchOrFocusApp
local windowManager = require("window").windowManager
local FocusDesktop = require("app").FocusDesktop

-- launch or focue app
hk.bind({ "ctrl", "alt", "cmd", "shift" }, "f", lanuchOrFocusApp("Safari"))
hk.bind({ "ctrl", "alt", "cmd", "shift" }, "d", lanuchOrFocusApp("Alacritty"))
hk.bind({ "ctrl", "alt", "cmd", "shift" }, "t", FocusDesktop())

-- window manager
hk.bind({ "ctrl", "alt", "cmd", "shift" }, "q", windowManager("fullScreen"))
hk.bind({ "ctrl", "alt", "cmd", "shift" }, "s", windowManager("max"))
hk.bind({ "ctrl", "alt", "cmd", "shift" }, "c", windowManager("center"))
hk.bind({ "ctrl", "cmd", "shift" }, "right", windowManager("right"))
hk.bind({ "ctrl", "cmd", "shift" }, "left", windowManager("left"))
hk.bind({ "ctrl", "cmd", "shift" }, "down", windowManager("bottom"))
hk.bind({ "ctrl", "cmd", "shift" }, "up", windowManager("top"))
