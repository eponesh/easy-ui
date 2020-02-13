local EUI = require('src.eui')

-- Check existing text aligments by link
local function isValidLinkTextAlign(textAlign)
    return textAlign == EUI.TextAlign.MIDDLE
        or textAlign == EUI.TextAlign.TOP
        or textAlign == EUI.TextAlign.BOTTOM
        or textAlign == EUI.TextAlign.LEFT
        or textAlign == EUI.TextAlign.RIGHT
        or textAlign == EUI.TextAlign.CENTER
end

-- Check existing text aligments by string and returns textalign
local function fromStringTextAlign(textAlign)
    if type(textAlign) == 'string' then
        local upperAlign = textAlign:upper()
        for alignName, align in pairs(EUI.TextAlign) do
            if upperAlign == alignName then
                return align
            end
        end
    end
end

-- Check both link and string text aligments
local function getConvertedTextAlign(textAlign)
    if isValidLinkTextAlign(textAlign) then
        return textAlign
    end

    local align = fromStringTextAlign(textAlign)

    if align ~= nil then
        return align
    end
end

return {
    getConvertedTextAlign = getConvertedTextAlign
}
