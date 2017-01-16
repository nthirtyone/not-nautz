-- The abyss of the alpha.
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
	background = "assets/backgrounds/alpha-1.png",
	platforms = {
		{
			x = -60,
			y = 0,
			shape = {0,0, 117,0, 101,50, 16,50},
			sprite = "assets/platforms/alpha-big-1.png"
		},
		{
			x = -145,
			y = -50,
			shape = {0,0, 59,0, 59,19, 0,19},
			sprite = "assets/platforms/alpha-small-1.png"
		},
		{
			x = 85,
			y = -50,
			shape = {0,0, 59,0, 59,19, 0,19},
			sprite = "assets/platforms/alpha-small-1.png"
		},
		{
			x = -30,
			y = -80,
			shape = {0,0, 59,0, 59,19, 0,19},
			sprite = "assets/platforms/alpha-small-1.png"
		}
	},
	decorations = {}
}
