local EUI = require('src.eui')
local Merge = require('src.helpers.merge')

local ComponentPresets = {
    frameTemplate = 'StandardLightBackdropTemplate',
    width = 0.1,
    height = 0.1,
    x = 0,
    y = 0,
    text = '',
    stickTo = EUI.Origin.CENTER,
    origin = EUI.Origin.CENTER,
    texture = ''
}

local ButtonPresets = Merge(ComponentPresets, {
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

local IconPresets = Merge(ComponentPresets, {
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

return {
    Component = ComponentPresets,
    Button = ButtonPresets,
    Icon = IconPresets
}
