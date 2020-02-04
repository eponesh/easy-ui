EUI = require('src.eui')
MapHooks = require('src.helpers.mapHooks')
Button = require('src.components.Button')

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

return EUI
