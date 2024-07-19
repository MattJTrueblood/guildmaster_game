local tiny = require("tiny")
local components = require("components")
local sprite_collections = require('sprite_collections')
local imageloader = require('image_loader')
local Stack = require('stack')

local mymodule = {}

local function createRoomAt(x, y)
    return {
        position = components.position(x, y, 0),
        spriteCollection = sprite_collections.collections.room1
    }
end

local function createChestAt(x, y)
    return {
        position = components.position(x, y, 2),
        sprite = components.sprite(imageloader.tilesetImage, imageloader.tileMap[148]) -- chest sprite
    }
end

local function createLadderAt(x, y)
    return {
        position = components.position(x, y, 1),
        spriteCollection = sprite_collections.collections.ladder
    }
end

local function createDoorAt(x, y)
    return {
        position = components.position(x, y, 2),
        spriteCollection = sprite_collections.collections.door
    }
end

local function createHallwayAt(x, y)
    return {
        position = components.position(x, y, 1),
        spriteCollection = sprite_collections.collections.hallway
    }
end

local function createLine(x1, y1, x2, y2)
    return {
        position = components.position(0, 0, 999),
        renderableLine = components.renderableLine({1, 0, 0}, x1, y1, x2, y2)   
    }
end

local function isWithinBounds(x, y, num_rooms_x, num_rooms_y)
    return x >= 0 and x < num_rooms_x and y >= 0 and y < num_rooms_y
end

local function getNeighborOffsets()
    return {
        {1, 0}, {-1, 0}, {0, 1}, {0, -1}
    }
end

local function shuffle(t)
    for i = #t, 2, -1 do
        local j = math.random(i)
        t[i], t[j] = t[j], t[i]
    end
end

function mymodule.generate(world)
    local window_width, window_height = love.graphics.getDimensions()
    local room_width = sprite_collections.collections.room1.width
    local room_height = sprite_collections.collections.room1.height
    local buffer = 16
    local num_rooms_x = math.floor((window_width - buffer) / (room_width + buffer))
    local num_rooms_y = math.floor((window_height - buffer) / (room_height + buffer))

    -- first create the entrance ladder into room 0,0
    world:addEntity(createLadderAt(buffer + 32, buffer - 48))

    -- create all the base rooms
    for i = 0, num_rooms_x - 1 do
        for j = 0, num_rooms_y - 1 do
            local x_position = buffer + i * (room_width + buffer)
            local y_position = buffer + j * (room_height + buffer)
            world:addEntity(createRoomAt(x_position, y_position))

            --- add a chest randomly
            if(math.random(1, 8) == 1) then
                world:addEntity(createChestAt(x_position + 48, y_position + 64))
            end
        end
    end

    -- initialize the visited grid
    local visited = {}
    for i = 0, num_rooms_x - 1 do
        visited[i] = {}
        for j = 0, num_rooms_y - 1 do
            visited[i][j] = false
        end
    end

    -- set up the DFS stack
    local stack = Stack:new()
    local start_x, start_y = 0, 0
    stack:push({start_x, start_y})
    visited[start_x][start_y] = true
    local last_move_vertical = false
    local forbid_double_vertical = true

    -- now, do the DFS maze generation
    while stack:size() > 0 do
        local current = stack:peek()
        local x, y = current[1], current[2]
        local neighbors = getNeighborOffsets()
        shuffle(neighbors)
        local moved = false

        for _, offset in ipairs(neighbors) do
            local nx, ny = x + offset[1], y + offset[2]
            local is_vertical_move = offset[2] ~= 0
            if isWithinBounds(nx, ny, num_rooms_x, num_rooms_y) and not visited[nx][ny] then
                -- forbid consecutive ladders (including the entrance ladder) by tracking if the last move is vertical
                if (forbid_double_vertical and (x == 0 and y == 0 and offset[2] == 1) or (is_vertical_move and last_move_vertical)) then
                    moved = false
                else
                    -- moving to the next tile
                    visited[nx][ny] = true
                    stack:push({nx, ny})
                    moved = true
                    last_move_vertical = is_vertical_move

                    -- add the hallway or ladder entities for the connection we're opening here
                    local room_x_position = buffer + x * (room_width + buffer)
                    local room_y_position = buffer + y * (room_height + buffer)

                    if(offset[1] == 0 and offset[2] == 1) then --down
                        world:addEntity(createLadderAt(room_x_position + 32, room_y_position + 64))
                    elseif(offset[1] == 0 and offset[2] == -1) then --up
                        world:addEntity(createLadderAt(room_x_position + 32, room_y_position - 48))
                    elseif(offset[1] == 1 and offset[2] == 0) then --right
                        world:addEntity(createHallwayAt(room_x_position + 96, room_y_position + 32))
                        if(math.random(1, 3) == 1) then
                            world:addEntity(createDoorAt(room_x_position + 112, room_y_position + 48))
                        end
                    elseif(offset[1] == -1 and offset[2] == 0) then --left
                        world:addEntity(createHallwayAt(room_x_position - 32, room_y_position + 32))
                        if(math.random(1, 3) == 1) then
                            world:addEntity(createDoorAt(room_x_position - 16, room_y_position + 48))
                        end
                    end

                    --add debug line for fun
                    local x1 = buffer + x * (room_width + buffer) + room_width / 2
                    local y1 = buffer + y * (room_height + buffer) + room_height / 2
                    local x2 = buffer + nx * (room_width + buffer) + room_width / 2
                    local y2 = buffer + ny * (room_height + buffer) + room_height / 2
                    world:addEntity(createLine(x1, y1, x2, y2))
                    
                    break
                end
            end
        end

        if not moved then
            stack:pop()
            last_move_vertical = true
        end
    end       
end



return mymodule