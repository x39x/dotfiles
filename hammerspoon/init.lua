local hk = require("hs.hotkey")
local launchOrFocus = require("app").launchOrFocus
local windowManager = require("window").windowManager
local FocusDesktop = require("app").FocusDesktop

-- launch or focue app
hk.bind({ "ctrl", "alt", "cmd", "shift" }, "f", launchOrFocus("com.google.Chrome"))
hk.bind({ "ctrl", "alt", "cmd", "shift" }, "d", launchOrFocus("com.mitchellh.ghostty"))
hk.bind({ "ctrl", "alt", "cmd", "shift" }, "a", launchOrFocus("com.mitchellh.ghostty"))
hk.bind({ "ctrl", "alt", "cmd", "shift" }, "t", FocusDesktop())

-- window manager
hk.bind({ "ctrl", "alt", "cmd", "shift" }, "e", windowManager("fullScreen"))
hk.bind({ "ctrl", "alt", "cmd", "shift" }, "s", windowManager("max"))
hk.bind({ "ctrl", "alt", "cmd", "shift" }, "z", windowManager("center"))
hk.bind({ "ctrl", "alt", "cmd", "shift" }, "l", windowManager("right"))
hk.bind({ "ctrl", "alt", "cmd", "shift" }, "h", windowManager("left"))
hk.bind({ "ctrl", "alt", "cmd", "shift" }, "j", windowManager("bottom"))
hk.bind({ "ctrl", "alt", "cmd", "shift" }, "k", windowManager("top"))
