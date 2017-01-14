-- Sorona with the big wormy thingy.
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
			x = -91,
			y = 0,
			shape = {0,1, 181,1, 181,10, 96,76, 86,76, 0,10},
			sprite = "assets/platforms/sorona-bottom-right.png"
		},
		{
			x = 114,
			y = 50,
			shape = {0,1, 52,1, 52,30, 0,30},
			sprite = "assets/platforms/sorona-bottom-left.png"
		},
		{
			x = -166,
			y = 50,
			shape = {0,1, 52,1, 52,30, 0,30},
			sprite = "assets/platforms/sorona-center.png"
		},
    {
			x = -50,
			y = 75,
			shape = {0,1, 52,1, 52,30, 0,30},
			sprite = "assets/platforms/sorona-top-right.png"
		},
		{
			x = -17,
			y = -50,
			shape = {0,1, 34,1, 34,16, 0,16},
			sprite = "assets/platforms/sorona-top-left.png"
		}
	},
	decorations = {}
}
