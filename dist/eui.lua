--[[
Easy UI. Build v0.0.5
@Author Sergey Eponeshnikov (https://github.com/eponesh)
]]

__EUI_SCOPED_MODULES = {}

-- ModuleName: "src.helpers.deepClone"
do
-- Copy Table (http://lua-users.org/wiki/CopyTable)
local function deepClone(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepClone(orig_key)] = deepClone(orig_value)
        end
        setmetatable(copy, deepClone(getmetatable(orig)))
    else
        copy = orig
    end
    return copy
end

__EUI_SCOPED_MODULES['src.helpers.deepClone'] = deepClone
end

-- ModuleName: "src.helpers.merge"
do
-- Merge tables
local function merge(...)
    local combinedTable = {}
    local arg = {...}

    for k, v in pairs(arg) do
        if type(v) == 'table' then
            for tk, tv in pairs(v) do
                combinedTable[tk] = tv
            end
        end
    end

    return combinedTable
end

__EUI_SCOPED_MODULES['src.helpers.merge'] = merge
end

-- ModuleName: "src.eui"
do
local deepClone = __EUI_SCOPED_MODULES['src.helpers.deepClone']
local merge = __EUI_SCOPED_MODULES['src.helpers.merge']

local EUI = {
    CloneDeep = deepClone,
    Merge = merge,
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
    TextAlign = {
        MIDDLE = TEXT_JUSTIFY_MIDDLE,
        TOP = TEXT_JUSTIFY_TOP,
        BOTTOM = TEXT_JUSTIFY_BOTTOM,
        LEFT = TEXT_JUSTIFY_LEFT,
        RIGHT = TEXT_JUSTIFY_RIGHT,
        CENTER = TEXT_JUSTIFY_CENTER,
    },
    Position = {
        ZERO = { 0, 0 }
    },
    Frame = {
        MAIN = nil
    },
    Component = {
        BUTTON = 'BUTTON',
        ICON = 'ICON',
        TEXT = 'TEXT',
        TOOLTIP = 'TOOLTIP'
    },
    Modules = {
        QUEST = 'QUEST'
    },
    Size = {
        XSMALL = 'XSMALL',
        SMALL = 'SMALL',
        MEDIUM = 'MEDIUM',
        LARGE = 'LARGE',
        XLARGE = 'XLARGE'
    },
    Language = 'EN',
    Languages = {
        RUSSIAN = 'RU',
        ENGLISH = 'EN',
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
    local class = {
        get = {},
        set = {}
    }
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

-- ModuleName: "src.helpers.textAligns"
do
local EUI = __EUI_SCOPED_MODULES['src.eui']

-- Check existing text aligments by link
local function isValidLinkTextAlign(textAlign)
    return textAlign == EUI.TextAlign.MIDDLE
        or textAlign == EUI.TextAlign.TOP
        or textAlign == EUI.TextAlign.BOTTOM
        or textAlign == EUI.TextAlign.LEFT
        or textAlign == EUI.TextAlign.RIGHT
        or textAlign == EUI.TextAlign.CENTER
end

-- Check existing text aligments by string and returns textalign
local function fromStringTextAlign(textAlign)
    if type(textAlign) == 'string' then
        local upperAlign = textAlign:upper()
        for alignName, align in pairs(EUI.TextAlign) do
            if upperAlign == alignName then
                return align
            end
        end
    end
end

-- Check both link and string text aligments
local function getConvertedTextAlign(textAlign)
    if isValidLinkTextAlign(textAlign) then
        return textAlign
    end

    local align = fromStringTextAlign(textAlign)

    if align ~= nil then
        return align
    end
end

__EUI_SCOPED_MODULES['src.helpers.textAligns'] = {
    getConvertedTextAlign = getConvertedTextAlign
}
end

-- ModuleName: "src.components.Component"
do
local EUI = __EUI_SCOPED_MODULES['src.eui']
local proto = __EUI_SCOPED_MODULES['src.helpers.proto']
local fp = __EUI_SCOPED_MODULES['src.helpers.framePoints']
local ta = __EUI_SCOPED_MODULES['src.helpers.textAligns']
local DeepClone = __EUI_SCOPED_MODULES['src.helpers.deepClone']

local componentId = 0
local Component = proto.NewClass()
local ComponentPresets = {
    frameTemplate = 'StandardLightBackdropTemplate',
    width = 0.1,
    height = 0.1,
    x = 0,
    y = 0,
    text = '',
    stickTo = EUI.Origin.CENTER,
    origin = EUI.Origin.CENTER,
    texture = '',
    scale = 1
}

function Component.New(config)
    local component = proto.Inherit(Component)
    component:defineModel(ComponentPresets)
    component:applyConfig(config)
    return component
end

function Component:defineModel(preset)
    componentId = componentId + 1
    self.id = componentId
    self.childrens = {}
    self.model = getmetatable(self).priv

    for k, v in pairs(DeepClone(preset)) do self[k] = v end
    return self
end

function Component:applyConfig(config)
    if config == nil then return end
    for k, v in pairs(config) do self[k] = v end
    return self
end

function Component:updateText()
    if self.frame ~= nil then
        BlzFrameSetText(self.frame, self.text)
    end
    return self
end

function Component:updateTextAlign()
    if self.frame ~= nil then
        BlzFrameSetTextAlignment(self.frame, self.textAlignVertical, self.textAlign)
    end
    return self
end

function Component:updatePosition()
    if self.frame ~= nil then
        BlzFrameSetPoint(
            self.frame,
            self.origin,
            self.relativeFrame,
            self.stickTo,
            self.x / self.scale,
            self.y / self.scale
        )
    end
    return self
end

function Component:updateSize()
    if self.frame ~= nil then
        BlzFrameSetSize(self.frame, self.width / self.scale, self.height / self.scale)
    end
    return self
end

function Component:updateTexture()
    if self.frame ~= nil then
        BlzFrameSetTexture(self.frame, self.texture, 0, true)
    end
    return self
end

function Component:updateIcon()
    if self.childFrames ~= nil and self.childFrames.icon ~= nil then
        BlzFrameSetTexture(self.childFrames.icon, self.iconPath, 0, true)
    end
    return self
end

function Component:updateScale()
    if self.frame ~= nil then
        BlzFrameSetScale(self.frame, self.scale)
        self:updateSize()
        self:updatePosition()
    end
    return self
end

function Component:updateTooltip()
    if self.frame ~= nil and self.tooltip ~= nil and self.tooltip.frame ~= nil then
        BlzFrameSetTooltip(self.frame, self.tooltip.frame)
    end
    return self
end

function Component.get:text()
    return self.model.text
end
function Component.set:text(text)
    self.model.text = text
    self:updateText()
    return text
end

function Component.get:textAlign()
    return self.model.textAlign
end
function Component.set:textAlign(textAlign)
    local align = ta.getConvertedTextAlign(textAlign)
    if align ~= nil then
        self.model.textAlign = align
        self:updateTextAlign()
    end
    return align
end

function Component.get:textAlignVertical()
    return self.model.textAlignVertical
end
function Component.set:textAlignVertical(textAlignVertical)
    local align = ta.getConvertedTextAlignVertical(textAlignVertical)
    if align ~= nil then
        self.model.textAlignVertical = align
        self:updateTextAlignVertical()
    end
    return align
end

function Component.get:width()
    return self.model.width
end
function Component.set:width(width)
    self.model.width = width
    self:updateSize()
    return width
end

function Component.get:height()
    return self.model.height
end
function Component.set:height(height)
    self.model.height = height
    self:updateSize()
    return height
end

function Component.get:size()
    return self.model.size
end
function Component.set:size(size)
    if self._sizeMap == nil then return end
    local sizeUpper = size:upper()
    for sizeName, sizeValue in pairs(self._sizeMap) do
        if sizeName == sizeUpper then
            self.model.width = sizeValue[1]
            self.model.height = sizeValue[2]
            self.model.size = sizeUpper
            self:updateSize()
            return size
        end
    end
end

function Component.get:fontSize()
    return self.model.fontSize
end
function Component.set:fontSize(fontSize)
    if self._fontSizeScaleMap == nil then return end
    local fontSizeUpper = fontSize:upper()
    for fontSizeName, fontSizeValue in pairs(self._fontSizeScaleMap) do
        if fontSizeName == fontSizeUpper then
            self.model.scale = fontSizeValue
            self.model.fontSize = fontSizeUpper
            self:updateScale()
            return fontSize
        end
    end
end

function Component.get:scale()
    return self.model.scale
end
function Component.set:scale(scale)
    self.model.scale = scale
    self:updateScale()
    return scale
end

function Component.get:x()
    return self.model.x
end
function Component.set:x(x)
    self.model.x = x
    self:updatePosition()
    return x
end

function Component.get:y()
    return self.model.y
end
function Component.set:y(y)
    self.model.y = y
    self:updatePosition()
    return y
end

function Component.get:origin()
    return self.model.origin
end
function Component.set:origin(framePoint)
    local point = fp.getConvertedFramePoint(framePoint)
    if point ~= nil then
        self.model.origin = point
        self:updatePosition()
    end
    return point
end

function Component.get:stickTo()
    return self.model.stickTo
end
function Component.set:stickTo(framePoint)
    local point = fp.getConvertedFramePoint(framePoint)
    if point ~= nil then
        self.model.stickTo = point
        self:updatePosition()
    end
    return point
end

function Component.get:texture()
    return self.model.texture
end
function Component.set:texture(texture)
    if texture ~= nil then
        self.model.texture = texture
        self:updateTexture()
    end
    return texture
end

function Component.get:iconPath()
    return self.model.iconPath
end
function Component.set:iconPath(iconPath)
    if iconPath ~= nil then
        self.model.iconPath = iconPath
        self:updateIcon()
    end
    return iconPath
end

function Component.get:tooltip()
    return self.model.tooltip
end
function Component.set:tooltip(tooltip)
    if tooltip ~= nil then
        self.model.tooltip = tooltip

        tooltip.relativeComponent = self
        if self.frame ~= nil and tooltip.frame ~= nil then
            tooltip.relativeFrame = self
        end

        self:updateTooltip()
    end
    return tooltip
end

function Component:mount(parent)
    if parent == nil then return end

    -- For typed frames e.g. TEXT or BUTTON
    if self._type ~= nil then
        self.frame = BlzCreateFrameByType(
            self._type,
            self._type .. '_' .. self.id,
            parent,
            self.frameTemplate,
        0)
    else
        self.frame = BlzCreateFrame(self.frameTemplate, parent, 0, 0)
    end

    self.parent = parent

    -- Set relative frame to relativeComponent's frame or parent frame
    if self.relativeComponent ~= nil and self.relativeComponent.frame ~= nil then
        self.relativeFrame = self.relativeComponent.frame
    else
        self.relativeFrame = parent
    end

    -- Set tooltips relative frame as component frame (when component mounted later then tooltip)
    if self.tooltip ~= nil and self.tooltip.frame ~= nil and self.tooltip.relativeFrame ~= self.frame then
        self.tooltip.relativeFrame = self.frame
        self.tooltip:updatePosition()
    end

    -- Takes frames from template
    if self._childFrames ~= nil then
        self.childFrames = {}
        for name, template in pairs(self._childFrames) do
            self.childFrames[name] = BlzGetFrameByName(template, 0)
        end
    end

    -- Mount child frames
    for i, child in ipairs(self.childrens) do
        if child.isMounted == false then
            child:mount(self.frame)
        end
    end

    -- Render state
    self:updateScale()
        :updatePosition()
        :updateSize()
        :updateText()
        :updateTexture()
        :updateIcon()
        :updateTooltip()
        :registerClick()

    -- Callback on component mount
    if type(self.mounted) == 'function' then
        self:mounted()
    end
end

function Component:unmount()
    if self.frame ~= nil then
        BlzDestroyFrame(self.frame)
    end
    self.childFrames = {}
    self.frame = nil
    self.parent = nil
end

function Component.get:isMounted()
    return self.frame ~= nil
end

function Component:AppendChild(child)
    table.insert(self.childrens, child)
    child:mount(self.frame)
end

function Component:RemoveChild(child)
    local childPosition = 0
    for i, children in ipairs(self.childrens) do
        if children == child then childPosition = i end
    end
    table.remove(self.childrens, childPosition)
    child:unmount(self.frame)
end

function Component:Clone()
    return self.New(self.model)
end

function Component:OnClick(handler)
    if type(handler) == 'function' then
        self.onClick = handler
    end

    self:registerClick()
    return self
end

function Component:registerClick()
    if self.frame == nil or type(self.onClick) ~= 'function' then
        return
    end

    local clickTrigger = CreateTrigger()
    TriggerAddAction(clickTrigger, function ()
        self:onClick()
    end)
    BlzTriggerRegisterFrameEvent(clickTrigger, self.frame, FRAMEEVENT_CONTROL_CLICK)
end

__EUI_SCOPED_MODULES['src.components.Component'] = {
    Class = Component,
    Presets = ComponentPresets
}
end

-- ModuleName: "src.helpers.makeProxy"
do
-- Make proxy object with property support.
-- @version 3 - 20060921 (D.Manura)
local function makeProxy(class, priv, getters, setters, is_expose_private)
    setmetatable(priv, class)
    local fallback = is_expose_private and priv or class
    local index = getters and
        function(self, key)
            local func = getters[key]
            if func then return func(self) else return fallback[key] end
        end
        or fallback
    local newindex = setters and
        function(self, key, value)
            local func = setters[key]
            if func then func(self, value)
            else rawset(self, key, value) end
        end
        or fallback
    local proxy_mt = {
        __newindex = newindex,
        __index = index,
        priv = priv
    }
    local self = setmetatable({}, proxy_mt)
    return self
end

__EUI_SCOPED_MODULES['src.helpers.makeProxy'] = makeProxy
end

-- ModuleName: "src.components.Button"
do
local Component = __EUI_SCOPED_MODULES['src.components.Component']
local Merge = __EUI_SCOPED_MODULES['src.helpers.merge']
local makeProxy = __EUI_SCOPED_MODULES['src.helpers.makeProxy']

local Button = makeProxy(Component.Class, {}, Component.Class.get, Component.Class.set)
local ButtonPresets = Merge(Component.Presets, {
    frameTemplate = 'ReplayButton',
    width = 0.015,
    height = 0.04,
    text = 'My Button',
    _sizeMap = {
        XSMALL = { 0.1, 0.02 },
        SMALL = { 0.14, 0.03 },
        MEDIUM = { 0.18, 0.04 },
        LARGE = { 0.22, 0.05 },
        XLARGE = { 0.26, 0.06 }
    }
})

function Button.New(config)
    local button = makeProxy(Button, {}, Button.get, Button.set)
    button:defineModel(ButtonPresets)
    button:applyConfig(config)
    return button
end

__EUI_SCOPED_MODULES['src.components.Button'] = {
    Class = Button,
    Presets = ButtonPresets
}
end

-- ModuleName: "src.components.Icon"
do
local Component = __EUI_SCOPED_MODULES['src.components.Component']
local Merge = __EUI_SCOPED_MODULES['src.helpers.merge']
local makeProxy = __EUI_SCOPED_MODULES['src.helpers.makeProxy']

local Icon = makeProxy(Component.Class, {}, Component.Class.get, Component.Class.set)
local IconPresets = Merge(Component.Presets, {
    frameTemplate = 'ScoreScreenBottomButtonTemplate',
    width = 0.08,
    height = 0.08,
    iconPath = 'ReplaceableTextures/CommandButtons/BTNSelectHeroOn',
    _childFrames = {
        icon = 'ScoreScreenButtonBackdrop'
    },
    _sizeMap = {
        XSMALL = { 0.02, 0.02 },
        SMALL = { 0.04, 0.04 },
        MEDIUM = { 0.08, 0.08 },
        LARGE = { 0.12, 0.12 },
        XLARGE = { 0.16, 0.16 }
    }
})

function Icon.New(config)
    local icon = makeProxy(Icon, {}, Icon.get, Icon.set)
    icon:defineModel(IconPresets)
    icon:applyConfig(config)
    return icon
end

__EUI_SCOPED_MODULES['src.components.Icon'] = {
    Class = Icon,
    Presets = IconPresets
}
end

-- ModuleName: "src.components.Text"
do
local Component = __EUI_SCOPED_MODULES['src.components.Component']
local Merge = __EUI_SCOPED_MODULES['src.helpers.merge']
local makeProxy = __EUI_SCOPED_MODULES['src.helpers.makeProxy']
local EUI = __EUI_SCOPED_MODULES['src.eui']

local Text = makeProxy(Component.Class, {}, Component.Class.get, Component.Class.set)
local TextPresets = Merge(Component.Presets, {
    frameTemplate = 'StandardValueTextTemplate',
    width = 0.18,
    height = 0.04,
    _type = EUI.Component.TEXT,
    _sizeMap = {
        XSMALL = { 0.1, 0.02 },
        SMALL = { 0.14, 0.03 },
        MEDIUM = { 0.18, 0.04 },
        LARGE = { 0.22, 0.05 },
        XLARGE = { 0.26, 0.06 }
    },
    _fontSizeScaleMap = {
        XSMALL = 0.6,
        SMALL = 0.8,
        MEDIUM = 1,
        LARGE = 1.3,
        XLARGE = 1.7
    }
})

function Text.New(config)
    local text = makeProxy(Text, {}, Text.get, Text.set)
    text:defineModel(TextPresets)
    text:applyConfig(config)
    return text
end

__EUI_SCOPED_MODULES['src.components.Text'] = {
    Class = Text,
    Presets = TextPresets
}
end

-- ModuleName: "src.components.Tooltip"
do
local Component = __EUI_SCOPED_MODULES['src.components.Component']
local Text = __EUI_SCOPED_MODULES['src.components.Text']
local Merge = __EUI_SCOPED_MODULES['src.helpers.merge']
local makeProxy = __EUI_SCOPED_MODULES['src.helpers.makeProxy']

local DEFAULT_PADDING = 0.03

local Tooltip = makeProxy(Component.Class, {}, Component.Class.get, Component.Class.set)
local TooltipPresets = Merge(Component.Presets, {
    frameTemplate = 'ListBoxWar3',
    width = 0.3,
    height = 0.15,
    _sizeMap = {
        XSMALL = { 0.1, 0.05 },
        SMALL = { 0.2, 0.1 },
        MEDIUM = { 0.3, 0.15 },
        LARGE = { 0.4, 0.2 },
        XLARGE = { 0.5, 0.25 }
    },
})

function Tooltip.New(config)
    local tooltip = makeProxy(Tooltip, {}, Tooltip.get, Tooltip.set)
    tooltip._sizeMap = TooltipPresets._sizeMap
    tooltip:defineModel(TooltipPresets)
    tooltip:applyConfig(config)
    tooltip:AppendChild(Text.Class.New({
        width = tooltip.width - 0.03,
        height = tooltip.height - 0.03,
    }))
    return tooltip
end

function Tooltip:updateSize()
    Component.Class.updateSize(self)

    if self.frame ~= nil and self.childrens[1] ~= nil then
        self.childrens[1].width = self.width - DEFAULT_PADDING
        self.childrens[1].height = self.height - DEFAULT_PADDING
    end

    return self
end

function Tooltip:updateText()
    if self.frame ~= nil and self.childrens[1] ~= nil then
        self.childrens[1].text = self.text
    end
    return self
end

__EUI_SCOPED_MODULES['src.components.Tooltip'] = {
    Class = Tooltip,
    Presets = TooltipPresets
}
end

-- ModuleName: "src.quests.QuestTask"
do
local proto = __EUI_SCOPED_MODULES['src.helpers.proto']
local DeepClone = __EUI_SCOPED_MODULES['src.helpers.deepClone']
local makeProxy = __EUI_SCOPED_MODULES['src.helpers.makeProxy']

local questTaskId = 0
local QuestTask = proto.NewClass()
local QuestTaskPresets = {
    key = '',
    description = '',
    completed = false,
}

function QuestTask.New(config)
    local questTask = makeProxy(QuestTask, {}, QuestTask.get, QuestTask.set)
    questTask:defineModel(QuestTaskPresets)
    questTask:applyConfig(config)
    return questTask
end

function QuestTask:defineModel(preset)
    questTaskId = questTaskId + 1
    self.id = questTaskId
    self.model = getmetatable(self).priv

    for k, v in pairs(DeepClone(preset)) do self[k] = v end
    return self
end

function QuestTask:applyConfig(config)
    if config == nil then return end
    for k, v in pairs(config) do self[k] = v end
    return self
end

function QuestTask:updateDescription()
    if self.questTask ~= nil then
        QuestItemSetDescription(self.questTask, self.description)
    end
    return self
end

function QuestTask:updateCompleted()
    if self.questTask ~= nil then
        QuestItemSetCompleted(self.questTask, self.completed)
    end
    return self
end

function QuestTask.get:description()
    return self.model.description
end
function QuestTask.set:description(description)
    self.model.description = description
    self:updateDescription()
    return description
end

function QuestTask.get:completed()
    return self.model.completed
end
function QuestTask.set:completed(completed)
    self.model.completed = completed
    self:updateCompleted()
    return completed
end

function QuestTask:ApplyQuest(quest)
    self.quest = quest
    self.questTask = QuestCreateItem(quest.quest)
    self:updateDescription()
        :updateCompleted()

    return self
end

function QuestTask:Complete()
    self.completed = true
    if self.quest ~= nil and self.quest.silent == false then
        self.quest:ShowUpdatedMessage():CheckComplete()
    end
    return self
end

__EUI_SCOPED_MODULES['src.quests.QuestTask'] = {
    Class = QuestTask,
    Presets = QuestTaskPresets
}
end

-- ModuleName: "src.quests.Quest"
do
local EUI = __EUI_SCOPED_MODULES['src.eui']
local proto = __EUI_SCOPED_MODULES['src.helpers.proto']
local DeepClone = __EUI_SCOPED_MODULES['src.helpers.deepClone']
local makeProxy = __EUI_SCOPED_MODULES['src.helpers.makeProxy']
local QuestTask = __EUI_SCOPED_MODULES['src.quests.QuestTask']

local questId = 0
local Quest = proto.NewClass()
local QuestPresets = {
    icon = 'ReplaceableTextures/CommandButtons/BTNSelectHeroOn',
    title = '',
    description = '',
    enabled = true,
    completed = false,
    required = false,
    discovered = false,
    failed = false,
    tasks = {},
    autocomplete = true,
    silent = false,
}

function Quest.New(config)
    local quest = makeProxy(Quest, {}, Quest.get, Quest.set)
    quest:defineModel(QuestPresets)
    quest:applyConfig(config)

    local tasks = quest.tasks
    quest.tasks = {}

    for _, task in ipairs(tasks) do
        quest:AddTask(task)
    end

    EUI.Ready(function () quest:Create() end)
    return quest
end

function Quest:defineModel(preset)
    questId = questId + 1
    self.id = questId
    self.model = getmetatable(self).priv

    for k, v in pairs(DeepClone(preset)) do self[k] = v end
    return self
end

function Quest:applyConfig(config)
    if config == nil then return end
    for k, v in pairs(config) do self[k] = v end
    return self
end

function Quest:updateTitle()
    if self.quest ~= nil then
        QuestSetTitle(self.quest, self.title)
    end
    return self
end

function Quest:updateDescription()
    if self.quest ~= nil then
        QuestSetDescription(self.quest, self.description)
    end
    return self
end

function Quest:updateIcon()
    if self.quest ~= nil then
        QuestSetIconPath(self.quest, self.icon)
    end
    return self
end

function Quest:updateRequired()
    if self.quest ~= nil then
        QuestSetRequired(self.quest, self.required)
    end
    return self
end

function Quest:updateEnabled()
    if self.quest ~= nil then
        QuestSetEnabled(self.quest, self.enabled)
    end
    return self
end

function Quest:updateDiscovered()
    if self.quest ~= nil then
        QuestSetDiscovered(self.quest, self.discovered)

        if self.silent == false and self.discovered == true then
            self:ShowDiscoveredMessage()
        end
    end
    return self
end

function Quest:updateCompleted()
    if self.quest ~= nil then
        QuestSetCompleted(self.quest, self.completed)

        if self.silent == false and self.completed == true then
            self:ShowCompletedMessage()
        end
    end
    return self
end

function Quest:updateFailed()
    if self.quest ~= nil then
        QuestSetFailed(self.quest, self.failed)

        if self.silent == false and self.failed == true then
            self:ShowFailedMessage()
        end
    end
    return self
end

function Quest.get:title()
    return self.model.title
end
function Quest.set:title(title)
    self.model.title = title
    self:updateTitle()
    return title
end

function Quest.get:description()
    return self.model.description
end
function Quest.set:description(description)
    self.model.description = description
    self:updateDescription()
    return description
end

function Quest.get:icon()
    return self.model.icon
end
function Quest.set:icon(icon)
    self.model.icon = icon
    self:updateIcon()
    return icon
end

function Quest.get:required()
    return self.model.required
end
function Quest.set:required(required)
    self.model.required = required
    self:updateRequired()
    return required
end

function Quest.get:completed()
    return self.model.completed
end
function Quest.set:completed(completed)
    if self.failed == true then return end
    self.model.completed = completed
    self:updateCompleted()
    return completed
end

function Quest.get:discovered()
    return self.model.discovered
end
function Quest.set:discovered(discovered)
    self.model.discovered = discovered
    self:updateDiscovered()
    return discovered
end

function Quest.get:failed()
    return self.model.failed
end
function Quest.set:failed(failed)
    if self.completed == true then return end
    self.model.failed = failed
    self:updateFailed()
    return failed
end

function Quest.get:enabled()
    return self.model.enabled
end
function Quest.set:enabled(enabled)
    self.model.enabled = enabled
    self:updateEnabled()
    return enabled
end

function Quest.get:questTypeText()
    if self.required == true then
        return EUI.StringTemplates.Quest.MAIN
    end
    return EUI.StringTemplates.Quest.OPTIONAL
end

function Quest.get:tasksMessage()
    local message = ''
    for _, task in ipairs(self.tasks) do
        if task.completed == true then
            message = message  .. '\n|cff808080— ' .. task.description .. ' (' .. EUI.StringTemplates.Quest.TASK_COMPLETED .. ')|r'
        else
            message = message  .. '\n— ' .. task.description
        end
    end
    return message
end

function Quest:Create()
    self.quest = CreateQuest()

    -- Render Tasks list
    for _, task in ipairs(self.tasks) do
        task:ApplyQuest(self)
    end

    -- Render Quest
    self:updateTitle()
        :updateDescription()
        :updateIcon()
        :updateEnabled()
        :updateRequired()
        :updateDiscovered()
        :updateCompleted()
        :updateFailed()

    return self
end

function Quest:Show()
    self.enabled = true
    return self
end

function Quest:Hide()
    self.enabled = false
    return self
end

function Quest:Flash()
    FlashQuestDialogButton()
    return self
end

function Quest:Destroy()
    DestroyQuest(self.quest)
    self.quest = nil
    return self
end

function Quest:GetTask(taskOrIdOrKey)
    local taskInstance = nil
    if type(taskOrIdOrKey) == 'number' or type(taskOrIdOrKey) == 'string' then
        for _, task in ipairs(self.tasks) do
            if task.id == taskOrIdOrKey or task.key == taskOrIdOrKey then
                taskInstance = task
            end
        end
    end

    if taskInstance == nil and taskOrIdOrKey then
        taskInstance = taskOrIdOrKey
    end

    return taskInstance
end

function Quest:AddTask(task)
    local taskInstance = nil
    if type(task) == 'string' then
        taskInstance = QuestTask.Class.New({ description = task })
    elseif type(task) == 'table' then
        taskInstance = QuestTask.Class.New(task)
    elseif task then
        taskInstance = task
    end

    if taskInstance == nil then
        return
    end

    table.insert(self.tasks, taskInstance)

    if self.quest ~= nil then
        taskInstance:ApplyQuest(self)
    end

    return taskInstance
end

function Quest:RemoveTask(taskOrIdOrKey)
    local task = self:GetTask(taskOrIdOrKey)
    if task ~= nil then
        table.remove(self.tasks, task)
    end
end

function Quest:CheckComplete()
    if self.completed == true or self.autocomplete == false then return end

    local completed = true
    for _, task in ipairs(self.tasks) do
        if task.completed == false then
            completed = false
            break
        end
    end

    if completed == true then
        self.completed = true
    end

    return self
end

function Quest:CompleteTask(taskOrIdOrKey)
    local task = self:GetTask(taskOrIdOrKey)
    if task ~= nil then
        task:Complete()
    end

    return self
end

function Quest:generateTitle(status)
    return '|cffffcc00' ..  self.questTypeText .. ' ' .. (status or '') .. '|r\n' .. self.title
end

function Quest:ShowUpdatedMessage()
    QuestMessageBJ(
        bj_FORCE_ALL_PLAYERS,
        bj_QUESTMESSAGE_UPDATED,
        self:generateTitle(EUI.StringTemplates.Quest.UPDATED) .. self.tasksMessage
    )
    return self
end

function Quest:ShowFailedMessage()
    QuestMessageBJ(
        bj_FORCE_ALL_PLAYERS,
        bj_QUESTMESSAGE_FAILED,
        self:generateTitle(EUI.StringTemplates.Quest.FAILED)
    )
    return self
end

function Quest:ShowCompletedMessage()
    QuestMessageBJ(
        bj_FORCE_ALL_PLAYERS,
        bj_QUESTMESSAGE_FAILED,
        self:generateTitle(EUI.StringTemplates.Quest.COMPLETED)
    )
    return self
end

function Quest:ShowDiscoveredMessage()
    QuestMessageBJ(
        bj_FORCE_ALL_PLAYERS,
        bj_QUESTMESSAGE_DISCOVERED,
        self:generateTitle() .. self.tasksMessage
    )
    return self
end

__EUI_SCOPED_MODULES['src.quests.Quest'] = {
    Class = Quest,
    Presets = QuestPresets
}
end

-- ModuleName: "src.languages.russian"
do
local RussianTemplates = {
    Quest = {
        MAIN = 'ОСНОВНАЯ ЗАДАЧА',
        OPTIONAL = 'ДОПОЛНИТЕЛЬНАЯ ЗАДАЧА',
        COMPLETED = 'ЗАВЕРШЕНА',
        FAILED = 'ПРОВАЛЕНА',
        UPDATED = 'ОБНОВЛЕНА',
        TASK_COMPLETED = 'Выполнено',
    }
}

__EUI_SCOPED_MODULES['src.languages.russian'] = RussianTemplates
end

-- ModuleName: "src.languages.english"
do
local EnglishTemplates = {
    Quest = {
        MAIN = 'MAIN QUEST',
        OPTIONAL = 'OPTIONAL QUEST',
        COMPLETED = 'COMPLETED',
        FAILED = 'FAILED',
        UPDATED = 'UPDATED',
        TASK_COMPLETED = 'Completed',
    }
}

__EUI_SCOPED_MODULES['src.languages.english'] = EnglishTemplates
end

-- ModuleName: "src.languages.languages"
do
local EUI = __EUI_SCOPED_MODULES['src.eui']
local Russian = __EUI_SCOPED_MODULES['src.languages.russian']
local English = __EUI_SCOPED_MODULES['src.languages.english']

__EUI_SCOPED_MODULES['src.languages.languages'] = {
    [EUI.Languages.RUSSIAN] = Russian,
    [EUI.Languages.ENGLISH] = English
}
end

-- ModuleName: "main"
do
EUI = __EUI_SCOPED_MODULES['src.eui']
MapHooks = __EUI_SCOPED_MODULES['src.helpers.mapHooks']
Component = __EUI_SCOPED_MODULES['src.components.Component']
Button = __EUI_SCOPED_MODULES['src.components.Button']
Icon = __EUI_SCOPED_MODULES['src.components.Icon']
Text = __EUI_SCOPED_MODULES['src.components.Text']
Tooltip = __EUI_SCOPED_MODULES['src.components.Tooltip']
Quest = __EUI_SCOPED_MODULES['src.quests.Quest']
Languages = __EUI_SCOPED_MODULES['src.languages.languages']

EUI.SetLanguage = function (language)
    local lang = language:upper()

    if Languages[lang] ~= nil then
        EUI.StringTemplates = Languages[lang]
        EUI.Language = lang
        return true
    end

    return false
end

EUI.CreateButton = function (config)
    return Button.Class.New(config)
end

EUI.CreateIcon = function (config)
    return Icon.Class.New(config)
end

EUI.CreateText = function (config)
    return Text.Class.New(config)
end

EUI.CreateTooltip = function (config)
    return Tooltip.Class.New(config)
end

EUI.CreateQuest = function (config)
    return Quest.Class.New(config)
end

EUI.Create = function (type, config)
    local upperType = type:upper()
    if upperType == EUI.Component.BUTTON then
        return EUI.CreateButton(config)
    elseif upperType == EUI.Component.ICON then
        return EUI.CreateIcon(config)
    elseif upperType == EUI.Component.TEXT then
        return EUI.CreateText(config)
    elseif upperType == EUI.Component.TOOLTIP then
        return EUI.CreateTooltip(config)
    elseif upperType == EUI.Modules.QUEST then
        return EUI.CreateQuest(config)
    end
end

EUI.Append = function (component, parent)
    component:mount(parent)
    return component
end

EUI.Ready = function (readyHandler)
    if EUI.IsReady == true then
        readyHandler()
        return
    end

    table.insert(EUI._ReadyPromise, readyHandler)
end

EUI.SetLanguage(EUI.Languages.ENGLISH)

MapHooks.OnInitialization(function ()
    EUI.IsReady = true
    EUI.Frame.MAIN = BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0)
    EUI.GameFrame = Component.Class.New()
    EUI.GameFrame.frame = EUI.Frame.MAIN

    for _, handler in ipairs(EUI._ReadyPromise) do handler() end
    EUI._ReadyPromise = {}
end)

__EUI_SCOPED_MODULES['main'] = EUI
end

EUI = __EUI_SCOPED_MODULES['main']
