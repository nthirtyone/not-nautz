--- Used to manage physical world and everything inside it: clouds, platforms, nauts, background etc.
-- TODO: Possibly move common parts of `World` and `Menu` to abstract class `Scene`.
World = require "not.Scene":extends()

require "not.Platform"
require "not.Player"
require "not.Effect"
require "not.Decoration"
require "not.Ray"
require "not.Cloud"
require "not.CloudGenerator"
require "not.Layer"
require "not.Timer"
require "not.Trap"
require "not.Entity"

--- ZA WARUDO!
-- TODO: Missing documentation on most of World's methods.
function World:new (map, nauts)
	love.physics.setMeter(64)
	self.world = love.physics.newWorld(0, 9.81*64, true)
	self.world:setCallbacks(self:getContactCallbacks())

	self.lastNaut = false
	self.entities = {}
	self.map = map

	self.camera = Camera(self.map.center.x, self.map.center.y, self)

	self:initLayers()
	self:buildMap()
	self:spawnNauts(nauts)

	musicPlayer:play(self.map.theme)
end

-- The end of the world
function World:delete ()
	for _,entity in pairs(self.entities) do
	 	entity:delete()
	end
	for layer in self.layers() do
		layer:delete()
	end
	self.world:destroy()
	collectgarbage()
end

--- Custom iterator for layers table.
-- Iterates over elements in reversed order. Doesn't pay attention to any changes in table.
local
function layersIterator (layers)
	local i = layers.n + 1
	return function ()
		i = i - 1
		return layers[i]
	end
end

--- Layers in World may exists as two references. Every reference is stored inside `instance.layers`.
-- First reference is indexed with number, it exists for every layer.
-- Second reference is indexed with string, it exists only for selected layers.
-- Mentioned special layers are initialized in this method.
-- Additionally layer count is stored inside `instance.layers.n`.
-- Layers are drawn in reverse order, meaning that `instance.layers[1]` will be on the top.
-- Calling `instance.layers` will return iterator.
function World:initLayers ()
	self.layers = setmetatable({}, {__call = layersIterator})
	self.layers.n = 0
	do
		local width, height = love.graphics.getWidth() / getScale(), love.graphics.getHeight() / getScale()
		local rays = self:addLayer(width, height)
		rays.transformScale = 1
		rays.transformRatio = 0
		rays.drawScale = getScale()
		self.layers.rays = rays
	end
	do
		local width, height = love.graphics.getDimensions()
		self.layers.tags = self:addLayer(width, height)
		self.layers.platforms = self:addLayer(width, height)
		self.layers.effects = self:addLayer(width, height)
		self.layers.heroes = self:addLayer(width, height)
		self.layers.decorations = self:addLayer(width, height)
		self.layers.clouds = self:addLayer(width, height)
	end
end

-- TODO: Make collisions for category 3 more customizable or create new category for traps/area effects.
local
function createFlame (self, x, y, direction, timerIn, timerOut)
	local trap = Trap(direction, x, y, self, "assets/decorations/205-flames.png")

	trap.layer = self.layers.platforms

	timerIn:register(trap.fadeIn, trap)
	timerOut:register(trap.fadeOut, trap)

	self:insertEntity(trap)
end

local
function getAnimations (a)
	if type(a) == "string" then
		return require("config.animations." .. a)
	end
	if type(a) == "table" then
		return a
	end
end

--- Builds map using one of tables frin config files located in `config/maps/` directory.
-- TODO: Clean World@buildMap. Possibly explode into more methods.
-- TODO: Move buildMap along with getAnimations to Factory.
function World:buildMap ()
	local width, height = love.graphics.getDimensions()

	for _,op in pairs(self.map.create) do
		if op.platform then
			-- TODO: Merge configs imported from other files to currently processed element.
			local config = love.filesystem.load(string.format("config/platforms/%s.lua", op.platform))()
			local platform = Platform(config.animations, config.shape, op.x, op.y, self, config.sprite)
			platform.layer = self.layers.platforms
			self:insertEntity(platform)
		end
		if op.decoration or op.background then
			local imagePath = op.decoration or op.background
			local entity = Decoration(0, 0, self, imagePath)

			local x, y = 0, 0
			if op.x and op.y then
				x = op.x
				y = op.y
			elseif op.animations then
				entity:setAnimations(getAnimations(op.animations))
				_,_,x,y = entity:getAnimation()[1]:getViewport()
				x, y = x / -2, y / -2
			else
				local image = love.graphics.newImage(imagePath)
				x = image:getWidth() / -2
				y = image:getHeight() / -2
			end
			entity:setPosition(x, y)

			local layer = self.layers.decorations
			if op.ratio then
				layer = self:addLayer(width, height)
				layer.transformRatio = op.ratio
				if op.background then
					layer.transformScale = getRealScale()
				end
			end
			entity.layer = layer

			self:insertEntity(entity)
		end
		if op.clouds then
			local animations = getAnimations(op.animations)
			local cg = CloudGenerator(op.clouds, animations, op.count, self)
			if op.ratio then
				cg.layer = self:addLayer(width, height)
				cg.layer.transformRatio = op.ratio
			end
			self:insertEntity(cg)
			cg:run(op.count, true)
		end
		-- TODO: Make flames and other traps more configurable through map config file.
		if op.flames then
			local timerIn = Timer(10)
			local timerOut = Timer(5)

			timerIn:register(timerOut.start, timerOut)
			timerOut:register(timerIn.start, timerIn)
			
			createFlame(self, -62, 16, "right", timerIn, timerOut)
			createFlame(self, 63, 16, "left", timerIn, timerOut)

			self:insertEntity(timerIn)
			self:insertEntity(timerOut)
			timerOut:start()
		end
	end
