-- Animations spritesheet array for `Player`
-- Basic spritesheet size is 376x26. Each frame is 24x24 and has 1px border around it.
-- From the left: default (walk0), walk1, walk2, walk3, attack0, attack1, attack3, attack_up0, attack_up1, attack_up2, attack_down0, attack_down1, attack_down2, damage0, damage1
local animations = {
	default = {
		[1] = love.graphics.newQuad(376, 1, 24,24, 476,26),
		[2] = love.graphics.newQuad(376, 1, 24,24, 476,26),
		[3] = love.graphics.newQuad(401, 1, 24,24, 476,26),
		[4] = love.graphics.newQuad(401, 1, 24,24, 476,26),
		[5] = love.graphics.newQuad(426, 1, 24,24, 476,26),
		[6] = love.graphics.newQuad(426, 1, 24,24, 476,26),
		[7] = love.graphics.newQuad(451, 1, 24,24, 476,26),
		[8] = love.graphics.newQuad(451, 1, 24,24, 476,26),
		frames = 8,
		repeated = true
	},
	walk = {
		[1] = love.graphics.newQuad(  1, 1, 24,24, 476,26),
		[2] = love.graphics.newQuad( 26, 1, 24,24, 476,26),
		[3] = love.graphics.newQuad( 51, 1, 24,24, 476,26),
		[4] = love.graphics.newQuad( 76, 1, 24,24, 476,26),
		frames = 4,
		repeated = true
	},
	attack = {
		[1] = love.graphics.newQuad(101, 1, 24,24, 476,26),
		[2] = love.graphics.newQuad(126, 1, 24,24, 476,26),
		[3] = love.graphics.newQuad(151, 1, 24,24, 476,26),
		frames = 3,
		repeated = false
	},
	attack_up = {
		[1] = love.graphics.newQuad(176, 1, 24,24, 476,26),
		[2] = love.graphics.newQuad(201, 1, 24,24, 476,26),
		[3] = love.graphics.newQuad(226, 1, 24,24, 476,26),
		frames = 3,
		repeated = false
	},
	attack_down = {
		[1] = love.graphics.newQuad(251, 1, 24,24, 476,26),
		[2] = love.graphics.newQuad(276, 1, 24,24, 476,26),
		[3] = love.graphics.newQuad(301, 1, 24,24, 476,26),
		frames = 3,
		repeated = false
	},
	damage = {
		[1] = love.graphics.newQuad(326, 1, 24,24, 476,26),
		[2] = love.graphics.newQuad(351, 1, 24,24, 476,26),
		[3] = love.graphics.newQuad(326, 1, 24,24, 476,26),
		[4] = love.graphics.newQuad(351, 1, 24,24, 476,26),
		frames = 4,
		repeated = false
	},
}
return animations