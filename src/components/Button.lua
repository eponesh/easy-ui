local Component = require('src.components.Component')
local Merge = require('src.helpers.merge')
local makeProxy = require('src.helpers.makeProxy')

local Button = makeProxy(Component.Class, {}, Component.Class.get, Component.Class.set)
local ButtonPresets = Merge(Component.Presets, {
    frameTemplate = 'ReplayButton',
    width = 0.015,
    height = 0.04,
    text = 'My Button',
    _sizeMap = {
        XSMALL = { 0.1, 0.02 },
        SMALL = { 0.14, 0.03 },
        MEDIUM = { 0.18, 0.04 },
        LARGE = { 0.22, 0.05 },
        XLARGE = { 0.26, 0.06 }
    }
})

function Button.New(config)
    local button = makeProxy(Button, {}, Button.get, Button.set)
    button:defineModel(ButtonPresets)
    button:applyConfig(config)
    return button
end

return {
    Class = Button,
    Presets = ButtonPresets
}
