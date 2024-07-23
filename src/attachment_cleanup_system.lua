-- attachment cleanup system handles an edge case in attachment system
-- it deletes any attached entities if the parent entity itself is deleted.

local tiny = require("tiny")

local mymodule = tiny.system()
mymodule.filter = tiny.requireAll("hasAttachments")

function mymodule:onRemove(entity)
    for _, attachedEntity in ipairs(entity.hasAttachments.attachedEntities) do
        self.world:removeEntity(attachedEntity)
    end
end

return mymodule