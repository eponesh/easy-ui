local Presets = require('src.presets.components')
local proto = require('src.helpers.proto')
local fp = require('src.helpers.framePoints')
local DeepClone = require('src.helpers.deepClone')

local Component = proto.NewClass()

function Component.New(config)
    local component = proto.Inherit(Component)
    component:defineModel(Presets.Component)
    component:applyConfig(config)
    return component
end

function Component:defineModel(preset)
    self.model = getmetatable(self).priv

    for k, v in pairs(DeepClone(preset)) do self[k] = v end
    return self
end

function Component:applyConfig(config)
    if config == nil then return end
    for k, v in pairs(config) do self[k] = v end
    return self;
end

function Component:updateText()
    if self.frame ~= nil then
        BlzFrameSetText(self.frame, self.text)
    end
    return self;
end

function Component:updatePosition()
    if self.frame ~= nil then
        BlzFrameSetPoint(
            self.frame,
            self.origin,
            self.parent,
            self.stickTo,
            self.x,
            self.y
        )
    end
    return self;
end

function Component:updateSize()
    if self.frame ~= nil then
        BlzFrameSetSize(self.frame, self.width, self.height)
    end
    return self;
end

function Component:updateTexture()
    if self.frame ~= nil then
        BlzFrameSetTexture(self.frame, self.texture, 0, true)
    end
    return self;
end

function Component:updateIcon()
    if self.childFrames ~= nil and self.childFrames.icon ~= nil then
        BlzFrameSetTexture(self.childFrames.icon, self.iconPath, 0, true)
    end
    return self;
end

function Component.get:text()
    return self.model.text
end
function Component.set:text(text)
    self.model.text = text
    self:updateText()
    return text
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

function Component:mount(parent)
    self.frame = BlzCreateFrame(self.frameTemplate, parent, 0, 0)
    self.parent = parent

    if self._childFrames ~= nil then
        self.childFrames = {}
        for name, template in pairs(self._childFrames) do
            self.childFrames[name] = BlzGetFrameByName(template, 0)
        end
    end

    self:updatePosition()
    self:updateSize()
    self:updateText()
    self:updateTexture()
    self:updateIcon()
    self:registerClick()

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
    return self.frame ~= nil and self.parent ~= nil
end

function Component:AppendChild(child)
    child:mount(self.frame)
end

function Component:RemoveChild(child)
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

return Component
