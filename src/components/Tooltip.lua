local Component = require('src.components.Component')
local Text = require('src.components.Text')
local Merge = require('src.helpers.merge')
local makeProxy = require('src.helpers.makeProxy')

local DEFAULT_PADDING = 0.03

local Tooltip = makeProxy(Component.Class, {}, Component.Class.get, Component.Class.set)
local TooltipPresets = Merge(Component.Presets, {
    frameTemplate = 'ListBoxWar3',
    width = 0.3,
    height = 0.15,
    _sizeMap = {
        XSMALL = { 0.1, 0.05 },
        SMALL = { 0.2, 0.1 },
        MEDIUM = { 0.3, 0.15 },
        LARGE = { 0.4, 0.2 },
        XLARGE = { 0.5, 0.25 }
    },
})

function Tooltip.New(config)
    local tooltip = makeProxy(Tooltip, {}, Tooltip.get, Tooltip.set)
    tooltip._sizeMap = TooltipPresets._sizeMap
    tooltip:defineModel(TooltipPresets)
    tooltip:applyConfig(config)
    tooltip:AppendChild(Text.Class.New({
        width = tooltip.width - 0.03,
        height = tooltip.height - 0.03,
    }))
    return tooltip
end

function Tooltip:updateSize()
    Component.Class.updateSize(self)

    if self.frame ~= nil and self.childrens[1] ~= nil then
        self.childrens[1].width = self.width - DEFAULT_PADDING
        self.childrens[1].height = self.height - DEFAULT_PADDING
    end

    return self
end

function Tooltip:updateText()
    if self.frame ~= nil and self.childrens[1] ~= nil then
        self.childrens[1].text = self.text
    end
    return self
end

return {
    Class = Tooltip,
    Presets = TooltipPresets
}
