-- Make proxy object with property support.
-- @version 3 - 20060921 (D.Manura)
local function makeProxy(class, priv, getters, setters, is_expose_private)
    setmetatable(priv, class)
    local fallback = is_expose_private and priv or class
    local index = getters and
        function(self, key)
            local func = getters[key]
            if func then return func(self) else return fallback[key] end
        end
        or fallback
    local newindex = setters and
        function(self, key, value)
            local func = setters[key]
            if func then func(self, value)
            else rawset(self, key, value) end
        end
        or fallback
    local proxy_mt = {
        __newindex = newindex,
        __index = index,
        priv = priv
    }
    local self = setmetatable({}, proxy_mt)
    return self
end

return makeProxy
