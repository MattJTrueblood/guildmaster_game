local tiny = require('tiny')

local mymodule = tiny.sortedProcessingSystem({runDuringDrawPhase = true})

mymodule.filter = tiny.requireAll('position', tiny.requireAny('sprite', 'spriteCollection', 'renderableLine'))

-- handle z levels (default position.z = 0)
function mymodule:compare(e1, e2)
    return e1.position.z < e2.position.z
end

function mymodule:process(entity, dt)
    local position = entity.position

    -- single sprite rendering
    if entity.sprite then
        local sprite = entity.sprite
        love.graphics.draw(sprite.image, sprite.quad, position.x, position.y)

    -- sprite collection rendering
    elseif entity.spriteCollection then
        local spriteCollection = entity.spriteCollection
        for i = 1, #spriteCollection.quads do
            love.graphics.draw(spriteCollection.image, spriteCollection.quads[i],
                               position.x + spriteCollection.quadOffsets[i].x, 
                               position.y + spriteCollection.quadOffsets[i].y)
        end

    -- debug line.  Ignore position for now, just use the line xs and ys
    elseif entity.renderableLine then
        local line = entity.renderableLine
        love.graphics.setColor(line.color)
        love.graphics.line(line.startX, line.startY, line.endX, line.endY)
        love.graphics.setColor(1, 1, 1) -- reset to white so it doesn't screw up the next render
    end
end

return mymodule