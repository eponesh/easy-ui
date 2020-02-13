-- Require doesnt work in WE
require('mock.blz')
local EUI = require('main')

-- WE working code
local firstIcon = EUI.CreateIcon()
firstIcon.iconPath = 'ReplaceableTextures/CommandButtons/BTNMuradinBronzeBeard'
firstIcon.stickTo = 'center'
firstIcon.size = 'large'
firstIcon:OnClick(function()
    print('firstIcon CLICKED')
end)

local secondIcon = EUI.CreateIcon({
    iconPath = 'ReplaceableTextures/CommandButtons/BTNSylvanas',
    size = 'xlarge',
    origin = 'topright',
    stickTo = 'top',
    onClick = function()
        print('secondIcon CLICKED')
    end
})

EUI.Ready(function ()
    EUI.GameFrame:AppendChild(firstIcon)
    EUI.GameFrame:AppendChild(secondIcon)
end)
