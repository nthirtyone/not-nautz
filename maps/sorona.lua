-- Sorona, but with the worms and such.
return {
	-- GENERAL
	name = "sorona",
	theme = "sorona.ogg",
	center_x = 0,
	center_y = 0,
	width  = 360,
	height = 240,
	-- RESPAWN POINTS
	respawns = {
		{x = -30, y = 70},
		{x =  -90, y = 125},
		{x =   -31, y = 122},
		{x =  70, y = 20},
		{x =  1, y = -15},
		{x =  105, y = -15}
	},
	-- GRAPHICS
	clouds = false,
	background = "assets/backgrounds/sorona.png",
	platforms = {
		{
			x = -60,
			y = 70,
			shape = {0,0, 60,0, 60,20, 0,20},
			sprite = "assets/platforms/sorona-center.png"
		},
		{
			x = -40,
			y = 125,
			shape = {3,0, 180,0, 180,20, 3,20},
			sprite = "assets/platforms/sorona-right-bottom.png"
		},
		{
			x = -120,
			y = 122,
			shape = {3,0, 62,0, 62,24, 3,24},
			sprite = "assets/platforms/sorona-left-bottom.png"
		},
		{
			x = 0,
			y = 20,
			shape = {1,0, 141,0, 1,25, 141,25},
			sprite = "assets/platforms/sorona-right-top.png"
		},
		{
			x = -150,
			y = 15,
			shape = {1,8, 105,8, 85,16, 38,28, 1,30},
			sprite = "assets/platforms/sorona-left-top.png"
		}
	},
	decorations = {}
}
