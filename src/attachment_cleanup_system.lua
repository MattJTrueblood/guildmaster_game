local tiny = require("tiny")

local mymodule = tiny.system()
mymodule.filter = tiny.requireAll("hasAttachments")

function mymodule:onRemove(entity)
    for _, attachedEntity in ipairs(entity.hasAttachments.attachedEntities) do
        self.world:removeEntity(attachedEntity)
    end
end

return mymodule