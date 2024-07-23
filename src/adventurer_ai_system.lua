-- adventurer ai system handles the behavior of adventurers.  The adventurers follow a pathsGraph,
-- which is why this function uses a constructor instead of the module itself being the system.
-- Adventurers walk towards their target until they reach it.
-- when they reach their new target, they search for any paths that connect to the node at that point.
-- they try not to go towards the previous node unless there are no other connections.

local tiny = require('tiny')
local constants = require("constants")

local mymodule = {}

function mymodule:createAdventurerAISystem(pathsGraph)
    local adventurerAISystem = tiny.processingSystem({runDuringDrawPhase = true, pathsGraph = pathsGraph})
    adventurerAISystem.filter = tiny.requireAll('position', 'adventurerAI', 'targetMovement')

    function adventurerAISystem:process(entity, dt)
        local position = entity.position
        local pathsGraph = self.pathsGraph
        local adventurerAI = entity.adventurerAI
        local targetMovement = entity.targetMovement

        if(pathsGraph[position.x]) then
            if(pathsGraph[position.x][position.y]) then
                -- you've reached a graph node. Decide where to go next
                local connections = pathsGraph[position.x][position.y]

                local filteredConnections = {}
                if (adventurerAI.lastVisited ~= nil) then
                    for _, connection in ipairs(connections) do
                        if adventurerAI.lastVisited[1] ~= connection[1] or adventurerAI.lastVisited[2] ~= connection[2] then
                            table.insert(filteredConnections, connection)
                        end
                    end
                end

                if #filteredConnections > 0 then
                    local randomChoice = math.random(1, #filteredConnections)
                    targetMovement.targetX = filteredConnections[randomChoice][1]
                    targetMovement.targetY = filteredConnections[randomChoice][2]
                elseif #connections > 0 then
                    local randomChoice = math.random(1, #connections)
                    targetMovement.targetX = connections[randomChoice][1]
                    targetMovement.targetY = connections[randomChoice][2]
                end

                targetMovement.reachedTarget = false

                adventurerAI.lastVisited = {position.x, position.y}
            end
        end
    end

    return adventurerAISystem
end

return mymodule