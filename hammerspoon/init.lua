local hk = require("hs.hotkey")
local windowManager = require("window").windowManager
local launchOrFocus = require("app").launchOrFocus

-- launch or focue app
hk.bind({ "ctrl", "alt", "cmd", "shift" }, "f", launchOrFocus("org.mozilla.firefox"))
hk.bind({ "ctrl", "alt", "cmd", "shift" }, "d", launchOrFocus("com.mitchellh.ghostty"))
hk.bind({ "ctrl", "alt", "cmd", "shift" }, "a", launchOrFocus("com.openai.chat"))
hk.bind({ "ctrl", "alt", "cmd", "shift" }, "t", launchOrFocus("Desktop"))

-- window manager
hk.bind({ "ctrl", "alt", "cmd", "shift" }, "e", windowManager("fullScreen"))
hk.bind({ "ctrl", "alt", "cmd", "shift" }, "s", windowManager("max"))
hk.bind({ "ctrl", "alt", "cmd", "shift" }, "z", windowManager("center"))
hk.bind({ "ctrl", "alt", "cmd", "shift" }, "l", windowManager("right"))
hk.bind({ "ctrl", "alt", "cmd", "shift" }, "h", windowManager("left"))
hk.bind({ "ctrl", "alt", "cmd", "shift" }, "j", windowManager("bottom"))
hk.bind({ "ctrl", "alt", "cmd", "shift" }, "k", windowManager("top"))
