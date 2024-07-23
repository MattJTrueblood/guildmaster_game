-- death system removes mortal entities whose health has reached zero

local tiny = require("tiny")

local mymodule = tiny.processingSystem()
mymodule.filter = tiny.requireAll("health", "mortal")

mymodule.toRemove = {}  -- List to hold entities to be removed after processing

function mymodule:process(entity, dt)
	if (entity.health.current <= 0) then
		table.insert(self.toRemove, entity)
	end
end

function mymodule:postProcess(dt)
    for _, entity in ipairs(self.toRemove) do
    	if(entity.hasAttachments ~= nil) then -- weird case, can't figure out how to do this in a separate system
	    	for _, attachedEntity in ipairs(entity.hasAttachments.attachedEntities) do
		        self.world:removeEntity(attachedEntity)
		    end
	   	end
        self.world:removeEntity(entity)
    end
    self.toRemove = {}  -- Clear the list after removal
end

return mymodule