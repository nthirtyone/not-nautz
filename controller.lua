-- `Controller`
-- Module to manage player input. 
-- It uses `love.keypressed`, `love.keyreleased`, `love.gamepadreleased`, `love.gamepadpressed`, `love.joystickadded`, so be sure not to use them by yourself.
-- Rather than that use functions provided by this module: `Controller.controlpressed` and `Controller.controlreleased`.
-- For information on additional functions, look below.

-- Metatable
Controller = {
	sets = {}
}

-- Declared to avoid calling nil. Be sure to define yours after this line is performed.
function Controller.controlpressed(set, action, key) end
function Controller.controlreleased(set, action, key) end

-- Create new controls set.
function Controller.registerSet(left, right, up, down, attack, jump, joystick)
	local set = {}
	set.left = left or "left"
	set.right = right or "right"
	set.up = up or "up"
	set.down = down or "down"
	set.attack = attack or "return"
	set.jump = jump or "rshift"
	table.insert(Controller.sets, set)
	return set
end

-- Tests all sets if they have control assigned to given key and joystick.
function Controller.testSets(key, joystick)
	for i,set in pairs(Controller.sets) do
		local action = Controller.testControl(set, key, joystick)
		if action ~= nil then
			return set, action, key
		end
	end
	return nil, nil, key
end

-- Tests given set if it has controll assigned to given key and joystick.
function Controller.testControl(set, key, joystick)
	-- First test if it is joystick and if it is correct one
	if joystick == set.joystick then
		if control == set.left then
			return "left"
		elseif control == set.right then
			return "right"
		elseif control == set.up then
			return "up"
		elseif control == set.down then
			return "down"
		elseif control == set.attack then
			return "attack"
		elseif control == set.jump then
			return "jump"
		else
			return nil
		end
	else
		return nil
	end
end

-- Callbacks from LÖVE2D
-- Create new sets when new joystick is added
function Controller.joystickadded(joystick)
	Controller.registerSet("dpleft", "dpright", "dpup", "dpdown", "a", "b", joystick)
end

-- Gamepad input callbacks
function Controller.gamepadpressed(joystick, button)
	print(button, "pressed")
	local set, action, key = Controller.testSets(button, joystick)
	Controller.controlpressed(set, action, key)
end
function Controller.gamepadreleased(joystick, button)
	print(button, "released")
	local set, action, key = Controller.testSets(button, joystick)
	Controller.controlreleased(set, action, key)
end

-- Keyboard input callbacks
function Controller.keypressed(button)
	print(button, "pressed")
	local set, action, key = Controller.testSets(button)
	Controller.controlpressed(set, action, key)
end
function Controller.keyreleased(button)
	print(button, "released")
	local set, action, key = Controller.testSets(button)
	Controller.controlreleased(set, action, key)
end