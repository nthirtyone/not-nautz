require "not.Hero"

--- `Player`
-- Special `not.Hero` controllable by a player.
-- TODO: move functions and properties related to controls from `not.Hero`.
Player = Hero:extends()

Player.controllerSet =--[[Controller.sets.*]]nil

-- Constructor of `Player`.
function Player:new (name, x, y, world)
	Player.__super.new(self, name, x, y, world)
end

-- Controller set manipulation.
function Player:assignControllerSet (set)
	self.controllerSet = set
end
function Player:getControllerSet ()
	return self.controllerSet
end

-- Check if control of assigned controller is pressed.
function Player:isControlDown (control)
	return Controller.isDown(self:getControllerSet(), control)
end

function Player:isJumping ()
	return self:isControlDown("jump")
end

function Player:isWalkingLeft ()
	return self:isControlDown("left")
end

function Player:isWalkingRight ()
	return self:isControlDown("right")
end

-- Controller callbacks.
function Player:controlpressed (set, action, key)
	if set ~= self:getControllerSet() then return end
	self.smoke = false -- TODO: temporary

	-- Punching
	if action == "attack" and self.punchCooldown <= 0 then
		local f = self.facing
		if self:isControlDown("up") then
			self:punch("up")
		elseif self:isControlDown("down") then
			self:punch("down")
		else
			if f == 1 then
				self:punch("right")
			else
				self:punch("left")
			end
		end
	end
end

function Player:controlreleased (set, action, key)
	if set ~= self:getControllerSet() then return end
	-- Jumping
	if action == "jump" then
		self.jumpTimer = Hero.JUMP_TIMER
	end
end

return Player
