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
		{x = -15, y = -80},
		{x =  -5, y = -80},
		{x =   5, y = -80},
		{x =  15, y = -80}
	},
	-- GRAPHICS
	clouds = false,
	background = "assets/backgrounds/sorona.png",
	platforms = {
		{
			x = -30,
			y = 0,
			shape = {0,0, 60,0, 60,28, 0,28},
			sprite = "assets/platforms/sorona-center.png"
		},
		{
			x = 114,
			y = 50,
			shape = {3,0, 180,0 180,20, 3,20},
			sprite = "assets/platforms/sorona-right-bottom.png"
		},
		{
			x = -166,
			y = 50,
			shape = {3,0, 63,0, 63,24, 3,24},
			sprite = "assets/platforms/sorona-left-bottom.png"
		},
		{
			x = 75,
			y = -50,
			shape = {1,0, 141,0, 1,25, 141,25},
			sprite = "assets/platforms/sorona-right-top.png"
		},
		{
			x = -166,
			y = -50,
			shape = {1,8, 33,8, 33,33, 4,29},
			sprite = "assets/platforms/sorona-left-top.png"
		}
	},
	decorations = {}
}
