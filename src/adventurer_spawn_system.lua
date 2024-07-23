-- adventurer spawn system spawns new adventurer entities at the starting point.  Because it requires a spawnpoint x and y,
-- we use a custom constructor instead of the module itself being the system (similar to what the render system does).
-- The render spawn system creates adventurers every constants.ADVENTURER_SPAWN_DELAY seconds.
-- The adventurers have a randomized appearance and all the components necessary to act on their own

local tiny = require("tiny")
local constants = require("constants")
local components = require("components")
local imageloader = require("image_loader")
local uniqueId = require("unique_id")

local mymodule = {}

local adventurerTileMapIndices = {100, 88, 85, 113, 101, 97}

local function spawnAdventurerAt(world, x, y)
	return {
		position = components.position(x, y, 4),
		sprite = components.sprite(imageloader.miscTilesetImage, imageloader.miscTileMap[adventurerTileMapIndices[math.random(1,#adventurerTileMapIndices)]]),
		adventurerAI = components.adventurerAI(),
		targetMovement = components.targetMovement(constants.ADVENTURER_MOVE_SPEED),
		boxCollision = components.boxCollision(1, 1, constants.TILE_SIZE-2, constants.TILE_SIZE-2),
		canCollide = components.canCollide(),
		canPickupStuff = components.canPickupStuff(),
		inventory = components.inventory(),
		health = components.health(20, 20),
		hasHealthBar = components.hasHealthBar(),
		faction = components.faction('good guys', {'bad guys'}),
		battler = components.battler(20, 10),
		mortal = components.mortal(),
		id = components.id(uniqueId:generateUniqueId())
	}
end

function mymodule:createAdventurerSpawnSystem(spawnpointX, spawnpointY)
	adventurerSpawnSystem = tiny.system({spawnpointX = spawnpointX, spawnpointY = spawnpointY, currentSpawnDelay = 0})

	function adventurerSpawnSystem:update(dt)
		if(self.currentSpawnDelay > 0) then
			self.currentSpawnDelay = self.currentSpawnDelay - dt
		else
			-- spawn a new adventurer
			self.world:addEntity(spawnAdventurerAt(self.world, self.spawnpointX, self.spawnpointY))
			self.currentSpawnDelay = constants.ADVENTURER_SPAWN_DELAY
		end
	end

	return adventurerSpawnSystem
end

return mymodule