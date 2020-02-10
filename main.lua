EUI = require('src.eui')
MapHooks = require('src.helpers.mapHooks')
Component = require('src.components.Component')
Button = require('src.components.Button')
Icon = require('src.components.Icon')

EUI.CreateButton = function (config)
    return Button.New(config)
end

EUI.CreateIcon = function (config)
    return Icon.New(config)
end

EUI.Create = function (type, config)
    local upperType = type:upper()
    if upperType == EUI.Component.BUTTON then
        return EUI.CreateButton(config)
    elseif upperType == EUI.Component.ICON then
        return EUI.CreateIcon(config)
    end
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
    EUI.GameFrame = Component.New()
    EUI.GameFrame.frame = EUI.Frame.MAIN

    for _, handler in ipairs(EUI._ReadyPromise) do handler() end
    EUI._ReadyPromise = {}
end)

return EUI
