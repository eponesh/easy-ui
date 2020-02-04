-- External Script
-- Map Initialization Handlers
-- @Author Bribe (https://www.hiveworkshop.com/threads/lua-global-initialization.317099/)

local gFuncs = {}
local tFuncs = {}
local iFuncs = {}
local sFuncs

function OnGlobalInit(func) --Runs once all variables are instantiated.
    gFuncs[func] = func --Simplification thanks to TheReviewer and Zed on Hive Discord
end

function OnTriggerInit(func) -- Runs once all InitTrig_ are called
    tFuncs[func] = func
end

function OnInitialization(func) -- Runs once all Map Initialization triggers are run
    iFuncs[func] = func
end

function OnGameStart(func) --runs once the game has actually started
    if not sFuncs then
        sFuncs = {}
        TimerStart(CreateTimer(), 0.00, false, function()
            DestroyTimer(GetExpiredTimer())
            for k, f in pairs(sFuncs) do f() end
            sFuncs = nil
        end)
    end
    sFuncs[func] = func
end

local function runInitialization()
    for k, f in pairs(iFuncs) do f() end
    iFuncs = nil
end

local function runTriggerInit()
    for k, f in pairs(tFuncs) do f() end
    tFuncs = nil
    local old = RunInitializationTriggers
    if old then
        function RunInitializationTriggers()
            old()
            runInitialization()
        end
    else
        runInitialization()
    end
end

local function runGlobalInit()
    for k, f in pairs(gFuncs) do f() end
    gFuncs = nil
    local old = InitCustomTriggers
    if old then
        function InitCustomTriggers()
            old()
            runTriggerInit()
        end
    else
        runTriggerInit()
    end
end

local oldBliz = InitBlizzard
function InitBlizzard()
    oldBliz()
    local old = InitGlobals
    if old then
        function InitGlobals()
            old()
            runGlobalInit()
        end
    else
        runGlobalInit()
    end
end

return {
    OnGlobalInit = OnGlobalInit,
    OnTriggerInit = OnTriggerInit,
    OnInitialization = OnInitialization,
    OnGameStart = OnGameStart
}
