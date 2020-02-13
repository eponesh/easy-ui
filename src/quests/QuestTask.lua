local proto = require('src.helpers.proto')
local DeepClone = require('src.helpers.deepClone')
local makeProxy = require('src.helpers.makeProxy')

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

return {
    Class = QuestTask,
    Presets = QuestTaskPresets
}
