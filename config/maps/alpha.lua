return
{
	name = "Alpha Abyss",
	theme = "alpha.ogg",
	portrait = "assets/maps/alpha.png",
	available = true,
	center = {x = 0, y = -80},
	width  = 360,
	height = 240,
	respawns = {
		{x = -30, y = 0},
		{x =  30, y = 0},
		{x =   0, y = 0},
		{x = -120, y = -50},
		{x = 120, y = -50},
		{x =  0, y = -75}
	},
	create = {
		{
			clouds = "assets/dust.png",
			animations = "clouds-default",
			count = 8,
		},
		{
			ratio = 0,
			background = "assets/backgrounds/alpha.png",
			animations = "background-alpha"
		},
		{
			x = -60,
			y = 0,
			platform = "alpha-big",
		},
		{
			x = -145,
			y = -50,
			platform = "alpha-small",
		},
		{
			x = 85,
			y = -50,
			platform = "alpha-small",
		},
		{
			x = -30,
			y = -80,
			platform = "alpha-small",
		}
	},
}
