-- The abyss of the alpha.
-- Animations
local animations_small = {
	default = {
		frames = 20,
		repeated = true
	}
}
local animations_big = {
	default = {
		frames = 20,
		repeated = true
	}
}
for i=1,10 do
	local a = love.graphics.newQuad(i*118-118, 0, 118,51, 1180,51)
	animations_big.default[i*2-1] = a
	animations_big.default[i*2] = a
	local a = love.graphics.newQuad(i*60-60, 0, 60,20, 600,20)
	animations_small.default[i*2-1] = a
	animations_small.default[i*2] = a
end
-- Map data
return {
	-- GENERAL
	name = "alpha abyss",
	theme = "alpha.ogg",
	center_x = 0,
	center_y = -80,
	width  = 360,
	height = 240,
	-- RESPAWN POINTS
	respawns = {
		{x = -30, y = 0},
		{x =  30, y = 0},
		{x =   0, y = 0},
		{x = -120, y = -50},
		{x = 120, y = -50},
		{x =  0, y = -75}
	},
	-- GRAPHICS
	clouds = false,
	background = "assets/backgrounds/alpha.png",
	platforms = {
		{
			x = -60,
			y = 0,
			shape = {0,0, 117,0, 101,50, 16,50},
			sprite = "assets/platforms/alpha-big.png",
			animations = animations_big
		},
		{
			x = -145,
			y = -50,
			shape = {0,0, 59,0, 59,19, 0,19},
			sprite = "assets/platforms/alpha-small.png",
			animations = animations_small
		},
		{
			x = 85,
			y = -50,
			shape = {0,0, 59,0, 59,19, 0,19},
			sprite = "assets/platforms/alpha-small.png",
			animations = animations_small
		},
		{
			x = -30,
			y = -80,
			shape = {0,0, 59,0, 59,19, 0,19},
			sprite = "assets/platforms/alpha-small.png",
			animations = animations_small
		}
	},
	decorations = {}
}
