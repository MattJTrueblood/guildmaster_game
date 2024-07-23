local tiny = require("tiny")
local components = require("components")

local mymodule = tiny.processingSystem()
mymodule.filter = tiny.requireAll("attachedTo", "position")

function mymodule:process(entity, dt)
    if(entity.attachedTo.attachedToEntity ~= nil) then
        if(entity.attachedTo.attachedToEntity.position ~= nil) then
            entity.position.x = entity.attachedTo.attachedToEntity.position.x + entity.attachedTo.xOffset
            entity.position.y = entity.attachedTo.attachedToEntity.position.y + entity.attachedTo.yOffset
        end
    end
end

function mymodule:onAdd(entity)
    local attachedTo = entity.attachedTo
    if attachedTo.attachedToEntity.hasAttachments == nil then
        attachedTo.attachedToEntity.hasAttachments = components.hasAttachments()
    end

    table.insert(attachedTo.attachedToEntity.hasAttachments.attachedEntities, entity)
end

function mymodule:onRemove(entity)
    local attachedTo = entity.attachedTo
    if attachedTo.attachedToEntity.hasAttachments then
        local attachedEntities = attachedTo.attachedToEntity.hasAttachments.attachedEntities
        for i, attachedEntity in ipairs(attachedEntities) do
            if attachedEntity == entity then
                table.remove(attachedEntities, i)
                break
            end
        end
    end
end

return mymodule