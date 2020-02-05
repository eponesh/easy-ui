-- Merge tables
local function merge(...)
    local combinedTable = {}
    local arg = {...}

    for k, v in pairs(arg) do
        if type(v) == 'table' then
            for tk, tv in pairs(v) do
                combinedTable[tk] = tv
            end
        end
    end

    return combinedTable
end

return merge
