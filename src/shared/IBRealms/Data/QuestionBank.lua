-- Register new question pack modules here. Each pack returns an array of question tables.
-- This indirection keeps quests and services independent from content authoring files.
local QuestionPacks = script.Parent.QuestionPacks

return {
	QuestionPacks.CS_CoreQuestions,
	QuestionPacks.STEMQuestions,
	QuestionPacks.SocietiesLanguageQuestions,
	QuestionPacks.FullCurriculumQuestions,
}
