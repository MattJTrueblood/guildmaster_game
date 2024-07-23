-- this system sets up all of the spriteCollections that should never change during the game.
-- for example, the sprites that make up a room, or a ladder, or a hallway.

local components = require("components")
local constants = require("constants")
local imageloader = require("image_loader")

local mymodule = {}

-- this function is used to convert a 2d grid of tileMap indices to a spriteCollection component.
function mymodule.createSpriteCollection(grid, tileMap, tileSize, tilesetImage)
    local quads = {}
    local quadOffsets = {}

    for i = 1, #grid do
        for j = 1, #grid[i] do
            local tileIndex = grid[i][j]
            table.insert(quads, tileMap[tileIndex])
            table.insert(quadOffsets, {x = (j - 1) * tileSize, y = (i - 1) * tileSize})
        end
    end

    local width = #grid[1] * tileSize
    local height = #grid * tileSize

    return components.spriteCollection(tilesetImage, quads, quadOffsets, width, height)
end

-- next, define each sprite collection as a 2d grid of indices in the tileMap
local room1_grid = {
    {52, 48, 48, 48, 48, 48, 51},
    {34, 33, 33, 116, 33, 33, 32},
    {34, 29, 33, 33, 33, 33, 32},
    {34, 33, 33, 33, 59, 33, 32},
    {34, 33, 33, 33, 33, 28, 32},
    {37, 18, 18, 18, 18, 18, 36}
}

local ladder_grid = {
    {126},
    {141},
    {141},
    {141},
    {141},
    {141},
    {141},
    {171}
}

local hallway_grid = {
    {47, 48, 49},
    {33, 33, 33},
    {33, 59, 33},
    {18, 18, 18}
}

local door_grid = {
    {164},
    {179}
}

-- now we build the actual collections from the grids by calling the function from before
local room1_spriteCollection = mymodule.createSpriteCollection(room1_grid, imageloader.dungeonTileMap, constants.TILE_SIZE, imageloader.dungeonTilesetImage)
local ladder_spriteCollection = mymodule.createSpriteCollection(ladder_grid, imageloader.dungeonTileMap, constants.TILE_SIZE, imageloader.dungeonTilesetImage)
local hallway_spriteCollection = mymodule.createSpriteCollection(hallway_grid, imageloader.dungeonTileMap, constants.TILE_SIZE, imageloader.dungeonTilesetImage)
local door_spriteCollection = mymodule.createSpriteCollection(door_grid, imageloader.dungeonTileMap, constants.TILE_SIZE, imageloader.dungeonTilesetImage)

-- finally, we save each collection to the module table so they can be reused at will
mymodule.collections = {
    room1 = room1_spriteCollection,
    ladder = ladder_spriteCollection,
    hallway = hallway_spriteCollection,
    door = door_spriteCollection
}

return mymodule