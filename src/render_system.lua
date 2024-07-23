local tiny = require('tiny')
local constants = require("constants")

local mymodule = {}

function mymodule:createRenderSystem(camera)
    local renderSystem = tiny.sortedProcessingSystem({runDuringDrawPhase = true, camera = camera})
    renderSystem.filter = tiny.requireAll('position', tiny.requireAny('sprite', 'spriteCollection', 'renderableLine', 'renderableBar'))

    -- handle z levels (default position.z = 0)
    function renderSystem:compare(e1, e2)
        return e1.position.z < e2.position.z
    end

    function renderSystem.renderSprite(entity, viewX, viewY)
        local sprite = entity.sprite
        love.graphics.draw(sprite.image, sprite.quad, viewX, viewY)
    end

    function renderSystem.renderSpriteCollection(entity, viewX, viewY)
        local spriteCollection = entity.spriteCollection
        for i = 1, #spriteCollection.quads do
            love.graphics.draw(spriteCollection.image, spriteCollection.quads[i],
                               viewX + spriteCollection.quadOffsets[i].x, 
                               viewY + spriteCollection.quadOffsets[i].y)
        end
    end

    function renderSystem.renderDebugLine(entity, viewX, viewY)
        local line = entity.renderableLine
        love.graphics.setColor(line.color)
        love.graphics.line(viewX + line.startX, viewY + line.startY, viewX + line.endX, viewY + line.endY)
        love.graphics.setColor(1, 1, 1) -- reset to white so it doesn't screw up the next render
    end

    function renderSystem.renderBar(entity, viewX, viewY)
        local bar = entity.renderableBar
        love.graphics.setColor(bar.bgColor)
        love.graphics.rectangle("fill", viewX, viewY, bar.width, bar.height)
        love.graphics.setColor(bar.fgColor)
        love.graphics.rectangle("fill", viewX, viewY, math.floor(bar.width * bar.value), bar.height)
        love.graphics.setColor(1, 1, 1) -- reset to white so it doesn't screw up the next render
    end

    -- the actual rendering code
    function renderSystem:process(entity, dt)
        local position = entity.position
        viewX = position.x - math.floor(self.camera.x)
        viewY = position.y - math.floor(self.camera.y)

        -- single sprite rendering
        if entity.sprite then
            renderSystem.renderSprite(entity, viewX, viewY)

        -- sprite collection rendering
        elseif entity.spriteCollection then
            renderSystem.renderSpriteCollection(entity, viewX, viewY)

        -- debug line
        elseif entity.renderableLine and constants.DEBUG_LINES_ENABLED then
            renderSystem.renderDebugLine(entity, viewX, viewY)

        -- renderable bar
        elseif entity.renderableBar then
            renderSystem.renderBar(entity, viewX, viewY)
        end
    end

    return renderSystem
end

return mymodule