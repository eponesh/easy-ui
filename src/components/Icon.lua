local Component = require('src.components.Component')
local Merge = require('src.helpers.merge')
local makeProxy = require('src.helpers.makeProxy')

local Icon = makeProxy(Component.Class, {}, Component.Class.get, Component.Class.set)
local IconPresets = Merge(Component.Presets, {
    frameTemplate = 'ScoreScreenBottomButtonTemplate',
    size = 'medium',
    iconPath = 'ReplaceableTextures/CommandButtons/BTNSelectHeroOn',
    _childFrames = {
        icon = 'ScoreScreenButtonBackdrop'
    },
    _sizeMap = {
        XSMALL = { 0.02, 0.02 },
        SMALL = { 0.04, 0.04 },
        MEDIUM = { 0.08, 0.08 },
        LARGE = { 0.12, 0.12 },
        XLARGE = { 0.16, 0.16 }
    }
})

function Icon.New(config)
    local icon = makeProxy(Icon, {}, Icon.get, Icon.set)
    icon:defineModel(IconPresets)
    icon:applyConfig(config)
    return icon
end

return {
    Class = Icon,
    Presets = IconPresets
}
