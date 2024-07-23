local tiny = require("tiny")

local mymodule = tiny.processingSystem()
mymodule.filter = tiny.requireAll("canPickupStuff", "canCollide", "inventory")
mymodule.toRemove = {}  -- List to hold entities to be removed after processing

function mymodule:process(entity, dt)
	for _, collidingEntity in ipairs(entity.canCollide.collisions) do
        if(collidingEntity.canBePickedUp ~= nil) then
            table.insert(entity.inventory.contents, collidingEntity.canBePickedUp.inventoryItem)
            table.insert(self.toRemove, collidingEntity)
        end
    end
end

function mymodule:postProcess(dt)
    for _, entity in ipairs(self.toRemove) do
        self.world:removeEntity(entity)
    end
    self.toRemove = {}  -- Clear the list after removal
end

return mymodule