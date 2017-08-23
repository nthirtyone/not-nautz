-- TODO: These should be part of non-existent AssetsManager or something similar.
local function testAvoidList (i, avoidList)
	for key,value in pairs(avoidList) do
		if i == value then
			table.remove(avoidList, key)
			return false
		end
	end
	return true
end

function createIconsList (sheetWidth, sheetHeight, iconWidth, keysList, avoidList)
	local avoidList = avoidList or {}
	local iconsList, newKeysList = {}, {}
	local iconsNumber = math.floor(sheetWidth / iconWidth)
	local iconHeight = sheetHeight
	for i=1,iconsNumber do
		if testAvoidList(i, avoidList) then 
			iconsList[keysList[i]] = love.graphics.newQuad((i-1)*iconWidth, 0, iconWidth, iconHeight, sheetWidth, sheetHeight)
			table.insert(newKeysList, keysList[i])
		end
	end
	return iconsList, newKeysList
end

function getNautsIconsList (avoidList)
	local avoidList = avoidList or {37,38,39,40,41,42}
	local keysList = require "config.nauts"
	local iconsList, newKeysList = createIconsList(1176, 27, 28, keysList, avoidList)
	return iconsList, newKeysList
end

function getMapsIconsList (avoidList)
	local keysList = require "config.maps"
	local iconsList, newKeysList = createIconsList(532, 37, 76, keysList, avoidList)
	return iconsList, newKeysList
end
