local M = {}
local alert = require("hs.alert")
local application = require("hs.application")
local timer = require("hs.timer")

local function appSleep(appBundleID)
	local appToSleep = {
		["com.microsoft.VSCode"] = "0.3",
		["com.apple.Notes"] = "0.3",
	}
	if appToSleep[appBundleID] ~= nil then
		os.execute("sleep " .. appToSleep[appBundleID])
	end
	os.execute("sleep 0.5")
end

local function launchApp(appBundleID)
	local runApp = application.launchOrFocusByBundleID(appBundleID)
	local notFullScreenApp = {
		["com.apple.Preview"] = true,
		["org.alacritty"] = true,
	}

	if runApp == false then
		alert("Failed to launch app: " .. appBundleID)
	elseif notFullScreenApp[appBundleID] then
		return
	else
		-- for fullScreen when first launch
		local checkTimerTimeoutCounter = 0
		CheckTimer = timer.new(0.1, function()
			if checkTimerTimeoutCounter == 500 then
				CheckTimer:stop()
				checkTimerTimeoutCounter = 0
				return
			end

			local appsFirstLaunch = application.applicationsForBundleID(appBundleID)
			local appFirstLaunch = appsFirstLaunch and appsFirstLaunch[1]
			if appFirstLaunch then
				appSleep(appBundleID)
				if appFirstLaunch:activate() then
					local focusedWindow = appFirstLaunch:focusedWindow()
					if focusedWindow then
						focusedWindow:setFullScreen(true)
						CheckTimer:stop()
						checkTimerTimeoutCounter = 0
						return
					end
				end
			end
			checkTimerTimeoutCounter = checkTimerTimeoutCounter + 1
		end)
		CheckTimer:start()
		return
	end
end

local function focusApp(app, appBundleID)
	local MainWin = app:mainWindow()
	if MainWin then
		if MainWin:isFullScreen() == true then
			MainWin:application():activate(true)
			MainWin:focus()
		elseif app:isFrontmost() == true then
			MainWin:application():hide()
		else
			MainWin:application():activate(true)
			MainWin:application():unhide()
			MainWin:focus()
		end
	else
		application.launchOrFocusByBundleID(appBundleID)
	end
end

M.launchOrFocus = function(appBundleID)
	return function()
		local appsIsRunning = application.applicationsForBundleID(appBundleID)
		local appIsRunning = appsIsRunning and appsIsRunning[1]

		-- If app is not open, then open it and go fullscreen
		if not appIsRunning then
			launchApp(appBundleID)
		end

		-- focus app
		focusApp(appIsRunning, appBundleID)
	end
end

M.FocusDesktop = function()
	return function()
		local desktop = require("hs.window").desktop()
		desktop:application():activate(true)
		desktop:focus()
	end
end

return M
