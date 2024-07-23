-- this system controls the behavior of monsters in the dungeon
-- currently, they wander between two locations.  After waiting for waitSeconds seconds, the monster
-- will choose a location between those two points and start walking towards that point.
-- once it reaches it, it will start waiting again.

local tiny = require("tiny")
local constants = require("constants")

local mymodule = tiny.processingSystem()
mymodule.filter = tiny.requireAll("position", "monsterAI", "targetMovement")

function mymodule:process(entity, dt)
	local position = entity.position
	local monsterAI = entity.monsterAI
	local targetMovement = entity.targetMovement

	if(targetMovement.reachedTarget) then
		if(monsterAI.waitSeconds > 0) then
			monsterAI.waitSeconds = monsterAI.waitSeconds - dt
		else
			-- choose new target location somewhere randomly on the line between the monsterAI's x1,y1 and x2, y2
			local t = math.random()
			targetMovement.targetX = monsterAI.x1 + t * (monsterAI.x2 - monsterAI.x1)
			targetMovement.targetY = monsterAI.y1 + t * (monsterAI.y2 - monsterAI.y1)

			--snap target location to grid
			targetMovement.targetX = math.floor((targetMovement.targetX / constants.TILE_SIZE) + 0.5) * constants.TILE_SIZE
			targetMovement.targetY = math.floor((targetMovement.targetY / constants.TILE_SIZE) + 0.5) * constants.TILE_SIZE

			--set wait seconds for when it reaches the target
			monsterAI.waitSeconds = constants.MONSTER_WAIT_SECONDS
		end
	end
end

return mymodule