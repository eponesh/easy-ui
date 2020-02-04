local EUI = require('src.eui')

-- Check existing frame points by link
local function isValidLinkFramePoint(framePoint)
    return framePoint == EUI.Origin.CENTER
        or framePoint == EUI.Origin.TOP
        or framePoint == EUI.Origin.BOTTOM
        or framePoint == EUI.Origin.LEFT
        or framePoint == EUI.Origin.RIGHT
        or framePoint == EUI.Origin.TOPLEFT
        or framePoint == EUI.Origin.TOPRIGHT
        or framePoint == EUI.Origin.BOTTOMLEFT
        or framePoint == EUI.Origin.BOTTOMRIGHT
end

-- Check existing frame points by string and returns framepoint
local function fromStringFramePoint(framePoint)
    if type(framePoint) == 'string' then
        local upperPoint = framePoint:upper()
        for pointName, point in pairs(EUI.Origin) do
            if upperPoint == pointName then
                return point
            end
        end
    end
end

-- Check both link and string frame points
local function getConvertedFramePoint(framePoint)
    if isValidLinkFramePoint(framePoint) then
        return framePoint
    end

    local point = fromStringFramePoint(framePoint)

    if point ~= nil then
        return point
    end
end

return {
    getConvertedFramePoint = getConvertedFramePoint
}
