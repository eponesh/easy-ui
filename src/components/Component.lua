local EUI = require('src.eui')
local proto = require('src.helpers.proto')
local fp = require('src.helpers.framePoints')
local ta = require('src.helpers.textAligns')
local DeepClone = require('src.helpers.deepClone')

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

return {
    Class = Component,
    Presets = ComponentPresets
}
