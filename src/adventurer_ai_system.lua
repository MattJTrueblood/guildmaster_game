local tiny = require('tiny')
local constants = require("constants")

local mymodule = {}

function mymodule:createAdventurerAISystem(pathsGraph)
    local adventurerAISystem = tiny.processingSystem({runDuringDrawPhase = true, pathsGraph = pathsGraph})
    adventurerAISystem.filter = tiny.requireAll('position', 'adventurerAI')

    -- the actual rendering code
    function adventurerAISystem:process(entity, dt)
        local position = entity.position
        local pathsGraph = self.pathsGraph
        -- todo move around adventurer randomly along pathsGraph
    end

    return adventurerAISystem
end

return mymodule