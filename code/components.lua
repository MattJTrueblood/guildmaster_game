local mymodule = {}

mymodule.position = function(x, y, z)
    return {x = x, y = y, z = z or 0}
end

mymodule.sprite = function(image, quad)
    return {image = image, quad = quad}
end

mymodule.spriteCollection = function(image, quads, quadOffsets, width, height)
    return {image = image, quads = quads, quadOffsets = quadOffsets, width=width, height=height}
end

mymodule.renderableLine = function(color, startX, startY, endX, endY)
    return {color = color, startX = startX, startY = startY, endX = endX, endY = endY}
end


return mymodule