--FILO (first in last out) stack implementation, done super quick

local Stack = {}
Stack.__index = Stack

function Stack:new()
    local instance = {
        items = {}
    }
    setmetatable(instance, Stack)
    return instance
end

function Stack:push(item)
    table.insert(self.items, item)
end

function Stack:pop()
    if #self.items == 0 then
        return nil, "stack is empty"
    end
    return table.remove(self.items, #self.items)
end

function Stack:peek()
    if #self.items == 0 then
        return nil, "stack is empty"
    end
    return self.items[#self.items]
end

function Stack:size()
    return #self.items
end

return Stack