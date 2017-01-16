-- The abyss of the alpha.
return {
	-- GENERAL
	name = "alpha abyss",
	theme = "alpha.ogg",
	center_x = 0,
	center_y = 0,
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
	background = "assets/backgrounds/alpha-1.png",
	platforms = {
		{
			x = -60,
			y = 0,
			shape = {0,0, 119,0, 91,49, 29,49},
			sprite = "assets/platforms/alpha-big-1.png"
		},
		{
			x = -150,
			y = -50,
			shape = {0,0, 59,0, 59,19, 0,19},
			sprite = "assets/platforms/alpha-small-1.png"
		},
		{
			x = 90,
			y = -50,
			shape = {0,0, 59,0, 59,19, 0,19},
			sprite = "assets/platforms/alpha-small-1.png"
		},
		{
			x = -30,
			y = -75,
			shape = {0,0, 59,0, 59,19, 0,19},
			sprite = "assets/platforms/alpha-small-1.png"
		}
	},
	decorations = {}
}
