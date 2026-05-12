local ReplicatedStorage = game:GetService("ReplicatedStorage")
local IBRealms = ReplicatedStorage:WaitForChild("IBRealms")
local GameConfig = require(IBRealms.Data.GameConfig)
local SubjectData = require(IBRealms.Data.SubjectData)
local MoveData = require(IBRealms.Data.MoveData)
local RankData = require(IBRealms.Data.RankData)

local ProgressService = {}
ProgressService.Profiles = {}

local function defaultProfile()
	return {
		SelectedSubjects = {}, MainRealm = nil, ActiveSubject = nil,
		XP = 0, Coins = 0, Level = 1, Badges = {}, Tokens = {},
		CompletedQuests = {}, CompletedTopics = {}, UnlockedMoves = {},
		QuestionAttempts = {}, CorrectAnswers = 0, TotalAnswers = 0,
		Mastery = {}, Mistakes = {}, SubjectProgress = {},
	}
end

local function rankForXP(xp)
	local rank = RankData.Overall[1].Name
	for _, item in ipairs(RankData.Overall) do if xp >= item.XP then rank = item.Name end end
	return rank
end

function ProgressService.GetProfile(player)
	if not ProgressService.Profiles[player.UserId] then ProgressService.Profiles[player.UserId] = defaultProfile() end
	return ProgressService.Profiles[player.UserId]
end

function ProgressService.RemoveProfile(player)
	if not GameConfig.UseDataStores then ProgressService.Profiles[player.UserId] = nil end
end

function ProgressService.GetSummary(player)
	local p = ProgressService.GetProfile(player)
	local accuracy = p.TotalAnswers > 0 and math.floor((p.CorrectAnswers / p.TotalAnswers) * 100 + 0.5) or 0
	local weak = ProgressService.GetWeakTopics(player)
	return {
		SelectedSubjects=p.SelectedSubjects, MainRealm=p.MainRealm, ActiveSubject=p.ActiveSubject,
		XP=p.XP, Coins=p.Coins, Level=math.floor(p.XP / GameConfig.XPPerLevel) + 1,
		Rank=rankForXP(p.XP), Accuracy=accuracy, WeakTopics=weak,
		SubjectProgress=p.SubjectProgress, CompletedQuests=p.CompletedQuests, UnlockedMoves=p.UnlockedMoves,
		Badges=p.Badges, Mastery=p.Mastery,
	}
end

function ProgressService.SetSubjects(player, selected, mainRealm)
	local p = ProgressService.GetProfile(player)
	p.SelectedSubjects = {}
	for _, subjectId in ipairs(selected or {}) do
		if SubjectData[subjectId] then
			table.insert(p.SelectedSubjects, subjectId)
			p.SubjectProgress[subjectId] = p.SubjectProgress[subjectId] or 0
			local starter = SubjectData[subjectId].StarterMove
			if starter and MoveData[starter] then p.UnlockedMoves[starter] = p.UnlockedMoves[starter] or false end
		end
	end
	p.MainRealm = mainRealm
	p.ActiveSubject = p.SelectedSubjects[1]
	return ProgressService.GetSummary(player)
end

function ProgressService.SetActiveSubject(player, subjectId)
	local p = ProgressService.GetProfile(player)
	if SubjectData[subjectId] then p.ActiveSubject = subjectId end
	return ProgressService.GetSummary(player)
end

function ProgressService.RecordAnswer(player, question, correct)
	local p = ProgressService.GetProfile(player)
	p.TotalAnswers += 1
	if correct then p.CorrectAnswers += 1 end
	p.QuestionAttempts[question.Id] = p.QuestionAttempts[question.Id] or {Attempts=0, Correct=0}
	p.QuestionAttempts[question.Id].Attempts += 1
	if correct then p.QuestionAttempts[question.Id].Correct += 1 else p.Mistakes[question.Id] = (p.Mistakes[question.Id] or 0) + 1 end
	for _, tag in ipairs(question.Tags or {}) do
		local m = p.Mastery[tag] or {Attempts=0, Correct=0, Score=0, Mistakes=0}
		m.Attempts += 1
		if correct then m.Correct += 1 else m.Mistakes += 1 end
		local accuracy = m.Correct / math.max(1, m.Attempts)
		local confidence = math.min(1, m.Attempts / 5)
		m.Score = math.floor(accuracy * confidence * 100 + 0.5)
		p.Mastery[tag] = m
	end
end

function ProgressService.ApplyRewards(player, subjectId, quest)
	local p = ProgressService.GetProfile(player)
	local rewards = quest.Rewards or {}
	p.XP += rewards.XP or 0
	p.Coins += rewards.Coins or 0
	p.CompletedQuests[quest.Id] = true
	if subjectId then p.SubjectProgress[subjectId] = math.min(100, (p.SubjectProgress[subjectId] or 0) + (rewards.Progress or 0)) end
	for _, moveId in ipairs(rewards.Moves or {}) do p.UnlockedMoves[moveId] = true end
	for _, badge in ipairs(rewards.Badges or {}) do p.Badges[badge] = true end
	return ProgressService.GetSummary(player)
end

function ProgressService.GetWeakTopics(player)
	local p = ProgressService.GetProfile(player)
	local weak = {}
	for tag, m in pairs(p.Mastery) do
		if m.Attempts >= 1 and (m.Score < 55 or m.Mistakes >= 2) then table.insert(weak, {Tag=tag, Score=m.Score, Mistakes=m.Mistakes}) end
	end
	table.sort(weak, function(a,b) return a.Score < b.Score end)
	return weak
end

return ProgressService
