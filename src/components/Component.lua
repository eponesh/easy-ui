local EUI = require('src.eui')
local proto = require('src.helpers.proto')
local fp = require('src.helpers.framePoints')
local DeepClone = require('src.helpers.deepClone')

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

return Component
