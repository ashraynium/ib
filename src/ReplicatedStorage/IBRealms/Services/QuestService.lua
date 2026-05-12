local ReplicatedStorage = game:GetService("ReplicatedStorage")
local IBRealms = ReplicatedStorage:WaitForChild("IBRealms")
local QuestData = require(IBRealms.Data.QuestData)
local SubjectData = require(IBRealms.Data.SubjectData)

local QuestService = {}
function QuestService.GetQuest(id) return QuestData[id] end
function QuestService.GetIntroQuestForSubject(subjectId)
	local subject = SubjectData[subjectId]
	if not subject then return nil end
	if subject.Base == "CS" then return QuestData.CS_BOOT end
	for _, quest in pairs(QuestData) do
		if quest.SubjectBase == subject.Base then return quest end
	end
end
function QuestService.GetRecommendedQuest(subjectId, completed)
	local subject = SubjectData[subjectId]
	if not subject then return nil end
	if subject.Base == "CS" then
		if not completed.CS_BOOT then return QuestData.CS_BOOT end
		if not completed.CS_CPU_CHAIN then return QuestData.CS_CPU_CHAIN end
		return QuestData.CS_BROKEN_PROCESSOR
	end
	return QuestService.GetIntroQuestForSubject(subjectId)
end
return QuestService
