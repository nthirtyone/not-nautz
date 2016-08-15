-- `Menu`
-- It is one of the last things I will need to mess around with. I'm happy and surprised everything works so far.
-- For sure I have learnt a lot about lua during this journey. Still a lot ahead. I will continue writing in the same style though, to not make it even worse.

-- WHOLE CODE HAS FLAG OF "need a cleanup"

require "selector"

-- Metatable of `Menu`
Menu = {
	-- move selectors to one table; make functions to retrieve selectors w or w/o controller
	selectors = nil,
	nauts = require "nautslist",
	portrait_sprite = nil,
	portrait_sheet  = require "portraits",
	scale = getScale(),
	countdown = 10,
	maplist = require "maplist",
	map = 1,
	header_move = 0
}

-- Constructor of `Menu`
function Menu:new()
	-- Meta
	local o = {}
	setmetatable(o, self)
	self.__index = self
	-- initialize
	o.selectors = {}
	o.portrait_sprite = love.graphics.newImage("assets/portraits.png")
	-- selectors
	for i=0,3 do
		o:newSelector()
	end
	-- music
	o.music = Music:new("ROFLmenu.ogg")
	return o
end

-- Destructor
function Menu:delete()
	self.music:delete()
end

-- Naut selector
function Menu:newSelector()
	local selector = Selector:new(self)
	local w, h = love.graphics.getWidth()/self.scale, love.graphics.getHeight()/self.scale
	local n = #self.selectors - 1
	table.insert(self.selectors, selector)
	local x = (w-76)/2+n*44
	local y = h/2-8
	selector:setPosition(x, y)
end

-- Selectors tables getters
-- all of them
function Menu:getSelectors()
	return self.selectors
end
-- with control set
function Menu:getSelectorsActive()
	local t = {}
	for _,selector in pairs(self.selectors) do
		if selector:getState() ~= 0 then
			table.insert(t, selector)
		end
	end
	return t
end
-- without control set
function Menu:getSelectorsInactive()
	local t = {}
	for _,selector in pairs(self.selectors) do
		if selector:getState() == 0 then
			table.insert(t, selector)
		end
	end
	return t
end
-- with locked character
function Menu:getSelectorsLocked()
	local t = {}
	for _,selector in pairs(self.selectors) do
		if selector:getState() == 2 then
			table.insert(t, selector)
		end
	end
	return t
end

-- Tests if Control set is assigned to any selector (1.) and if it is locked (2.)
function Menu:isSetUsed(set)
	for k,selector in pairs(self:getSelectorsActive()) do
		if selector:getControlSet() == set then
			if selector:getState() == 2 then
				return true, true
			else
				return true, false
			end
		end
	end
	return false, false
end

-- Header get bounce move
function Menu:getBounce(f)
	local f = f or 1
	return math.sin(self.header_move*f*math.pi)
end

-- Speed up countdown
function Menu:countdownJump()
	if self.countdown ~= Menu.countdown then -- Menu.countdown is initial
		self.countdown = self.countdown - 1
	end
end

-- Get table of nauts currently selected by locked selectors
function Menu:getNauts()
	local nauts = {}
	for _,selector in pairs(self:getSelectorsLocked()) do
		table.insert(nauts, {selector:getSelectionName(), selector:getControlSet()})
	end
	return nauts
end

-- WARUDO
function Menu:startGame()
	local world = World:new(self.maplist[self.map], self:getNauts())
	changeScene(world)
end

-- LÖVE2D callbacks
-- Update
function Menu:update(dt)
	if #self:getSelectorsLocked() > 1 then
		self.countdown = self.countdown - dt
	else
		self.countdown = Menu.countdown -- Menu.countdown is initial
	end
	if self.countdown < 0 then
		self:startGame()
	end
	-- Bounce header
	self.header_move = self.header_move + dt
	if self.header_move > 2 then
		self.header_move = self.header_move - 2
	end
end
-- Draw
function Menu:draw()
	-- locals
	local w, h = love.graphics.getWidth()/self.scale, love.graphics.getHeight()/self.scale
	local scale = self.scale
	-- map selection
	love.graphics.setFont(Font)
	love.graphics.printf("Map: " .. self.maplist[self.map], (w/2)*scale, (h/2-22)*scale, 150, "center", 0, scale, scale, 75, 4)
	-- character selection
	for _,selector in pairs(self:getSelectors()) do
		selector:draw()
	end
	-- header
	love.graphics.setFont(Bold)
	local angle = self:getBounce(2)
	local dy = self:getBounce()*4
	love.graphics.printf("ROFLNAUTS2",(w/2)*scale,(32+dy)*scale,336,"center",(angle*5)*math.pi/180,scale,scale,168,12)
	-- footer
	love.graphics.setFont(Font)
	love.graphics.printf("Use W,S,A,D,G,H or Arrows,Enter,Rshift or Gamepad\n\nA game by the Awesomenauts community\nSeltzy, PlasmaWisp, ParaDoX, MilkingChicken, Burningdillo, Bronkey, Aki, 04font\nBased on a game by Jan Willem Nijman, Paul Veer and Bits_Beats XOXO", (w/2)*scale, (h-42)*scale, 336, "center", 0, scale, scale, 168, 4)
	-- countdown
	local countdown = math.floor(self.countdown)
	if self.countdown < Menu.countdown then -- Menu.countdown is initial
		love.graphics.setFont(Bold)
		love.graphics.print(countdown,(w/2-6.5)*self.scale,(h/2+30)*self.scale,0,self.scale,self.scale)
	end
end

-- Controller callbacks
function Menu:controlpressed(set, action, key)
	local used, locked = self:isSetUsed(set)
	-- Pass to active selectors
	for k,selector in pairs(self:getSelectorsActive()) do
		selector:controlpressed(set, action, key)
	end
	if not used then
		if action == "attack" then
			self:getSelectorsInactive()[1]:assignControlSet(set)
		end
		-- map selection chaos!
		if action == "left" then
			if self.map ~= 1 then
				self.map = self.map - 1
			else
				self.map = #self.maplist
			end
		end
		if action == "right" then
			if self.map ~= #self.maplist then
				self.map = self.map + 1
			else
				self.map = 1
			end
		end
	end
	-- speed up the countdown
	if action ~= "jump" then
		if set == nil or locked then
			self:countdownJump() -- that's funny isn't it? if not jump then jump
		end
	end
end
function Menu:controlreleased(set, action, key)
end