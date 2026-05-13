local DailyQuestData = require(script.Parent.Parent.Data.DailyQuestData)

local DailyQuestService = {}

function DailyQuestService.GetDailyTemplates()
	return DailyQuestData.Templates
end

function DailyQuestService.BuildDailySet(profile)
	local set = {}
	for index, template in ipairs(DailyQuestData.Templates) do
		local copy = table.clone(template)
		copy.progress = 0
		copy.goal = index == 2 and 2 or 1
		copy.completed = false
		copy.profileHint = profile and #(profile.selectedSubjects or {}) == 0 and "Choose subjects first." or "Ready."
		table.insert(set, copy)
	end
	return set
end

return DailyQuestService
