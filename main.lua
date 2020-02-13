EUI = require('src.eui')
MapHooks = require('src.helpers.mapHooks')
Component = require('src.components.Component')
Button = require('src.components.Button')
Icon = require('src.components.Icon')
Text = require('src.components.Text')
Tooltip = require('src.components.Tooltip')
Quest = require('src.quests.Quest')
Languages = require('src.languages.languages')

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

return EUI
