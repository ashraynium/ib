local AnswerService = {}
local function normalise(value) return string.lower(tostring(value or "")):gsub("^%s+",""):gsub("%s+$","") end
function AnswerService.Check(question, answer)
	local qtype = question.QuestionType
	local text = normalise(answer)
	local correct = false
	local expected = question.Answer
	if qtype == "MCQ" or (qtype == "Scenario" and question.Options) then
		correct = text == string.lower(tostring(expected)) or text == normalise((question.Options or {})[({A=1,B=2,C=3,D=4})[tostring(expected)] or 0])
	elseif qtype == "Calculation" then
		local numeric = tonumber(answer)
		correct = numeric ~= nil and math.abs(numeric - tonumber(expected)) <= (question.Tolerance or 0)
	else
		local hits = 0
		for _, keyword in ipairs(question.AcceptedKeywords or {}) do if string.find(text, normalise(keyword), 1, true) then hits += 1 end end
		correct = hits >= math.max(1, math.ceil(#(question.AcceptedKeywords or {}) * 0.35))
	end
	return {
		Correct=correct, Explanation=question.Explanation, CommonMistake=question.CommonMistake,
		Markscheme=question.Markscheme, ExpectedKeywords=question.AcceptedKeywords, XP=correct and question.XP or 0,
		Damage=correct and question.Damage or 0,
	}
end
return AnswerService
