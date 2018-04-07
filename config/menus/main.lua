local menu, background = ...

local Button = require "not.Button"
local Header = require "not.Header"
local Element = require "not.Element"

local width, height = love.graphics.getWidth()/getScale(), love.graphics.getHeight()/getScale()
local bx = width/2-29

local awesometwo = love.graphics.newImage("assets/two.png")

if background == nil or not background:is(require "not.MenuBackground") then
	background = require "not.MenuBackground"(menu)
end

-- Wait, only here?
if musicPlayer:getCurrentTrack() ~= "menu.ogg" then
	musicPlayer:setTrack("menu.ogg")
	musicPlayer:play()
end

return {
	background,
	Button(menu)
		:setText("Start")
		:setPosition(bx, 80)
		:set("active", function (self)
				self.parent:open("host")
			end)
	,
	Button(menu)
		:setText("Join")
		:setPosition(bx, 96)
		:set("isEnabled", function (self)
				return false
			end)
	,
	Button(menu)
		:setText("Settings")
		:setPosition(bx, 112)
		:set("active", function (self)
				self.parent:open("settings")
			end)
	,
	Button(menu)
		:setText("Credits")
		:setPosition(bx, 128)
		:set("active", function (self)
				self.parent:open("credits")
			end)
	,
	Button(menu)
		:setText("Exit")
		:setPosition(bx, 144)
		:set("active", love.event.quit)
	,
	Element(menu)
		:setPosition(width/2, 15)
		:set("draw", function (self, scale) 
				local x,y = self:getPosition()
				love.graphics.setColor(1, 1, 1, 1)
				love.graphics.setFont(Bold)
				love.graphics.draw(awesometwo, x*scale, y*scale, 0, scale, scale, 35)
			end)
	,
	Header(menu)
		:setText("Roflnauts")
		:setPosition(width/2,40)
	,
}
