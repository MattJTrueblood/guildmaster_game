local constants = require("constants")

local mymodule = {}

function mymodule.loadImageTiles(file, tileSize)
    local imagePath = "assets/images/" .. file
    local tilesetImage = love.graphics.newImage(imagePath)
    local tileWidth, tileHeight = tileSize, tileSize
    local tilesetWidth, tilesetHeight = tilesetImage:getWidth(), tilesetImage:getHeight()
    local numCols, numRows = tilesetWidth / tileWidth, tilesetHeight / tileHeight
    local tileMap = {}

    for i=1, numRows do
        for j=1, numCols do
            tileMap[(((i-1) * numCols) + j)] = 
                love.graphics.newQuad((j-1) * tileWidth,
                (i-1) * tileHeight, tileWidth, tileHeight, tilesetWidth, tilesetHeight)
        end
    end

    return tilesetImage, tileMap
end

-- load all images used by all sprite collections
local dungeonTilesetImage, dungeonTileMap = mymodule.loadImageTiles("dungeon_tileset.png", constants.TILE_SIZE)
local creaturesTilesetImage, creaturesTileMap = mymodule.loadImageTiles("creatures_tileset.png", constants.TILE_SIZE)
local miscTilesetImage, miscTileMap = mymodule.loadImageTiles("misc_tileset.png", constants.TILE_SIZE)

mymodule.dungeonTilesetImage = dungeonTilesetImage
mymodule.dungeonTileMap = dungeonTileMap 
mymodule.creaturesTilesetImage = creaturesTilesetImage
mymodule.creaturesTileMap = creaturesTileMap 
mymodule.miscTilesetImage = miscTilesetImage
mymodule.miscTileMap = miscTileMap

return mymodule
