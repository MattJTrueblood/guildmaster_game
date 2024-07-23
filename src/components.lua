local mymodule = {}

mymodule.position = function(x, y, z)
    return {x = x, y = y, z = z or 0}
end

mymodule.sprite = function(image, quad)
    return {image = image, quad = quad}
end

mymodule.spriteCollection = function(image, quads, quadOffsets, width, height)
    return {image = image, quads = quads, quadOffsets = quadOffsets, width=width, height=height}
end

mymodule.renderableLine = function(color, startX, startY, endX, endY)
    return {color = color, startX = startX, startY = startY, endX = endX, endY = endY}
end

mymodule.monsterAI = function(x1, y1, x2, y2)
    return {x1 = x1, y1 = y1, x2 = x2, y2 = y2, currentlyMoving = false, waitSeconds = 0.0}
end

mymodule.adventurerAI = function()
    return {lastVisited = {-99999, -99999}}
end

mymodule.targetMovement = function(moveSpeed)
    return {targetX = nil, targetY = nil, moveSpeed = moveSpeed, reachedTarget = false}
end

mymodule.boxCollision = function(x, y, width, height) -- x and y are offsets from position
    return {x = x, y = y, width = width, height = height}
end

mymodule.canCollide = function()
    return { collisions = {}}
end

mymodule.canPickupStuff = function()
    return {}
end

mymodule.canBePickedUp = function(inventoryItem)
    return { inventoryItem = inventoryItem}
end

mymodule.inventory = function()
    return { contents = {}}
end

mymodule.attachedTo = function(entity, xOffset, yOffset)
    return { attachedToEntity = entity, xOffset = xOffset, yOffset = yOffset}
end

mymodule.hasAttachments = function()
    return { attachedEntities = {} }
end

mymodule.health = function(current, max)
    return { current = current, max = max}
end

mymodule.hasHealthBar = function()
    return { healthBarEntity = nil }
end

mymodule.renderableBar = function(fgColor, bgColor, width, height, value)
    return { fgColor = fgColor, bgColor = bgColor, width = width, height = height, value = 1.0 }
end



return mymodule