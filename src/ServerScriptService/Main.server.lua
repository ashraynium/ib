local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local IBRealms = ReplicatedStorage:WaitForChild("IBRealms")
local RemotesFolder = IBRealms:WaitForChild("Remotes")
local ProgressService = require(IBRealms.Services.ProgressService)
local QuestService = require(IBRealms.Services.QuestService)
local QuestionService = require(IBRealms.Services.QuestionService)
local AnswerService = require(IBRealms.Services.AnswerService)
local Subjects = require(IBRealms.Data.SubjectData)
local Config = require(IBRealms.Data.GameConfig)

local function remoteEvent(name)
	local r = RemotesFolder:FindFirstChild(name) or Instance.new("RemoteEvent")
	r.Name = name
	r.Parent = RemotesFolder
	return r
end
local function remoteFunction(name)
	local r = RemotesFolder:FindFirstChild(name) or Instance.new("RemoteFunction")
	r.Name = name
	r.Parent = RemotesFolder
	return r
end

local ProfileUpdated = remoteEvent("ProfileUpdated")
local BattleUpdated = remoteEvent("BattleUpdated")
local RequestProfile = remoteFunction("RequestProfile")
local SetSubjects = remoteFunction("SetSubjects")
local SetActiveSubject = remoteFunction("SetActiveSubject")
local GetSubjectData = remoteFunction("GetSubjectData")
local StartQuest = remoteFunction("StartQuest")
local SubmitAnswer = remoteFunction("SubmitAnswer")
local TeleportTo = remoteEvent("TeleportTo")

local questStates = {}

local function sendProfile(player)
	ProfileUpdated:FireClient(player, ProgressService.GetSummary(player))
end

local function teleport(player, cf)
	local char = player.Character
	if char and char:FindFirstChild("HumanoidRootPart") then char.HumanoidRootPart.CFrame = cf end
end

Players.PlayerAdded:Connect(function(player)
	ProgressService.GetProfile(player)
	player.CharacterAdded:Connect(function()
		task.wait(0.25)
		teleport(player, Config.HubSpawnCFrame)
		sendProfile(player)
	end)
end)
Players.PlayerRemoving:Connect(function(player)
	ProgressService.RemoveProfile(player)
	questStates[player.UserId] = nil
end)

RequestProfile.OnServerInvoke = function(player)
	return ProgressService.GetSummary(player)
end

SetSubjects.OnServerInvoke = function(player, selected, mainRealm)
	local summary = ProgressService.SetSubjects(player, selected, mainRealm)
	sendProfile(player)
	return summary
end

SetActiveSubject.OnServerInvoke = function(player, subjectId)
	local summary = ProgressService.SetActiveSubject(player, subjectId)
	sendProfile(player)
	return summary
end

GetSubjectData.OnServerInvoke = function(_, subjectId)
	if subjectId then return Subjects[subjectId] end
	return Subjects
end

StartQuest.OnServerInvoke = function(player, subjectId, questId)
	local profile = ProgressService.GetProfile(player)
	local subject = Subjects[subjectId or profile.ActiveSubject]
	if not subject then return {Error="Choose a subject first."} end
	local quest = questId and QuestService.GetQuest(questId) or QuestService.GetRecommendedQuest(subject.Id, profile.CompletedQuests)
	if not quest then return {Error="No quest found."} end
	local firstQuestion = quest.QuestionIds[1]
	questStates[player.UserId] = {QuestId=quest.Id, SubjectId=subject.Id, Index=1, Correct=0, EnemyHP=quest.Enemy.MaxHP, Focus=Config.StartingFocus, Complete=false}
	return {Quest=quest, State=questStates[player.UserId], Question=QuestionService.GetClientQuestion(firstQuestion)}
end

SubmitAnswer.OnServerInvoke = function(player, answer)
	local state = questStates[player.UserId]
	if not state or state.Complete then return {Error="No active quest."} end
	local quest = QuestService.GetQuest(state.QuestId)
	local qid = quest.QuestionIds[state.Index]
	local question = QuestionService.GetQuestion(qid)
	local feedback = AnswerService.Check(question, answer)
	ProgressService.RecordAnswer(player, question, feedback.Correct)
	if feedback.Correct then
		state.Correct += 1
		state.EnemyHP = math.max(0, state.EnemyHP - feedback.Damage)
	else
		state.Focus = math.max(0, state.Focus - 18)
	end
	local complete = state.Correct >= (quest.RequiredCorrect or Config.QuestCorrectToComplete) or state.EnemyHP <= 0
	local failed = state.Focus <= 0
	local rewardsSummary = nil
	if complete then
		state.Complete = true
		rewardsSummary = ProgressService.ApplyRewards(player, state.SubjectId, quest)
		sendProfile(player)
	elseif not failed then
		state.Index = (state.Index % #quest.QuestionIds) + 1
	end
	local nextQuestion = (not complete and not failed) and QuestionService.GetClientQuestion(quest.QuestionIds[state.Index]) or nil
	local result = {Feedback=feedback, State=state, Quest=quest, NextQuestion=nextQuestion, Complete=complete, Failed=failed, Profile=rewardsSummary or ProgressService.GetSummary(player)}
	BattleUpdated:FireClient(player, result)
	return result
end

TeleportTo.OnServerEvent:Connect(function(player, target, subjectId)
	if target == "Hub" then
		teleport(player, Config.HubSpawnCFrame)
	elseif target == "Subject" and subjectId and Subjects[subjectId] then
		ProgressService.SetActiveSubject(player, subjectId)
		teleport(player, Subjects[subjectId].PreviewCFrame)
		sendProfile(player)
	end
end)
