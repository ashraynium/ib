local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Data = ReplicatedStorage:WaitForChild("IBRealms"):WaitForChild("Data")
local GameConfig = require(Data.GameConfig)
local SubjectData = require(Data.SubjectData)
local RankData = require(Data.RankData)

local ProgressService = {}
local profiles = {}

local function defaultProfile()
	return {
		onboardingComplete = false,
		selectedSubjects = {},
		mainSubject = nil,
		xp = 0,
		coins = 0,
		level = 1,
		overallRank = "Bronze",
		accuracy = 100,
		stats = { correct = 0, attempted = 0 },
		subjectProgress = {},
		completedQuests = {},
		unlockedQuests = { cs_boot_sector = true },
		mastery = {},
		mistakes = {},
		unlockedMoves = {},
		badges = {},
		tokens = {},
		activeQuest = nil,
		currentSubject = nil,
	}
end

local function arrayToSet(array)
	local set = {}
	for _, value in ipairs(array or {}) do
		set[value] = true
	end
	return set
end

local function setToSortedArray(set)
	local array = {}
	for value, enabled in pairs(set or {}) do
		if enabled then
			table.insert(array, value)
		end
	end
	table.sort(array)
	return array
end

function ProgressService.GetProfile(player)
	if not profiles[player] then
		profiles[player] = defaultProfile()
		if GameConfig.UseDataStores then
			warn("DataStores are enabled in config, but this build currently ships session storage scaffolding.")
		end
	end
	return profiles[player]
end

function ProgressService.GetPublicProfile(player)
	local profile = ProgressService.GetProfile(player)
	local copy = {}
	for key, value in pairs(profile) do
		copy[key] = value
	end
	return copy
end

function ProgressService.SetSubjects(player, subjectIds, mainSubject)
	local valid = {}
	for _, subjectId in ipairs(subjectIds or {}) do
		if SubjectData.GetSubject(subjectId) then
			valid[subjectId] = true
		end
	end
	local profile = ProgressService.GetProfile(player)
	profile.selectedSubjects = setToSortedArray(valid)
	if mainSubject and valid[mainSubject] then
		profile.mainSubject = mainSubject
	elseif not valid[profile.mainSubject] then
		profile.mainSubject = profile.selectedSubjects[1]
	end
	profile.onboardingComplete = #profile.selectedSubjects > 0
	for _, subjectId in ipairs(profile.selectedSubjects) do
		profile.subjectProgress[subjectId] = profile.subjectProgress[subjectId] or 0
		local subject = SubjectData.GetSubject(subjectId)
		if subject and subject.recommendedQuest then
			profile.unlockedQuests[subject.recommendedQuest] = true
		end
	end
	return ProgressService.GetPublicProfile(player)
end

function ProgressService.RecordAnswer(player, question, correct)
	local profile = ProgressService.GetProfile(player)
	profile.stats.attempted += 1
	if correct then
		profile.stats.correct += 1
	else
		local key = question.topicId .. ":" .. (question.subtopic or "general")
		profile.mistakes[key] = (profile.mistakes[key] or 0) + 1
	end
	profile.accuracy = math.floor((profile.stats.correct / math.max(profile.stats.attempted, 1)) * 100)

	local impact = question.masteryImpact or {}
	for masteryKey, amount in pairs(impact) do
		profile.mastery[masteryKey] = math.clamp((profile.mastery[masteryKey] or 0) + (correct and amount or -1), 0, 100)
	end
end

function ProgressService.ApplyQuestReward(player, quest)
	local profile = ProgressService.GetProfile(player)
	if profile.completedQuests[quest.id] then
		return profile, false
	end
	profile.completedQuests[quest.id] = true
	profile.xp += quest.rewardXP or 0
	profile.coins += quest.rewardCoins or 0
	profile.level = math.max(1, math.floor(profile.xp / 150) + 1)
	if quest.moveUnlock then
		profile.unlockedMoves[quest.moveUnlock] = true
	end
	if quest.badgeUnlock then
		profile.badges[quest.badgeUnlock] = true
	end
	if quest.tokenUnlock then
		profile.tokens[quest.tokenUnlock] = true
	end
	if quest.unlocksNextQuest then
		profile.unlockedQuests[quest.unlocksNextQuest] = true
	end

	local subjectIds = arrayToSet(profile.selectedSubjects)
	if quest.subjectId and subjectIds[quest.subjectId] then
		profile.subjectProgress[quest.subjectId] = math.clamp((profile.subjectProgress[quest.subjectId] or 0) + 8, 0, 100)
	else
		for _, subjectId in ipairs(profile.selectedSubjects) do
			local subject = SubjectData.GetSubject(subjectId)
			if subject and subject.base == quest.subjectBase then
				profile.subjectProgress[subjectId] = math.clamp((profile.subjectProgress[subjectId] or 0) + 8, 0, 100)
			end
		end
	end

	local total = 0
	for _, subjectId in ipairs(profile.selectedSubjects) do
		total += profile.subjectProgress[subjectId] or 0
	end
	local overallProgress = #profile.selectedSubjects > 0 and total / #profile.selectedSubjects or 0
	profile.overallRank = RankData.GetOverallRank(overallProgress)
	profile.activeQuest = nil
	return profile, true
end

function ProgressService.RemovePlayer(player)
	profiles[player] = nil
end

return ProgressService
