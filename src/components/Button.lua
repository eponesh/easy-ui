local Component = require('src.components.Component')
local Presets = require('src.presets.components')
local makeProxy = require('src.helpers.makeProxy')

local Button =  makeProxy(Component, {}, Component.get, Component.set)

function Button.New(config)
    local button = makeProxy(Button, {}, Button.get, Button.set)
    button:defineModel(Presets.Button)
    button:applyConfig(config)
    return button
end

return Button
