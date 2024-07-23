-- target movement system handles entities that move at a set speed towards a target point in the world
-- Once they arrive at the target, they set their reachedTarget flag to true.
-- If a new target is set, this system will set the reachedTarget variable to false and start moving again

local tiny = require("tiny")
local constants = require("constants")

local mymodule = tiny.processingSystem()
mymodule.filter = tiny.requireAll("position", "targetMovement")

function mymodule:process(entity, dt)
	local targetMovement = entity.targetMovement
	local position = entity.position

	if targetMovement.targetX ~= nil and targetMovement.targetY ~= nil then
		-- figure out how far to the target
		local dx = targetMovement.targetX - position.x
		local dy = targetMovement.targetY - position.y
		local distance = math.sqrt(dx * dx + dy * dy)
		local moveDistance = targetMovement.moveSpeed * dt

		if moveDistance >= distance then
			-- you've reached the target, correct for overshoot and start waiting
			position.x = targetMovement.targetX
			position.y = targetMovement.targetY
			targetMovement.reachedTarget = true
		else
			local angle = math.atan2(dy, dx)
			position.x = position.x + moveDistance * math.cos(angle)
			position.y = position.y + moveDistance * math.sin(angle)
			targetMovement.reachedTarget = false
		end
	else
		targetMovement.reachedTarget = true
	end
end

return mymodule
