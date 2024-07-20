local tiny = require("tiny")
local render_system = require('render_system')
local monster_ai_system = require('monster_ai_system')
local adventurer_ai_system = require('adventurer_ai_system')
local adventurer_spawn_system = require('adventurer_spawn_system')
local map_generator = require('map_generator')
local camera = require('camera')
local constants = require("constants")

local drawSystemFilter = tiny.requireAll("runDuringDrawPhase")
local updateSystemFilter = tiny.rejectAll("runDuringDrawPhase")

-- CREATE WORLD OBJECT FOR ECS --
local world = tiny.world()

function love.load()
    local time = os.time()
    math.randomseed(time) --seeds the random number generator 

    love.graphics.setBackgroundColor(love.math.colorFromBytes(24, 20, 37))

    -- generate the map of the world, adding all the initial entities (rooms, monsters, chests, etc.)
    -- and returning for us a graph of walkable paths for adventurers
    local pathsGraph = map_generator.generate(world)

    -- add all the systems for the world
    world:addSystem(render_system:createRenderSystem(camera))
    world:addSystem(monster_ai_system)
    world:addSystem(adventurer_ai_system:createAdventurerAISystem(pathsGraph))
    world:addSystem(adventurer_spawn_system:createAdventurerSpawnSystem(pathsGraph.startX, pathsGraph.startY))

    --finally, refresh the world once before we start the game loop just to be safes
    world:refresh()
end

function love.update(dt)

    --handle input
    if love.keyboard.isDown("left") then
        camera:move(-constants.CAMERA_SPEED * dt, 0)
    end
    if love.keyboard.isDown("right") then
        camera:move(constants.CAMERA_SPEED * dt, 0)
    end
    if love.keyboard.isDown("up") then
        camera:move(0, -constants.CAMERA_SPEED * dt)
    end
    if love.keyboard.isDown("down") then
        camera:move(0, constants.CAMERA_SPEED * dt)
    end

    world:update(dt, updateSystemFilter)
end

function love.draw()
    world:update(love.timer.getDelta(), drawSystemFilter)
    if(constants.DISPLAY_FPS_ENABLED) then
        love.graphics.print(tostring(love.timer.getFPS()), 775, 580)
    end
end
