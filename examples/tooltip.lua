-- Require doesnt work in WE
require('mock.blz')
local EUI = require('main')

-- WE working code
local firstTooltip = EUI.CreateTooltip()
firstTooltip.text = [[
    Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
    Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
    Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.
    Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
]]
firstTooltip:OnClick(function()
    print('firstTooltip CLICKED')
end)

local secondTooltip = EUI.CreateTooltip({
    text = 'Tooltip as Realy tooltip for button',
    origin = 'top',
    stickTo = 'bottom',
    size = 'small',
    onClick = function(self)
        self.text = 'CLICKED'
        print('secondTooltip CLICKED')
    end
})

local icon = EUI.CreateIcon({
    iconPath = 'ReplaceableTextures/CommandButtons/BTNSylvanas.blp',
    size = 'large',
    origin = 'topright',
    stickTo = 'top',
    tooltip = secondTooltip,
    onClick = function()
        print('icon CLICKED')
    end
})

EUI.Ready(function ()
    EUI.GameFrame:AppendChild(firstTooltip)
    EUI.GameFrame:AppendChild(secondTooltip)
    EUI.GameFrame:AppendChild(icon)
end)
