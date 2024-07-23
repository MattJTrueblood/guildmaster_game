-- healthbar system attaches a health bar entity to any entity with the health and hasHealthBar components
-- it then keeps the health bar entity updated with the entity's current health 

local tiny = require("tiny")
local components = require("components")
local constants = require("constants")

local mymodule = tiny.processingSystem()
mymodule.filter = tiny.requireAll("health", "hasHealthBar", "position")

function mymodule:process(entity, dt)
	health = entity.health
    healthBar = entity.hasHealthBar
    if(healthBar.healthBarEntity == nil) then
        healthBar.healthBarEntity = self.createHealthBarEntity(entity)
        self.world:addEntity(healthBar.healthBarEntity)
    end
    
    healthBar.healthBarEntity.renderableBar.value = health.current / health.max
end

function mymodule.createHealthBarEntity(entity)
    return {
        position = components.position(entity.position.x, entity.position.y, 5),
        attachedTo = components.attachedTo(entity, 0, -constants.HEALTH_BAR_HEIGHT),
        renderableBar = components.renderableBar({0, 1, 0}, {1, 0, 0}, constants.TILE_SIZE, constants.HEALTH_BAR_HEIGHT, 1.0)
    }
end

function mymodule:onRemove(entity)
    local healthBar = entity.healthBar
    if healthBar and healthBar.healthBarEntity then
        self.world:removeEntity(healthBar.healthBarEntity)
    end
end

return mymodule