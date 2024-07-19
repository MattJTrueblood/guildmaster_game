local tiny = require("tiny")

local render_system = require('render_system')
local map_generator = require('map_generator')
local camera = require('camera')

local drawSystemFilter = tiny.requireAll("runDuringDrawPhase")
local updateSystemFilter = tiny.rejectAll("runDuringDrawPhase")

-- CREATE WORLD OBJECT FOR ECS --
local world = tiny.world()

function love.load()
    local time = os.time()
    math.randomseed(time) --seeds the random number generator 

    love.graphics.setBackgroundColor(love.math.colorFromBytes(24, 20, 37))

    -- add all the systems for the world
    world:addSystem(render_system)

    -- add all the entities for the world
    map_generator.generate(world)

    --finally, refresh the world once before we start the game loop just to be safes
    world:refresh()
end

function love.update(dt)

    --handle input
    if love.keyboard.isDown("left") then
        camera:move(-100 * dt, 0)
    end
    if love.keyboard.isDown("right") then
        camera:move(100 * dt, 0)
    end
    if love.keyboard.isDown("up") then
        camera:move(0, -100 * dt)
    end
    if love.keyboard.isDown("down") then
        camera:move(0, 100 * dt)
    end

    --print(camera.x, camera.y)

    world:update(dt, updateSystemFilter)
end

function love.draw()
    world:update(love.timer.getDelta(), drawSystemFilter)
end
