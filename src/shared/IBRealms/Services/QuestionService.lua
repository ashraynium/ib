local QuestionBank = require(script.Parent.Parent.Data.QuestionBank)

local QuestionService = {}
QuestionService._questions = nil

local function contains(list, value)
	if not list then
		return false
	end
	for _, item in ipairs(list) do
		if item == value then
			return true
		end
	end
	return false
end

local function hasAnyTag(question, requestedTags)
	if not requestedTags or #requestedTags == 0 then
		return true
	end
	for _, requested in ipairs(requestedTags) do
		if contains(question.tags, requested) then
			return true
		end
	end
	return false
end

function QuestionService.GetAllQuestions()
	if QuestionService._questions then
		return QuestionService._questions
	end

	local combined = {}
	for _, packModule in ipairs(QuestionBank) do
		local ok, pack = pcall(require, packModule)
		if ok then
			for _, question in ipairs(pack) do
				table.insert(combined, question)
			end
		else
			warn("Failed to load question pack", packModule:GetFullName(), pack)
		end
	end
	QuestionService._questions = combined
	return combined
end

function QuestionService.MatchesFilter(question, filter)
	filter = filter or {}
	if filter.subjectBase and question.subjectBase ~= filter.subjectBase then
		return false
	end
	if filter.subjectId and not contains(question.subjectIds, filter.subjectId) then
		return false
	end
	if filter.topicId and question.topicId ~= filter.topicId then
		return false
	end
	if filter.commandTerm and question.commandTerm ~= filter.commandTerm then
		return false
	end
	if filter.minDifficulty and question.difficulty < filter.minDifficulty then
		return false
	end
	if filter.maxDifficulty and question.difficulty > filter.maxDifficulty then
		return false
	end
	if filter.tags and not hasAnyTag(question, filter.tags) then
		return false
	end
	if filter.questId and question.questId and question.questId ~= filter.questId then
		return false
	end
	return true
end

function QuestionService.SelectQuestions(filter, count)
	local matches = {}
	for _, question in ipairs(QuestionService.GetAllQuestions()) do
		if QuestionService.MatchesFilter(question, filter) then
			table.insert(matches, question)
		end
	end
	table.sort(matches, function(a, b)
		if a.difficulty == b.difficulty then
			return a.id < b.id
		end
		return a.difficulty < b.difficulty
	end)

	local selected = {}
	local limit = math.min(count or #matches, #matches)
	for index = 1, limit do
		table.insert(selected, matches[index])
	end
	return selected
end

function QuestionService.PublicQuestion(question)
	local copy = {}
	for key, value in pairs(question) do
		if key ~= "answer" and key ~= "acceptedAnswers" and key ~= "acceptedKeywords" then
			copy[key] = value
		end
	end
	return copy
end

function QuestionService.CheckAnswer(question, response)
	if not question then
		return false, "No question was active."
	end

	if question.type == "multiple_choice" then
		local numeric = tonumber(response)
		local correct = numeric == question.answer
		return correct, correct and "Correct choice." or "That option does not match the concept being tested."
	end

	local lower = string.lower(tostring(response or ""))
	local hits = 0
	local needed = math.min(2, #(question.acceptedKeywords or {}))
	if needed == 0 then
		needed = 1
	end
	for _, keyword in ipairs(question.acceptedKeywords or {}) do
		if string.find(lower, string.lower(keyword), 1, true) then
			hits += 1
		end
	end
	return hits >= needed, string.format("Matched %d keyword(s); expected ideas include: %s", hits, table.concat(question.acceptedKeywords or {}, ", "))
end

return QuestionService
