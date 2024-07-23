local tiny = require("tiny")

local mymodule = tiny.processingSystem()
mymodule.filter = tiny.requireAll("position", "boxCollision", "canCollide")

function mymodule:preProcess(dt)
    for _, entity in ipairs(self.entities) do
        entity.canCollide.collisions = {}  -- clear all collisions for each entity.  We need to re-check them all anyways.
    end
end

function mymodule:process(entity, dt)
	for _, other in ipairs(self.entities) do
        if entity ~= other and self.checkCollision(entity, other) then
            table.insert(entity.canCollide.collisions, other)
        end
    end
end

function mymodule.checkCollision(a, b)
    local ax = a.position.x + a.boxCollision.x
    local ay = a.position.y + a.boxCollision.y
    local bx = b.position.x + b.boxCollision.x
    local by = b.position.y + b.boxCollision.y

    return not (ax + a.boxCollision.width < bx or
                bx + b.boxCollision.width < ax or
                ay + a.boxCollision.height < by or
                by + b.boxCollision.height < ay)
end

return mymodule