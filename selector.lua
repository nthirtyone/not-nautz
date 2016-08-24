-- `Selector` (Element)
-- Used in Menu for selecting various things from list. Works for each Controller set or globally.
--[[
How to use `Selector` in `Menu` config file?
selector:new(menu)
	:setPosition(x, y)
	:setSpacing(42, 0)
	:set("list", require "nautslist")
	:set("sprite", love.graphics.newImage("assets/portraits.png"))
	:set("quads", require "portraits")
	:set("global", false) -- true: single selector; false: selector for each controller set present
	:init()
]]

Selector = {
	parent,
	x = 0,
	y = 0,
	horizontal = 0,
	height = 0,
	focused = false,
	global = false,
	list,
	sets,
	locks,
	selections,
	sprite,
	quads
}

-- Constructor
function Selector:new(parent)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.parent = parent
	return o
end

-- Position
function Selector:getPosition()
	return self.x, self.y
end
function Selector:setPosition(x,y)
	self.x, self.y = x, y
	return self
end

-- Spacing between positions of two blocks
function Selector:getSpacing()
	return self.horizontal, self.vertical
end
function Selector:setSpacing(horizontal, vertical)
	self.horizontal, self.vertical = horizontal, vertical
	return self
end

-- General setter for Menu configuration files
function Selector:set(name, func)
	if type(name) == "string" and func ~= nil then
		self[name] = func
	end
	return self
end

-- Initialize Selector with current settings.
function Selector:init()
	-- Make sure that there is list present
	if self.list == nil then
		self.list = {}
	end
	-- Initialize global Selector
	if self.global then
		self.locks = {false}
		self.selections = {1}
	-- Initialize Selector for Controllers
	else
		self.sets = Controller.getSets()
		self.locks = {}
		self.selections = {}
		for n=1,#self.sets do
			self.locks[n] = false
			self.selections[n] = 1
		end
	end
	return self
end

-- Cycle through list on given number
function Selector:next(n)
	local total = #self.list
	local current = self.selections[n]
	local locked = self:isLocked(n)
	if not locked then
		self.selections[n] = (current % total) + 1
	end
end
function Selector:previous(n)
	local total = #self.list
	local current = self.selections[n]
	local locked = self:isLocked(n)
	if not locked then
		if current == 1 then
			self.selections[n] = total
		else
			self.selections[n] = current - 1
		end
	end
end

-- Get number associated with a given set
function Selector:checkNumber(set)
	if self.global then return 1 end -- For global Selector
	for n,check in pairs(self.sets) do
		if check == set then return n end
	end
end

-- Check if given number is locked
function Selector:isLocked(n)
	return self.locks[n]
end

-- Get value of selection of given number
function Selector:getSelection(n)
	return self.selections[n]
end

-- Get value from list by selection
function Selector:getListValue(i)
	return self.list[i]
end

-- Draw single block of Selector
function Selector:drawBlock(n, x, y, scale)
	local x, y = x or 0, y or 0
	if self.quads == nil or self.sprite == nil then return end
	love.graphics.setFont(Font)
	love.graphics.setColor(255, 255, 255, 255)
	local name = self:getListValue(self:getSelection(n))
	local locked = self:isLocked(n)
	local sprite = self.sprite
	local quad = self.quads[name]
	local arrowl = self.quads.arrow_left
	local arrowr = self.quads.arrow_right
	if not locked then
		love.graphics.draw(sprite, quad.normal, x*scale, y*scale, 0, scale, scale)
		if self.focused then
			love.graphics.draw(sprite, arrowl, (x-2)* scale, (y+13)*scale, 0, scale, scale)
			love.graphics.draw(sprite, arrowr, (x+30)*scale, (y+13)*scale, 0, scale, scale)
		end
	else
		love.graphics.draw(sprite, quad.active, x*scale, y*scale, 0, scale, scale)
	end
end

-- Menu callbacks
function Selector:focus() -- Called when Element gains focus
	self.focused = true
	return true
end 
function Selector:blur() -- Called when Element loses focus
	self.focused = false
end 

-- LÖVE2D callbacks
function Selector:draw(scale)
	local x,y = self:getPosition()
	local h,v = self:getSpacing()
	for n=1,#self.selections do
		self:drawBlock(n, x+h*n, y+v*n, scale)
	end
end
function Selector:update(dt) end

-- Controller callbacks
function Selector:controlpressed(set, action, key)
	self:next(1)
end
function Selector:controlreleased(set, action, key) end

return Selector