local Component = require('src.components.Component')
local EUI = require('src.eui')
local proto = require('src.helpers.proto')

local Button = proto.Inherit(Component)

local ButtonPresets = {
    frameTemplate = 'ReplayButton',
    size = { 0.015, 0.04 },
    position = EUI.Position.ZERO,
    text = 'My Button',
    stick = EUI.Origin.CENTER,
    origin = EUI.Origin.CENTER
}

function Button:New(config)
    local button = proto.Inherit(Button)
    button:defineModel(ButtonPresets)
    button:applyConfig(config)
    return button
end

return Button
