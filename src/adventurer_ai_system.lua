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
        local adventurerAI = entity.adventurerAI

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
                    adventurerAI.targetX = filteredConnections[randomChoice][1]
                    adventurerAI.targetY = filteredConnections[randomChoice][2]
                else
                    local randomChoice = math.random(1, #connections)
                    adventurerAI.targetX = connections[randomChoice][1]
                    adventurerAI.targetY = connections[randomChoice][2]
                end

                adventurerAI.lastVisited = {position.x, position.y}
            end
        end

        -- figure out how far to move
        local dx = adventurerAI.targetX - position.x
        local dy = adventurerAI.targetY - position.y
        local distance = math.sqrt(dx * dx + dy * dy)
        local moveDistance = adventurerAI.moveSpeed * dt

        if moveDistance >= distance then
            --you've reached the target, correct for overshoot and start waiting
            position.x = adventurerAI.targetX
            position.y = adventurerAI.targetY
        else
            --move towards the target
            local angle = math.atan2(dy, dx)
            position.x = position.x + moveDistance * math.cos(angle)
            position.y = position.y + moveDistance * math.sin(angle)
        end

    end

    return adventurerAISystem
end

return mymodule