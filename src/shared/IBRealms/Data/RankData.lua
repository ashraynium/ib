local RankData = {
	Overall = {
		{ name = "Bronze", minimumProgress = 0 },
		{ name = "Silver", minimumProgress = 15 },
		{ name = "Gold", minimumProgress = 32 },
		{ name = "Platinum", minimumProgress = 52 },
		{ name = "Diamond", minimumProgress = 72 },
		{ name = "Master", minimumProgress = 88 },
		{ name = "IB Champion", minimumProgress = 100 },
	},
	Subject = {
		computer_science = { "Debugger", "Programmer", "Algorithmist", "System Architect", "Core Sovereign" },
		maths = { "Solver", "Pattern Seeker", "Proofsmith", "Tower Master", "Infinite Champion" },
		physics = { "Observer", "Mechanic", "Field Engineer", "Reality Shaper", "Lawbreaker" },
		business = { "Intern", "Analyst", "Strategist", "Executive", "Market King" },
		economics = { "Trader", "Policy Analyst", "Market Theorist", "Central Banker", "Global Economist" },
		ess = { "Explorer", "Conservationist", "Systems Thinker", "Biosphere Guardian", "Planet Steward" },
		design_technology = { "Tinkerer", "Designer", "Prototype Engineer", "Innovation Lead", "Design Visionary" },
		languages = { "Speaker", "Conversationalist", "Interpreter", "Diplomat", "Fluency Master" },
	},
}

function RankData.GetSubjectRank(subjectBase, progress)
	local ranks = RankData.Subject[subjectBase] or RankData.Subject.languages
	local index = math.clamp(math.floor((progress or 0) / 20) + 1, 1, #ranks)
	return ranks[index]
end

function RankData.GetOverallRank(progress)
	local rank = RankData.Overall[1].name
	for _, candidate in ipairs(RankData.Overall) do
		if progress >= candidate.minimumProgress then
			rank = candidate.name
		end
	end
	return rank
end

return RankData
