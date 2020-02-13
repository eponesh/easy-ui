-- Require doesnt work in WE
local EUI = require('main')
require('mock.blz')
require('mock.eui')

-- WE working code
EUI.SetLanguage(EUI.Languages.RUSSIAN)

local requiredQuest = EUI.CreateQuest({
    title = 'Обязательный квест',
    description = 'Описание обязательного квеста',
    icon = 'ReplaceableTextures/CommandButtons/BTNPeasant.blp',
    required = true,
    tasks = {
        'Первая Задача текстом',
        { description = 'Вторая задача описанием' }
    }
})

local thirdTask = requiredQuest:AddTask({ description  = 'Третья задача описанием' })
requiredQuest:AddTask('Четвертая задача описанием')

local startQuestButton = EUI.CreateButton({
    text = 'Discover task',
    size = 'large',
    y = -0.1,
    origin = 'right',
    stickTo = 'top',
    onClick = function()
        print('startQuestButton CLICKED')
        requiredQuest.discovered = true
        requiredQuest:Flash()
    end
})

local updateQuestButton = EUI.CreateButton({
    text = 'Update task',
    y = -0.1,
    size = 'medium',
    origin = 'right',
    stickTo = 'right',
    onClick = function()
        print('updateQuestButton CLICKED')
        requiredQuest:CompleteTask(thirdTask)
    end
})

EUI.Ready(function ()
    EUI.GameFrame:AppendChild(startQuestButton)
    EUI.GameFrame:AppendChild(updateQuestButton)
end)
