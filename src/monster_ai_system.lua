local tiny = require("tiny")
local constants = require("constants")

mymodule = tiny.processingSystem()
mymodule.filter = tiny.requireAll("position", "monsterAI")

function mymodule:process(entity, dt)
	position = entity.position
	monsterAI = entity.monsterAI

	if(monsterAI.currentlyMoving == false) then
		if(monsterAI.waitSeconds > 0) then
			monsterAI.waitSeconds = monsterAI.waitSeconds - dt
		else
			-- choose new target location somewhere randomly on the line between the monsterAI's x1,y1 and x2, y2
			local t = math.random()
			monsterAI.targetX = monsterAI.x1 + t * (monsterAI.x2 - monsterAI.x1)
			monsterAI.targetY = monsterAI.y1 + t * (monsterAI.y2 - monsterAI.y1)

			--snap to grid
			monsterAI.targetX = math.floor((monsterAI.targetX / constants.TILE_SIZE) + 0.5) * constants.TILE_SIZE
			monsterAI.targetY = math.floor((monsterAI.targetY / constants.TILE_SIZE) + 0.5) * constants.TILE_SIZE

			monsterAI.currentlyMoving = true
		end
		
	else
		-- figure out how far the monster needs to move
		local dx = monsterAI.targetX - position.x
		local dy = monsterAI.targetY - position.y
		local distance = math.sqrt(dx * dx + dy * dy)
		local moveDistance = monsterAI.moveSpeed * dt

		if moveDistance >= distance then
			--you've reached the target, correct for overshoot and start waiting
			position.x = monsterAI.targetX
			position.y = monsterAI.targetY
			monsterAI.currentlyMoving = false
			monsterAI.waitSeconds = constants.MONSTER_WAIT_SECONDS
		else
			--move towards the target
			local angle = math.atan2(dy, dx)
			position.x = position.x + moveDistance * math.cos(angle)
			position.y = position.y + moveDistance * math.sin(angle)
		end
	end
end

return mymodule