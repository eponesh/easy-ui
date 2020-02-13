function PolledWait () return true end

-- frame
function BlzCreateFrameByType () return true end
function BlzFrameSetText () return true end
function BlzFrameSetPoint () return true end
function BlzFrameSetSize () return true end
function BlzGetOriginFrame () return true end
function BlzCreateFrame () return true end
function BlzFrameSetVisible () return true end
function TriggerAddAction () return true end
function TriggerExecute () return true end
function CreateTrigger () return true end
function BlzDestroyFrame () return true end
function BlzTriggerRegisterFrameEvent () return true end
function BlzFrameSetTexture () return true end
function BlzGetFrameByName () return true end
function BlzFrameSetScale () return true end
function BlzFrameSetTextAlignment () return true end
function BlzFrameSetTooltip () return true end

--quest
function CreateQuest () return true end
function DestroyQuest () return true end
function QuestSetTitle () return true end
function QuestSetDescription () return true end
function QuestSetIconPath () return true end

function QuestSetRequired () return true end
function QuestSetCompleted () return true end
function QuestSetDiscovered () return true end
function QuestSetFailed () return true end
function QuestSetEnabled () return true end
    
function IsQuestRequired () return true end
function IsQuestCompleted () return true end
function IsQuestDiscovered () return true end
function IsQuestFailed () return true end
function IsQuestEnabled () return true end

function QuestCreateItem () return true end
function QuestItemSetDescription () return true end
function QuestItemSetCompleted () return true end

function IsQuestItemCompleted () return true end

function CreateDefeatCondition () return true end
function DestroyDefeatCondition () return true end
function DefeatConditionSetDescription () return true end

function FlashQuestDialogButton () return true end
function ForceQuestDialogUpdate () return true end
function QuestMessageBJ () return true end

FRAMEPOINT_CENTER = 'FRAMEPOINT_CENTER'
FRAMEPOINT_TOP = 'FRAMEPOINT_TOP'
FRAMEPOINT_BOTTOM = 'FRAMEPOINT_BOTTOM'
FRAMEPOINT_LEFT = 'FRAMEPOINT_LEFT'
FRAMEPOINT_RIGHT = 'FRAMEPOINT_RIGHT'
FRAMEPOINT_TOPLEFT = 'FRAMEPOINT_TOPLEFT'
FRAMEPOINT_TOPRIGHT = 'FRAMEPOINT_TOPRIGHT'
FRAMEPOINT_BOTTOMLEFT = 'FRAMEPOINT_BOTTOMLEFT'
FRAMEPOINT_BOTTOMRIGHT = 'FRAMEPOINT_BOTTOMRIGHT'
ORIGIN_FRAME_GAME_UI = 'ORIGIN_FRAME_GAME_UI'
FRAMEEVENT_CONTROL_CLICK = 'FRAMEEVENT_CONTROL_CLICK'

TEXT_JUSTIFY_MIDDLE = 'TEXT_JUSTIFY_MIDDLE'
TEXT_JUSTIFY_TOP = 'TEXT_JUSTIFY_TOP'
TEXT_JUSTIFY_BOTTOM = 'TEXT_JUSTIFY_BOTTOM'
TEXT_JUSTIFY_LEFT = 'TEXT_JUSTIFY_LEFT'
TEXT_JUSTIFY_RIGHT = 'TEXT_JUSTIFY_RIGHT'
TEXT_JUSTIFY_CENTER = 'TEXT_JUSTIFY_CENTER'

bj_FORCE_ALL_PLAYERS = 'bj_FORCE_ALL_PLAYERS'

bj_QUESTMESSAGE_DISCOVERED = 'bj_QUESTMESSAGE_DISCOVERED'
bj_QUESTMESSAGE_UPDATED = 'bj_QUESTMESSAGE_UPDATED'
bj_QUESTMESSAGE_COMPLETED = 'bj_QUESTMESSAGE_COMPLETED'
bj_QUESTMESSAGE_FAILED = 'bj_QUESTMESSAGE_FAILED'
