-- Require doesnt work in WE
require('mock.blz')
local EUI = require('main')

-- WE working code
local firstText = EUI.CreateText()
firstText.text = '|cffffff00Extra Large Text For Title|r'
firstText.origin = 'top'
firstText.stickTo = 'top'
firstText.size = 'large'
firstText.fontSize = 'xlarge'
firstText.y = -0.04
firstText:OnClick(function()
    print('firstText CLICKED')
end)

local secondText = EUI.CreateText({
    text = 'Large Font Size For Description',
    size = 'large',
    fontSize = 'large',
    origin = 'top',
    stickTo = 'top',
    y = -0.1,
    onClick = function()
        print('secondText CLICKED')
    end
})

local thirdText = EUI.CreateText({
    text = [[
Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.
Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
    ]],
    fontSize = 'medium',
    origin = 'top',
    stickTo = 'top',
    y = -0.2,
    width = 0.3,
    height = 0.3,
    onClick = function()
        print('thirdText CLICKED')
    end
})

EUI.Ready(function ()
    EUI.GameFrame:AppendChild(firstText)
    EUI.GameFrame:AppendChild(secondText)
    EUI.GameFrame:AppendChild(thirdText)
end)
