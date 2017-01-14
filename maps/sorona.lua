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
			x = -60,
			y = 70,
			shape = {0,0, 60,0, 60,28, 0,28},
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
			y = 20,
			shape = {1,8, 33,8, 33,33, 4,29},
			sprite = "assets/platforms/sorona-left-top.png"
		}
	},
	decorations = {}
}
