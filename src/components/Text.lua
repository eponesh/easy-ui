local Component = require('src.components.Component')
local Merge = require('src.helpers.merge')
local makeProxy = require('src.helpers.makeProxy')
local EUI = require('src.eui')

local Text = makeProxy(Component.Class, {}, Component.Class.get, Component.Class.set)
local TextPresets = Merge(Component.Presets, {
    frameTemplate = 'StandardValueTextTemplate',
    size = 'medium',
    fontSize = 'medium',
    _type = EUI.Component.TEXT,
    _sizeMap = {
        XSMALL = { 0.1, 0.02 },
        SMALL = { 0.14, 0.03 },
        MEDIUM = { 0.18, 0.04 },
        LARGE = { 0.22, 0.05 },
        XLARGE = { 0.26, 0.06 }
    },
    _fontSizeScaleMap = {
        XSMALL = 0.6,
        SMALL = 0.8,
        MEDIUM = 1,
        LARGE = 1.3,
        XLARGE = 1.7
    }
})

function Text.New(config)
    local text = makeProxy(Text, {}, Text.get, Text.set)
    text:defineModel(TextPresets)
    text:applyConfig(config)
    return text
end

return {
    Class = Text,
    Presets = TextPresets
}
