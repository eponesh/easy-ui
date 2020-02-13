local EUI = require('src.eui')
local proto = require('src.helpers.proto')
local DeepClone = require('src.helpers.deepClone')
local makeProxy = require('src.helpers.makeProxy')
local QuestTask = require('src.quests.QuestTask')

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

return {
    Class = Quest,
    Presets = QuestPresets
}