end

-- Spawn all the nauts for the round
function World:spawnNauts (nauts)
	for _,naut in pairs(nauts) do
		local x,y = self:getSpawnPosition()
		local spawn = self:createNaut(x, y, naut[1])
		spawn:assignControllerSet(naut[2])
	end
end

-- Get respawn location
function World:getSpawnPosition ()
	local n = love.math.random(1, #self.map.respawns)
	return self.map.respawns[n].x, self.map.respawns[n].y
end

function World:addLayer (width, height)
	local layer = Layer(width, height)
	local n = self.layers.n + 1
	self.layers[n] = layer
	self.layers.n = n
	return layer
end

-- TODO: Standardize `create*` methods with corresponding constructors. Pay attention to both params' order and names.
function World:createNaut (x, y, name)
	local h = Player(name, x, y, self)
	table.insert(self.entities, h)
	h.layer = self.layers.heroes
	return h
end

function World:createEffect (name, x, y)
	local e = Effect(name, x, y, self)
	table.insert(self.entities, e)
	e.layer = self.layers.effects
	return e
end

function World:createRay (naut)
	local r = Ray(naut, self)
	table.insert(self.entities, r)
	r.layer = self.layers.rays
	return r
end

function World:insertCloud (cloud)
	table.insert(self.entities, cloud)
	if not cloud.layer then
		cloud.layer = self.layers.clouds
	end
	return cloud
end

--- Verbose wrapper for inserting entities into entities table.
-- @param entity entity to insert
function World:insertEntity (entity)
	if entity then
		table.insert(self.entities, entity)
		return entity
	end
end

--- Searches entities for those which return true with filtering function.
-- @param filter function with entity as parameter
-- @return table containing results of search
function World:getEntities (filter)
	local result = {}
	for _,entity in pairs(self.entities) do
		if filter(entity) then
			table.insert(result, entity)
		end
	end
	return result
end

--- Counts entities returning true with filtering function.
-- @param filter function with entity as parameter
-- @return entity count
function World:countEntities (filter)
	local count = 0
	for _,entity in pairs(self.entities) do
		if filter(entity) then
			count = count + 1
		end
	end
	return count
end

function World:getCloudsCount ()
	return self:countEntities(function (entity)
		return entity:is(Cloud)
	end)
end

function World:getCloudsCountFrom (generator)
	return self:countEntities(function (entity)
		return entity:is(Cloud) and entity.generator == generator
	end)
end

function World:getNautsAll ()
	return self:getEntities(function (entity)
		return entity:is(require("not.Hero")) and not entity.body:isDestroyed()
	end)
end

function World:getNautsPlayable ()
	return self:getEntities(function (entity)
		return entity:is(require("not.Hero")) and entity.lives > -1
	end)
end

function World:getNautsAlive ()
	return self:getEntities(function (entity)
		return entity:is(require("not.Hero")) and entity.isAlive
	end)
end

-- get Map name
function World:getMapName ()
	return self.map.name
end

-- Event: when player is killed
function World:onNautKilled (naut)
	self.camera:startShake()
	self:createRay(naut)
	local nauts = self:getNautsPlayable()
	if self.lastNaut then
		sceneManager:removeTopScene()
		sceneManager:changeScene(Menu())
	elseif #nauts < 2 then
		self.lastNaut = true
		naut:playSound(5, true)
		sceneManager:addScene(Menu("win"))
	end
end

-- LÖVE2D callbacks
-- Update ZU WARUDO
function World:update (dt)
	self.world:update(dt)
	self.camera:update(dt)

	for key,entity in pairs(self.entities) do
		if entity:update(dt) then
			table.remove(self.entities, key):delete()
		end
	end

	-- TODO: Possibly rename Camera@sum because this code part in World doesn't make sense without reading further.
	self.camera:sum(self.map.center.x, self.map.center.y)
	for _,hero in pairs(self:getNautsAll()) do
		self.camera:sum(hero:getPosition())
	end

	-- Some additional debug info.
	local stats = love.graphics.getStats()
	dbg_msg = string.format("%sMap: %s\nClouds: %d\nLoaded: %d\nMB: %.2f", dbg_msg, self.map.filename, self:getCloudsCount(), stats.images, stats.texturememory / 1024 / 1024)
end

function World:draw ()
	for _,entity in pairs(self.entities) do
		if entity.draw and entity.layer then
			entity.layer:renderToWith(self.camera, entity.draw, entity, debug)
		end
		if entity.drawTag then
			self.layers.tags:renderToWith(self.camera, entity.drawTag, entity, debug)
		end
	end

	for layer in self.layers() do
		layer:draw()
		layer:clear()
	end

	-- TODO: Debug information could possibly get its own layer so it could follow flow of draw method.
	if debug then
		local center = self.map.center
		local ax, ay, bx, by = self.camera:getBoundaries(getScale(), love.graphics.getDimensions())

		love.graphics.setLineWidth(1 / getScale())
		love.graphics.setLineStyle("rough")

		self.camera:push()
		self.camera:transform(getScale(), 1, love.graphics.getDimensions())

		love.graphics.setColor(.5, .5, .5)
		love.graphics.line(ax,center.y,bx,center.y)
		love.graphics.line(center.x,ay,center.x,by)

		love.graphics.setColor(.78, .78, .78)
		love.graphics.line(ax,0,bx,0)
		love.graphics.line(0,ay,0,by)
		self.camera:pop()
	end
	
	-- TODO: Draw method beyond this point is a very, very dark place (portraits drawing to review).
	local scale = getScale()
	for _,naut in pairs(self:getNautsAll()) do
		-- I have no idea where to place them T_T
		-- let's do: bottom-left, bottom-right, top-left, top-right
		local w, h = love.graphics.getWidth()/scale, love.graphics.getHeight()/scale
		local y, e = 1, 1
		if _ < 3 then y, e = h-33, 0 end
		naut:drawHUD(1+(_%2)*(w-34), y, scale, e)
	end
end

--- Wraps World's beginContact and endContact to functions usable as callbacks for Box2D's world.
-- Only difference in new functions is absence of self as first argument.
-- @return wrapper for beginContact
-- @return wrapper for endContact
function World:getContactCallbacks ()
	local b = function (a, b, coll)
		self:beginContact(a, b, coll)
	end
	local e = function (a, b, coll)
		self:endContact(a, b, coll)
	end
	return b, e
end

-- TODO: Move these constants to a proper place (I have no idea where proper place is).
local COLL_HERO = 2
local COLL_PLATFORM = 1
local COLL_PUNCH = 3
local COLL_TRAP = 4

-- TODO: Review current state of both Box2D callbacks (again).
function World:beginContact (a, b, coll)
	if a:getCategory() == COLL_PLATFORM then
		local x,y = coll:getNormal()
		if y < -0.6 then
			b:getUserData():land()
		end
		local vx, vy = b:getUserData().body:getLinearVelocity()
		if math.abs(x) == 1 or (y < -0.6 and x == 0) then
			b:getUserData():playSound(3)
		end
	end
	if a:getCategory() == COLL_PUNCH then
		if b:getCategory() == COLL_HERO then
			b:getUserData():damage(a:getUserData()[2])
		end
		if b:getCategory() == COLL_PUNCH then
			a:getBody():getUserData():damage(b:getUserData()[2])
			b:getBody():getUserData():damage(a:getUserData()[2])
			local x1,y1 = b:getBody():getUserData():getPosition()
			local x2,y2 = a:getBody():getUserData():getPosition()
			local x = (x2 - x1) / 2 + x1 - 12
			local y = (y2 - y1) / 2 + y1 - 15
			self:createEffect("clash", x, y)
		end
	end
	if b:getCategory() == COLL_PUNCH then
		if a:getCategory() == COLL_HERO then
			a:getUserData():damage(b:getUserData()[2])
		end
	end
	if a:getCategory() == COLL_TRAP then
		if b:getCategory() == COLL_HERO then
			b:getUserData():damage(a:getUserData()[1])
		end
	end
	if b:getCategory() == COLL_TRAP then
		if a:getCategory() == COLL_HERO then
			a:getUserData():damage(b:getUserData()[1])
		end
	end
end

function World:endContact (a, b, coll)
	if a:getCategory() == COLL_PLATFORM then
		b:getUserData().inAir = true
	end
end

-- Controller callbacks
function World:controlpressed (set, action, key)
	if key == "f6" and debug then
		local filename = self.map.filename
		local map = love.filesystem.load(filename)()
		map.filename = filename
		local nauts = {}
		for _,naut in pairs(self:getNautsAll()) do
			table.insert(nauts, {naut.config, naut:getControllerSet()})
		end
		local new = World(map, nauts)
		sceneManager:changeScene(new)
	end
	if key == "escape" then
		sceneManager:addScene(Menu("pause"))
		self:setInputDisabled(true)
		self:setSleeping(true)
	end
	for k,naut in pairs(self:getNautsAll()) do
		naut:controlpressed(set, action, key)
	end
end
function World:controlreleased (set, action, key)
	for k,naut in pairs(self:getNautsAll()) do
		naut:controlreleased(set, action, key)
	end
end
