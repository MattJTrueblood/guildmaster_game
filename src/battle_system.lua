-- this system handles battles between members of enemy factions

local tiny = require("tiny")

local mymodule = tiny.processingSystem()
mymodule.filter = tiny.requireAll("canCollide", "battler", "health", "faction", "id")

function mymodule:process(entity, dt)
	for _, collidingEntity in ipairs(entity.canCollide.collisions) do
        if(collidingEntity.battler ~= nil and collidingEntity.health ~= nil and collidingEntity.faction ~= nil and collidingEntity.id ~= nil) then
            if(self.areEnemies(entity.faction, collidingEntity.faction)) and entity.id.id < collidingEntity.id.id then
                self.handleBattle(entity, collidingEntity)
            end
        end
    end
end

function mymodule.handleBattle(battlerEntityA, battlerEntityB)
    battlerEntityB.health.current = battlerEntityB.health.current - math.max(battlerEntityA.battler.attack - battlerEntityB.battler.defense, 0)
    battlerEntityA.health.current = battlerEntityA.health.current - math.max(battlerEntityB.battler.attack - battlerEntityA.battler.defense, 0)
end

function mymodule.areEnemies(factionA, factionB)
    for _, enemyFaction in ipairs(factionA.enemyFactions) do
        if enemyFaction == factionB.factionName then
            return true
        end
    end
    return false
end

return mymodule