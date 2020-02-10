local Component = require('src.components.Component')
local Presets = require('src.presets.components')
local makeProxy = require('src.helpers.makeProxy')

local Icon = makeProxy(Component, {}, Component.get, Component.set)

function Icon.New(config)
    local icon = makeProxy(Icon, {}, Icon.get, Icon.set)
    icon:defineModel(Presets.Icon)
    icon:applyConfig(config)
    return icon
end

return Icon
