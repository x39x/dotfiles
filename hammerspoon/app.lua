local M = {}

local alert = require("hs.alert")
local application = require("hs.application")
local timer = require("hs.timer")
local window = require("hs.window")

local WINDOW_LAYOUT = {
	["com.apple.Preview"] = false,
	["org.alacritty"] = false,
}

local function getApp(bundleID)
	local apps = application.applicationsForBundleID(bundleID)
	return apps and apps[1]
end

local function layoutWindow(win, bundleID)
	if WINDOW_LAYOUT[bundleID] == false then
		return
	end
	if WINDOW_LAYOUT[bundleID] ~= nil then
		win:moveToUnit(WINDOW_LAYOUT[bundleID])
		return
	end
	win:moveToUnit({ 0.004, 0.004, 0.992, 0.992 })
end

local function launchApp(bundleID)
	local launched = application.launchOrFocusByBundleID(bundleID)

	if launched == false then
		alert.show("Failed to launch app: " .. bundleID)
		return
	end

	local app, win

	timer.waitUntil(function()
		app = getApp(bundleID)
		if not app then
			return false
		end

		win = app:mainWindow() or app:focusedWindow()
		if not win then
			return false
		end
		return true
	end, function()
		timer.doAfter(0.5, function()
			app:activate(true)
			layoutWindow(win, bundleID)
			win:focus()
		end)
	end)
end

local function activateApp(app)
	app:activate(true)
	app:unhide()
end

local function toggleFocus(app)
	local win = app:mainWindow()

	if not win then
		-- when hide with cmd+m, you must "launch" app
		application.launchOrFocusByBundleID(app:bundleID())
		return
	end

	if win:isFullScreen() then
		activateApp(app)
		win:focus()
		return
	end

	if app:isFrontmost() then
		app:hide()
		return
	end

	activateApp(app)
	win:focus()
end

local function focusDesktop()
	local desktop = window.desktop()
	if desktop then
		desktop:application():activate(true)
		desktop:focus()
	end
end

function M.launchOrFocus(bundleID)
	return function()
		if bundleID == "Desktop" then
			focusDesktop()
			return
		end

		local app = getApp(bundleID)

		if not app then
			launchApp(bundleID)
			return
		end

		toggleFocus(app)
	end
end

return M
