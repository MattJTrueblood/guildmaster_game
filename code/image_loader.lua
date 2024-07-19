local constants = require("constants")

local mymodule = {}

function mymodule.loadImageTiles(file, tileSize)
    local tilesetImage = love.graphics.newImage(file)
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

-- first, load all images used by all sprite collections
local tilesetImage, tileMap = mymodule.loadImageTiles("tileset.png", constants.TILE_SIZE)
mymodule.tilesetImage = tilesetImage
mymodule.tileMap = tileMap

return mymodule
