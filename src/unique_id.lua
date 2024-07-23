-- a small module which helps generate unique ids for entities

local mymodule = {}

mymodule.idCounter = 0

function mymodule:generateUniqueId()
	self.idCounter = self.idCounter + 1
    return self.idCounter
end

return mymodule
