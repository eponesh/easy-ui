--[[
Easy UI Build v0.0.1
@Author Sergey Eponeshnikov (https://github.com/eponesh)
]]

__EUI_SCOPED_MODULES = {}

-- ModuleName: "src.eui"
do
local EUI = {
    IsReady = false,
    Origin = {
        CENTER = FRAMEPOINT_CENTER,
        TOP = FRAMEPOINT_TOP,
        BOTTOM = FRAMEPOINT_BOTTOM,
        LEFT = FRAMEPOINT_LEFT,
        RIGHT = FRAMEPOINT_RIGHT,
        TOPLEFT = FRAMEPOINT_TOPLEFT,
        TOPRIGHT = FRAMEPOINT_TOPRIGHT,
        BOTTOMLEFT = FRAMEPOINT_BOTTOMLEFT,
        BOTTOMRIGHT = FRAMEPOINT_BOTTOMRIGHT,
    },
    Position = {
        ZERO = { 0, 0 }
    },
    Frame = {
        MAIN = nil
    },
    Component = {
        BUTTON = 'BUTTON',
        TEXT = 'TEXT',
        TOOLTIP = 'TOOLTIP'
    },
    _ReadyPromise = {}
}

__EUI_SCOPED_MODULES['src.eui'] = EUI
end

-- ModuleName: "src.helpers.mapHooks"
do
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

__EUI_SCOPED_MODULES['src.helpers.mapHooks'] = {
    OnGlobalInit = OnGlobalInit,
    OnTriggerInit = OnTriggerInit,
    OnInitialization = OnInitialization,
    OnGameStart = OnGameStart
}
end

-- ModuleName: "src.helpers.proto"
do
local function NewClass ()
    local class = {}
    class.__index = class
    return class
end

local function Inherit (parent)
    local instance = {}
    setmetatable(instance, { __index = parent })
    return instance
end

__EUI_SCOPED_MODULES['src.helpers.proto'] = {
    NewClass = NewClass,
    Inherit = Inherit
}
end

-- ModuleName: "src.helpers.framePoints"
do
local EUI = __EUI_SCOPED_MODULES['src.eui']

-- Check existing frame points by link
local function isValidLinkFramePoint(framePoint)
    return framePoint == EUI.Origin.CENTER
        or framePoint == EUI.Origin.TOP
        or framePoint == EUI.Origin.BOTTOM
        or framePoint == EUI.Origin.LEFT
        or framePoint == EUI.Origin.RIGHT
        or framePoint == EUI.Origin.TOPLEFT
        or framePoint == EUI.Origin.TOPRIGHT
        or framePoint == EUI.Origin.BOTTOMLEFT
        or framePoint == EUI.Origin.BOTTOMRIGHT
end

-- Check existing frame points by string and returns framepoint
local function fromStringFramePoint(framePoint)
    if type(framePoint) == 'string' then
        local upperPoint = framePoint:upper()
        for pointName, point in pairs(EUI.Origin) do
            if upperPoint == pointName then
                return point
            end
        end
    end
end

-- Check both link and string frame points
local function getConvertedFramePoint(framePoint)
    if isValidLinkFramePoint(framePoint) then
        return framePoint
    end

    local point = fromStringFramePoint(framePoint)

    if point ~= nil then
        return point
    end
end

__EUI_SCOPED_MODULES['src.helpers.framePoints'] = {
    getConvertedFramePoint = getConvertedFramePoint
}
end

-- ModuleName: "src.helpers.deepClone"
do
-- Copy Table (http://lua-users.org/wiki/CopyTable)
local function DeepClone(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[DeepClone(orig_key)] = DeepClone(orig_value)
        end
        setmetatable(copy, DeepClone(getmetatable(orig)))
    else
        copy = orig
    end
    return copy
end

__EUI_SCOPED_MODULES['src.helpers.deepClone'] = DeepClone
end

-- ModuleName: "src.components.Component"
do
local EUI = __EUI_SCOPED_MODULES['src.eui']
local proto = __EUI_SCOPED_MODULES['src.helpers.proto']
local fp = __EUI_SCOPED_MODULES['src.helpers.framePoints']
local DeepClone = __EUI_SCOPED_MODULES['src.helpers.deepClone']

local Component = proto.NewClass()

local ComponentPresets = {
    frameTemplate = 'StandardLightBackdropTemplate',
    size = { 0.1, 0.1 },
    position = EUI.Position.ZERO,
    text = '',
    stick = EUI.Origin.CENTER,
    origin = EUI.Origin.CENTER
}

function Component:New(config)
    local component = proto.Inherit(Component)
    component:defineModel(ComponentPresets)
    component:applyConfig(config)
    return component
end

function Component:defineModel(preset)
    self.model = {
        clickHandler = nil
    }

    for k, v in pairs(DeepClone(preset)) do self.model[k] = v end
    return self
end

function Component:applyConfig(config)
    if config == nil then return end
    -- For validate data
    if config.text then self:Text(config.text) end
    if config.size then self:Size(config.size) end
    if config.position then self:Position(config.position) end
    if config.origin then self:Origin(config.origin) end
    if config.stick then self:Stick(config.stick) end
    return self;
end

function Component:updateText()
    if self.frame ~= nil then
        BlzFrameSetText(self.frame, self.model.text)
    end
    return self;
end

function Component:updatePosition()
    if self.frame ~= nil then
        BlzFrameSetPoint(
            self.frame,
            self.model.origin,
            self.parent,
            self.model.stick,
            self.model.position[1],
            self.model.position[2]
        )
    end
    return self;
end

function Component:updateSize()
    if self.frame ~= nil then
        BlzFrameSetSize(self.frame, self.model.size[1], self.model.size[2])
    end
    return self;
end

function Component:Text(newText)
    if newText ~= nil then
        self.model.text = newText
        self:updateText()
        return self
    end
    return self.model.text
end

function Component:Size(widthOrSize, height)
    if widthOrSize == nil then
        return self.model.size
    end

    if type(widthOrSize) == 'table'
    and type(widthOrSize[1]) == 'number'
    and type(widthOrSize[2]) == 'number' then
        self.model.size[1] = widthOrSize[1]
        self.model.size[2] = widthOrSize[2]

        self:updateSize()
        return self
    end

    if type(widthOrSize) == 'number' then
        self.model.size[1] = widthOrSize
    end
    if type(height) == 'number' then
        self.model.size[2] = height
    end

    self:updateSize()
    return self
end

function Component:Position(positionOrX, y)
    if positionOrX == nil then
        return self.model.position
    end

    if type(positionOrX) == 'table'
        and type(positionOrX[1]) == 'number'
        and type(positionOrX[2]) == 'number' then
        self.model.position[1] = positionOrX[1]
        self.model.position[2] = positionOrX[2]

        self:updatePosition()
        return self
    end

    if type(positionOrX) == 'number' then
        self.model.position[1] = positionOrX
    end

    if type(y) == 'number' then
        self.model.position[2] = y
    end

    self:updatePosition()
    return self
end

function Component:Origin(framePoint)
    if framePoint ~= nil and framePoint ~= self.model.origin then
        local point = fp.getConvertedFramePoint(framePoint)
        if point ~= nil then
            self.model.origin = point
            self:updatePosition()
        end

        return self
    end

    return self.model.origin
end

function Component:Stick(framePoint)
    if framePoint ~= nil and framePoint ~= self.model.stick then
        local point = fp.getConvertedFramePoint(framePoint)
        if point ~= nil then
            self.model.stick = point
            self:updatePosition()
        end
        return self
    end
    return self.model.stick
end

function Component:mount(parent)
    self.frame = BlzCreateFrame(self.model.frameTemplate, parent, 0, 0)
    self.parent = parent
    self:updatePosition()
    self:updateSize()
    self:updateText()
    self:registerClick()
end

function Component:unmount()
    if self.frame ~= nil then
        BlzDestroyFrame(self.frame)
    end
    self.frame = nil
    self.parent = nil
end

function Component:IsMounted()
    return self.frame ~= nil and self.parent ~= nil
end

function Component:Clone()
    return self.New(self.model)
end

function Component:OnClick(handler)
    if type(handler) == 'function' then
        self.model.clickHandler = handler
    end

    self:registerClick()
    return self
end

function Component:registerClick()
    if self.frame == nil or type(self.model.clickHandler) ~= 'function' then
        return
    end

    local clickTrigger = CreateTrigger()
    TriggerAddAction(clickTrigger, function ()
        self.model.clickHandler()
    end)
    BlzTriggerRegisterFrameEvent(clickTrigger, self.frame, FRAMEEVENT_CONTROL_CLICK)
end

__EUI_SCOPED_MODULES['src.components.Component'] = Component
end

-- ModuleName: "src.components.Button"
do
local Component = __EUI_SCOPED_MODULES['src.components.Component']
local EUI = __EUI_SCOPED_MODULES['src.eui']
local proto = __EUI_SCOPED_MODULES['src.helpers.proto']

local Button = proto.Inherit(Component)

local ButtonPresets = {
    frameTemplate = 'ReplayButton',
    size = { 0.015, 0.04 },
    position = EUI.Position.ZERO,
    text = 'My Button',
    stick = EUI.Origin.CENTER,
    origin = EUI.Origin.CENTER
}

function Button:New(config)
    local button = proto.Inherit(Button)
    button:defineModel(ButtonPresets)
    button:applyConfig(config)
    return button
end

__EUI_SCOPED_MODULES['src.components.Button'] = Button
end

-- ModuleName: "main"
do
EUI = __EUI_SCOPED_MODULES['src.eui']
MapHooks = __EUI_SCOPED_MODULES['src.helpers.mapHooks']
Button = __EUI_SCOPED_MODULES['src.components.Button']

EUI.Create = function (type, config)
    local upperType = type:upper()
    if upperType == EUI.Component.BUTTON then
        return Button.New(config)
    end
end

EUI.CreateButton = function (config)
    return Button.New(config)
end

EUI.Append = function (instance, parent)
    instance:mount(parent)
    return instance;
end

EUI.Ready = function (readyHandler)
    if EUI.IsReady == true then
        readyHandler()
        return
    end

    table.insert(EUI._ReadyPromise, readyHandler)
end

MapHooks.OnInitialization(function ()
    EUI.IsReady = true
    EUI.Frame.MAIN = BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0)

    for _, handler in ipairs(EUI._ReadyPromise) do handler() end
    EUI._ReadyPromise = {}
end)

__EUI_SCOPED_MODULES['main'] = EUI
end

EUI = __EUI_SCOPED_MODULES['main']
