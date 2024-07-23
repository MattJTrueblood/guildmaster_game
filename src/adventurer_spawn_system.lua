local tiny = require("tiny")
local constants = require("constants")
local components = require("components")
local imageloader = require("image_loader")

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
		health = components.health(100, 100),
		hasHealthBar = components.hasHealthBar()
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