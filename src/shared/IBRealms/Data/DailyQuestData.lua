local DailyQuestData = {
	Templates = {
		{
			id = "daily_weak_topic_repair",
			name = "Weak Topic Repair",
			description = "Clear one route question from a topic where you previously made a mistake.",
			rewardXP = 60,
			rewardCoins = 25,
			tags = { "weakness", "mastery" },
		},
		{
			id = "daily_cross_realm_warmup",
			name = "Cross-Realm Warmup",
			description = "Answer one question correctly in two different selected subjects.",
			rewardXP = 80,
			rewardCoins = 35,
			tags = { "multi_subject", "friends" },
		},
		{
			id = "daily_boss_attempt",
			name = "Boss Attempt",
			description = "Attempt any topic boss and review the feedback, even if you fail.",
			rewardXP = 100,
			rewardCoins = 45,
			tags = { "boss", "feedback" },
		},
	},
}

return DailyQuestData
