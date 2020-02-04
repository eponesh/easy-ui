local function NewClass ()
    local class = {}
    class.__index = class
    return class
end

local function Inherit (parent)
    local instance = {}
    setmetatable(instance, { __index = parent })
    return instance
end

return {
    NewClass = NewClass,
    Inherit = Inherit
}
