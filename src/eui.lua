local deepClone = require('src.helpers.deepClone')
local merge = require('src.helpers.merge')

local EUI = {
    CloneDeep = deepClone,
    Merge = merge,
    IsReady = false,
    Origin = {
        CENTER = FRAMEPOINT_CENTER,
        TOP = FRAMEPOINT_TOP,
        BOTTOM = FRAMEPOINT_BOTTOM,
        LEFT = FRAMEPOINT_LEFT,
        RIGHT = FRAMEPOINT_RIGHT,
        TOPLEFT = FRAMEPOINT_TOPLEFT,
        TOPRIGHT = FRAMEPOINT_TOPRIGHT,
        BOTTOMLEFT = FRAMEPOINT_BOTTOMLEFT,
        BOTTOMRIGHT = FRAMEPOINT_BOTTOMRIGHT,
    },
    TextAlign = {
        MIDDLE = TEXT_JUSTIFY_MIDDLE,
        TOP = TEXT_JUSTIFY_TOP,
        BOTTOM = TEXT_JUSTIFY_BOTTOM,
        LEFT = TEXT_JUSTIFY_LEFT,
        RIGHT = TEXT_JUSTIFY_RIGHT,
        CENTER = TEXT_JUSTIFY_CENTER,
    },
    Position = {
        ZERO = { 0, 0 }
    },
    Frame = {
        MAIN = nil
    },
    Component = {
        BUTTON = 'BUTTON',
        ICON = 'ICON',
        TEXT = 'TEXT',
        TOOLTIP = 'TOOLTIP'
    },
    Size = {
        XSMALL = 'XSMALL',
        SMALL = 'SMALL',
        MEDIUM = 'MEDIUM',
        LARGE = 'LARGE',
        XLARGE = 'XLARGE'
    },
    _ReadyPromise = {}
}

return EUI
