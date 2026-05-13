local ReplicatedStorage = game:GetService("ReplicatedStorage")

local IBRealms = ReplicatedStorage:WaitForChild("IBRealms")
local QuestData = require(IBRealms.Data.QuestData)
local QuestionService = require(IBRealms.Services.QuestionService)
local GameConfig = require(IBRealms.Data.GameConfig)
local ProgressService = require(script.Parent.ProgressService)

local QuestService = {}
local sessions = {}

local function publicSession(session)
	local question = session.questions[session.index]
	return {
		quest = session.quest,
		enemyHP = session.enemyHP,
		maxEnemyHP = session.maxEnemyHP,
		focus = session.focus,
		questionIndex = session.index,
		questionTotal = #session.questions,
		question = question and QuestionService.PublicQuestion(question) or nil,
		complete = session.complete == true,
	}
end

function QuestService.StartQuest(player, questId)
	local quest = QuestData.GetQuest(questId)
	if not quest then
		return nil, "Unknown quest."
	end
	local profile = ProgressService.GetProfile(player)
	if not profile.unlockedQuests[quest.id] then
		profile.unlockedQuests[quest.id] = true -- Full campaign scaffold allows direct route launch while preserving unlock data.
	end
	local questions = QuestionService.SelectQuestions(quest.questionFilter, GameConfig.QuestQuestionLimit)
	if #questions == 0 then
		return nil, "No questions matched this quest filter."
	end
	sessions[player] = {
		quest = quest,
		questions = questions,
		index = 1,
		enemyHP = quest.enemyHP,
		maxEnemyHP = quest.enemyHP,
		focus = quest.playerFocus or GameConfig.StartingFocus,
		correct = 0,
		complete = false,
	}
	profile.activeQuest = quest.id
	return publicSession(sessions[player])
end

function QuestService.Answer(player, response)
	local session = sessions[player]
	if not session or session.complete then
		return nil, "No active quest session."
	end
	local question = session.questions[session.index]
	local correct, checkMessage = QuestionService.CheckAnswer(question, response)
	ProgressService.RecordAnswer(player, question, correct)
	if correct then
		session.correct += 1
		session.enemyHP = math.max(0, session.enemyHP - (question.damage or 25))
	else
		session.focus = math.max(0, session.focus - GameConfig.WrongAnswerFocusLoss)
	end

	local feedback = {
		correct = correct,
		message = checkMessage,
		explanation = question.explanation,
		commonMistake = question.commonMistake,
		markscheme = question.markscheme,
		xp = correct and (question.xp or 0) or 0,
		damage = correct and (question.damage or 0) or 0,
		weaknessLogged = not correct,
	}

	if session.enemyHP <= 0 or session.index >= #session.questions or session.focus <= 0 then
		session.complete = session.enemyHP <= 0 or session.correct >= math.ceil(#session.questions * 0.6)
		local reward = nil
		if session.complete then
			local profile, firstTime = ProgressService.ApplyQuestReward(player, session.quest)
			reward = {
				firstTime = firstTime,
				xp = firstTime and session.quest.rewardXP or 0,
				coins = firstTime and session.quest.rewardCoins or 0,
				moveUnlock = firstTime and session.quest.moveUnlock or nil,
				badgeUnlock = firstTime and session.quest.badgeUnlock or nil,
				tokenUnlock = firstTime and session.quest.tokenUnlock or nil,
				profile = profile,
			}
		end
		return { session = publicSession(session), feedback = feedback, reward = reward }
	end

	session.index += 1
	return { session = publicSession(session), feedback = feedback, reward = nil }
end

function QuestService.Clear(player)
	sessions[player] = nil
end

return QuestService
