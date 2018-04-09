--- `Settings`
-- Stores, loads, saves and changes game settings including Controller sets.
Settings = {
	current = {}
}

-- Converts from old settings format to the one after `02aba07e03465205b45c41df7aec6894d4e89909`.
local function convertToNew (old)
	return {sets = old, display = "fullscreen"}
end

local function filePrepare ()
	if not love.filesystem.getInfo("settings") then
		local def = love.filesystem.newFile("settings.default")
		local new = love.filesystem.newFile("settings")
		new:open("w") def:open("r")
		new:write(def:read())
		new:close() def:close()
	end
end

local function fileLoad ()
	local getSettings = love.filesystem.load("settings")
	local settings = getSettings()
	if not settings.sets then
		settings = convertToNew(settings)
	end
	Settings.current = settings
end

local function controllerLoad ()
	if Controller then
		Controller.reset()
		local joysticksList = love.joystick.getJoysticks()
		for _,set in pairs(Settings.current.sets) do
			local isJoystick = set[7]
			local joystick
			if isJoystick then
				joystick = table.remove(joysticksList, 1)
			end
			if not isJoystick or joystick then
				Controller.registerSet(set[1], set[2], set[3], set[4], set[5], set[6], joystick)
			end
		end
	end
end

local function displayLoad ()
	local width, height, flags = love.window.getMode()
	if Settings.current.display == "fullscreen" then
		if not flags.fullscreen then
			love.window.setFullscreen(true, "desktop")
		end
	else
		local scale = tonumber(Settings.current.display) or 1
		local expectedWidth, expectedHeight = 320 * scale, 180 * scale
		if flags.fullscreen then
			love.window.setFullscreen(false)
		end
		if width ~= expectedWidth or height ~= expectedHeight then
			love.window.setMode(expectedWidth, expectedHeight)
		end
	end
end

function Settings.load ()
	filePrepare()
	fileLoad()
	controllerLoad()
	displayLoad()
end

function Settings.save () 
	local new = love.filesystem.newFile("settings")
	local sets = Settings.current.sets
	local string = "return {\n\tsets = {\n"
	for i,set in pairs(sets) do
		string = string .. "\t\t{"
		for j,word in pairs(set) do
			if j ~= 7 then
				string = string .. "\"" .. word .. "\", "
			else
				if word then
					string = string .. "true"
				else
					string = string .. "false"
				end
			end
		end
		string = string .. "},\n"
	end
	string = string .. "\t},\n"
	string = string .. "\tdisplay = \"" .. Settings.current.display .. "\",\n"
	string = string .. "}\n"
	new:open("w")
	new:write(string)
	new:close()
end

function Settings.change (n, left, right, up, down, attack, jump, joystick)
	local bool
	if joystick then
		bool = true
	else
		bool = false
	end
	Settings.current.sets[n] = {left, right, up, down, attack, jump, bool}
	Settings.reload()
end

function Settings.reload ()
	Settings.save()
	Settings.load()
end
