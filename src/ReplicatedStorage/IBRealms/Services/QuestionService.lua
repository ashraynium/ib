local ReplicatedStorage = game:GetService("ReplicatedStorage")
local IBRealms = ReplicatedStorage:WaitForChild("IBRealms")
local QuestionBank = require(IBRealms.Data.QuestionBank)

local QuestionService = {}
function QuestionService.GetQuestion(id) return QuestionBank[id] end
function QuestionService.GetClientQuestion(id)
	local q = QuestionBank[id]
	if not q then return nil end
	local copy = {}
	for k, v in pairs(q) do copy[k] = v end
	copy.Answer = nil; copy.AcceptedKeywords = nil; copy.Tolerance = nil
	return copy
end
function QuestionService.GetBySubjectBase(base)
	local out = {}
	for _, q in pairs(QuestionBank) do if q.SubjectBase == base then table.insert(out, q) end end
	return out
end
return QuestionService
