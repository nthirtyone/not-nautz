-- Spritesheet for character portraits
local nauts = require "nautslist"
local w, h = 1008, 27
local icons = {}

local i = 0
for _,naut in pairs(nauts) do
	icons[naut] = love.graphics.newQuad(i*28, 0, 28, 27, w, h)
	i = i + 1
end
return icons
