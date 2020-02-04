-- Copy Table (http://lua-users.org/wiki/CopyTable)
local function DeepClone(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[DeepClone(orig_key)] = DeepClone(orig_value)
        end
        setmetatable(copy, DeepClone(getmetatable(orig)))
    else
        copy = orig
    end
    return copy
end

return DeepClone
