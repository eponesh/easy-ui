-- Require doesnt work in WE
require('mock.blz')
local EUI = require('main')

-- WE working code
local firstButton = EUI.CreateButton()
firstButton.text = 'Button Center'
firstButton.width = 0.2
firstButton.height = 0.04
firstButton.x = 0
firstButton.y = 0
firstButton.stickTo = 'cetner'
firstButton:OnClick(function()
    print('firstButton CLICKED')
end)

local secondButton = EUI.CreateButton({
    text = 'CLICK ME',
    size = 'large',
    y = -0.1,
    origin = 'right',
    stickTo = 'top',
    onClick = function(self)
        self.text = 'CLICKED'
        print('secondButton CLICKED')
    end
})

EUI.Ready(function ()
    EUI.GameFrame:AppendChild(firstButton)
    EUI.GameFrame:AppendChild(secondButton)
end)
