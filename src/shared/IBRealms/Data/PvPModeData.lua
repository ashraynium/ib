local PvPModeData = {
	Modes = {
		arena_duel = {
			name = "Arena Duel",
			status = "scaffolded",
			teamSize = 1,
			rankedSupported = true,
			statRule = "Casual uses progression power; ranked equalises base stats and keeps unlocked move variety.",
			winCondition = "Defeat the opponent using learned abilities, positioning, counters, and cooldown discipline.",
			learningRule = "No quiz prompts during PvP; revision unlocks moves before combat.",
		},
		team_realm_clash = {
			name = "Team Realm Clash",
			status = "scaffolded",
			teamSize = 4,
			rankedSupported = false,
			statRule = "Objective mode with normalised team roles planned for later.",
			winCondition = "Hold rotating control points themed around subject realms.",
			learningRule = "Subject mastery broadens team utility and counterplay.",
		},
		boss_race = {
			name = "Boss Race",
			status = "scaffolded",
			teamSize = 3,
			rankedSupported = false,
			statRule = "Mirrored dungeons; mistakes reduce team focus and speed.",
			winCondition = "Defeat the mirrored boss first with fewer learning mistakes.",
			learningRule = "PvE questions and combat combine in a competitive co-op format.",
		},
	},
}

function PvPModeData.GetMode(modeId)
	return PvPModeData.Modes[modeId]
end

return PvPModeData
