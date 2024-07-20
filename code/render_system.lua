local tiny = require('tiny')

-- idk if I should do this for all systems.  For now let's just do it for the render system
-- Instead of having the module be the prefab system, the module will have a constructor for
-- the system which takes the camera as an argument.  This is how we can get the camera object in here.

local mymodule = {}

function mymodule:createRenderSystem(camera)
    local renderSystem = tiny.sortedProcessingSystem({runDuringDrawPhase = true, camera = camera})
    renderSystem.filter = tiny.requireAll('position', tiny.requireAny('sprite', 'spriteCollection', 'renderableLine'))

    -- handle z levels (default position.z = 0)
    function renderSystem:compare(e1, e2)
        return e1.position.z < e2.position.z
    end

    -- the actual rendering code
    function renderSystem:process(entity, dt)
        local position = entity.position
        viewX = position.x - math.floor(self.camera.x)
        viewY = position.y - math.floor(self.camera.y)

        -- single sprite rendering
        if entity.sprite then
            local sprite = entity.sprite
            love.graphics.draw(sprite.image, sprite.quad, viewX, viewY)

        -- sprite collection rendering
        elseif entity.spriteCollection then
            local spriteCollection = entity.spriteCollection
            for i = 1, #spriteCollection.quads do
                love.graphics.draw(spriteCollection.image, spriteCollection.quads[i],
                                   viewX + spriteCollection.quadOffsets[i].x, 
                                   viewY + spriteCollection.quadOffsets[i].y)
            end

        -- debug line.
        elseif entity.renderableLine then
            local line = entity.renderableLine
            love.graphics.setColor(line.color)
            love.graphics.line(viewX + line.startX, viewY + line.startY, viewX + line.endX, viewY + line.endY)
            love.graphics.setColor(1, 1, 1) -- reset to white so it doesn't screw up the next render
        end
    end

    return renderSystem
end

return mymodule