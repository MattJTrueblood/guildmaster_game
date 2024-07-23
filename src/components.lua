local mymodule = {}

-- position marks a location in the world.  entities are rendered with low-z-indices first, high z-indices last.
mymodule.position = function(x, y, z)
    return {x = x, y = y, z = z or 0}
end

-- sprite describes a sprite in a spritesheet that represents this entity in the world
mymodule.sprite = function(image, quad)
    return {image = image, quad = quad}
end

-- spriteCollection describes a bunch of different sprites in a grid that together represent an entity in the world
mymodule.spriteCollection = function(image, quads, quadOffsets, width, height)
    return {image = image, quads = quads, quadOffsets = quadOffsets, width=width, height=height}
end

-- renderableLine describes a line, probably for debug, which can be rendered in the world
mymodule.renderableLine = function(color, startX, startY, endX, endY)
    return {color = color, startX = startX, startY = startY, endX = endX, endY = endY}
end

-- monsterAI lets an entity walk around and behave like a monster
mymodule.monsterAI = function(x1, y1, x2, y2)
    return {x1 = x1, y1 = y1, x2 = x2, y2 = y2, currentlyMoving = false, waitSeconds = 0.0}
end

-- adventurerAI lets an entity walk around and behave like an adventurer
mymodule.adventurerAI = function()
    return {lastVisited = {-99999, -99999}}
end

-- targetMovement lets an entity walk towards a target at a set speed, and stop moving once it reaches that target
mymodule.targetMovement = function(moveSpeed)
    return {targetX = nil, targetY = nil, moveSpeed = moveSpeed, reachedTarget = false}
end

-- boxCollision defines the bounding box around an entity which it can use to detect collision with other entities.
mymodule.boxCollision = function(x, y, width, height) -- x and y are offsets from position
    return {x = x, y = y, width = width, height = height}
end

-- canCollide enables collision and stores the entities this entity is currently colliding with
mymodule.canCollide = function()
    return { collisions = {}}
end

-- canPickupStuff enables entities to pick up other (canBePickedUp) entities
mymodule.canPickupStuff = function()
    return {}
end

-- canBePickedUp enables this entity to be picked up and added to the inventory of another entity
mymodule.canBePickedUp = function(inventoryItem)
    return { inventoryItem = inventoryItem}
end

-- inventory lets this entity have an inventory of items it is holding, and tracks the contents of that inventory.
mymodule.inventory = function()
    return { contents = {}}
end

-- attachedTo lets this entity move alongside another entity.
mymodule.attachedTo = function(entity, xOffset, yOffset)
    return { attachedToEntity = entity, xOffset = xOffset, yOffset = yOffset}
end

-- hasAttachments tracks any entities that are attachedTo this one.
mymodule.hasAttachments = function()
    return { attachedEntities = {} }
end

-- health lets an entity have a health value, which is between zero and max.
mymodule.health = function(current, max)
    return { current = current, max = max}
end

-- hasHealthBar lets an entity spawn a health bar above itself that displays its current health
mymodule.hasHealthBar = function()
    return { healthBarEntity = nil }
end

-- renderableBar entities are rendered like two rectangles, e.g. like a simple health bar, with a value between 0.0 and 1.0
mymodule.renderableBar = function(fgColor, bgColor, width, height, value)
    return { fgColor = fgColor, bgColor = bgColor, width = width, height = height, value = 1.0 }
end

-- battler entities can attack other entities.  attack and defense show how much damage they can do/take
mymodule.battler = function(attack, defense)
    return { attack = attack, defense = defense}
end

-- faction entities have a faction name and can battle against faction entities whose faction names are its enemies
mymodule.faction = function(factionName, enemyFactions)
    return { factionName = factionName, enemyFactions = enemyFactions }
end

-- id entities have a unique identifier which no other entity has (use unique_id to generate this)
mymodule.id = function(id)
    return { id = id }
end

-- mortal entities are deleted when their health reaches zero
mymodule.mortal = function()
    return {}
end

return mymodule