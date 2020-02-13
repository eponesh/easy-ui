-- Require doesnt work in WE
local EUI = require('main')
require('mock.blz')
require('mock.eui')

-- WE working code
-- Describes quest
local requiredQuest = EUI.CreateQuest({
    title = 'Shard Hunt',
    description = 'A shard is visible in the distance. It took so long to search, and finally, fate sent him.',
    icon = 'ReplaceableTextures/CommandButtons/BTNOrbOfDarkness.blp',
    required = true
})

-- Describes tasks for quest
local firstTask = requiredQuest:AddTask('Kill all zombies')
local secondTask = requiredQuest:AddTask('Scout the way')
local thirdTask = requiredQuest:AddTask('Pick up the shard')

local killedZombies = 0

EUI.Ready(function ()
    -- First task trigger
    local zombieTrigger = CreateTrigger()
    TriggerAddAction(zombieTrigger, function ()
        killedZombies = killedZombies + 1
        if killedZombies == 3 then
            firstTask:Complete()
            DestroyTrigger(zombieTrigger)
        end
    end)

    -- For each zombie: call trigger on death to increment counter
    local zombies = GetUnitsInRectAll(udg_ZombiesRegion)
    ForGroup(zombies, function ()
        TriggerRegisterDeathEvent(zombieTrigger, GetEnumUnit())
    end)

    -- Mark quest as discovered on enters region
    local startQuestRegionTrigger = CreateTrigger()
    TriggerAddAction(startQuestRegionTrigger, function ()
        if GetTriggerUnit() == udg_MY_HERO then
            requiredQuest.discovered = true
            DestroyTrigger(startQuestRegionTrigger)
        end
    end)
    TriggerRegisterEnterRectSimple(startQuestRegionTrigger, udg_StartQuestRegion)

    -- Mark second task completed on enters region
    local updateQuestRegionTrigger = CreateTrigger()
    TriggerAddAction(updateQuestRegionTrigger, function ()
        if GetTriggerUnit() == udg_MY_HERO then
            secondTask:Complete()
            DestroyTrigger(updateQuestRegionTrigger)
        end
    end)
    TriggerRegisterEnterRectSimple(updateQuestRegionTrigger, udg_UpdateQuestRegion)

    -- Mark quest failed on enters region
    local failQuestRegionTrigger = CreateTrigger()
    TriggerAddAction(failQuestRegionTrigger, function ()
        KillUnit(udg_MY_HERO)
        requiredQuest.failed = true
    end)
    TriggerRegisterEnterRectSimple(failQuestRegionTrigger, udg_DieRegion)

    -- Mark third task completed on enters region and autocomplete quest
    local pickItemTrigger = CreateTrigger()
    TriggerAddAction(pickItemTrigger, function ()
        if GetTriggerUnit() == udg_MY_HERO and GetManipulatedItem() == udg_SPHERE then
            thirdTask:Complete()
        end
    end)
    TriggerRegisterAnyUnitEventBJ(pickItemTrigger, EVENT_PLAYER_UNIT_PICKUP_ITEM)
end)
