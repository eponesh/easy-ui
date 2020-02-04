-- Require doesnt work in WE
require('mock.blz')
local EUI = require('main')

-- WE working code
local firstButton = EUI.CreateButton()
    :Text('Button Left')
    :Size(0.2, 0.04)
    :Position(0, -0.5)
    :Origin('center')
    :Stick('top')
    :OnClick(function()
        print('firstButton CLICKED')
    end)

local secondButton = EUI.CreateButton()
    :Text('RIGHT')
    :Size(0.1, 0.04)
    :Position(0, -0.1)
    :Origin('center')
    :Stick('right')
    :OnClick(function()
        print('secondButton CLICKED')
    end)

EUI.Ready(function ()
    EUI.Append(firstButton, EUI.Frame.MAIN)
    EUI.Append(secondButton, EUI.Frame.MAIN)
end)
