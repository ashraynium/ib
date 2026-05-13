-- Quests are data-driven. Normal quests use questionFilter pools; bosses may provide fixedQuestionIds later.
local SubjectData = require(script.Parent.SubjectData)
local CurriculumData = require(script.Parent.CurriculumData)

local function baseForTopic(topicId)
	if string.find(topicId, "^math") then return "maths" end
	if string.find(topicId, "^physics") then return "physics" end
	if string.find(topicId, "^dt") then return "design_technology" end
	if string.find(topicId, "^business") then return "business" end
	if string.find(topicId, "^economics") then return "economics" end
	if string.find(topicId, "^ess") then return "ess" end
	if topicId == "language_core" then return "languages" end
	return "computer_science"
end

local function intro(id, subjectId, topicId, title, giver, enemy, moveUnlock, badgeUnlock, tokenUnlock, briefing)
	return {
		id = id,
		subjectId = subjectId,
		subjectBase = baseForTopic(topicId),
		topicId = topicId,
		title = title,
		questType = "intro_question_battle",
		giver = giver,
		briefing = briefing,
		startDialogue = "Prove the concept, repair the realm, and learn from every mistake.",
		objective = "Answer revision challenges to defeat the topic enemy.",
		enemyName = enemy,
		enemyHP = 100,
		playerFocus = 100,
		questionFilter = { subjectBase = baseForTopic(topicId), topicId = topicId, minDifficulty = 1, maxDifficulty = 3 },
		rewardXP = 80,
		rewardCoins = 35,
		moveUnlock = moveUnlock,
		badgeUnlock = badgeUnlock,
		tokenUnlock = tokenUnlock,
		unlocksNextQuest = nil,
		completionDialogue = "Quest cleared. Your profile now remembers this progress and any weak topics found.",
	}
end


local function questKey(subjectId, topicId, suffix)
	return subjectId .. "_" .. topicId .. "_" .. suffix
end

local function makeCampaignQuest(subject, topicId, suffix, difficultyMin, difficultyMax, rewardScale, titlePrefix)
	local topic = CurriculumData.GetTopic(topicId) or { title = topicId, enemies = { "Topic Enemy" }, scope = "Structured revision challenge." }
	local enemy = topic.enemies and topic.enemies[math.clamp(difficultyMax, 1, #topic.enemies)] or "Topic Enemy"
	return {
		id = questKey(subject.id, topicId, suffix),
		subjectId = subject.id,
		subjectBase = subject.base,
		topicId = topicId,
		title = titlePrefix .. ": " .. topic.title,
		questType = suffix == "boss" and "topic_boss" or "topic_campaign",
		giver = subject.realmName .. " Mentor",
		briefing = topic.scope,
		startDialogue = topic.visualMemory or "Use the realm layout to remember the concept before answering.",
		objective = suffix == "boss" and "Clear a synthesis boss challenge with explanation and judgement." or "Complete a structured topic route from recognition to application.",
		enemyName = enemy,
		enemyHP = suffix == "boss" and 180 or 120,
		playerFocus = 100,
		questionFilter = { subjectBase = subject.base, subjectId = subject.id, topicId = topicId, minDifficulty = difficultyMin, maxDifficulty = difficultyMax },
		rewardXP = math.floor(90 * rewardScale),
		rewardCoins = math.floor(40 * rewardScale),
		moveUnlock = nil,
		badgeUnlock = suffix == "boss" and (topic.title .. " Cleared") or nil,
		tokenUnlock = suffix == "boss" and (topic.title .. " Token") or nil,
		unlocksNextQuest = nil,
		completionDialogue = suffix == "boss" and "Boss cleared. Your subject rank, mastery, and token progress have advanced." or "Topic route cleared. The next campaign node is ready when you are.",
	}
end

local function generateFullCampaignQuests(questMap)
	for _, subject in ipairs(SubjectData.Subjects) do
		for index, topicId in ipairs(subject.topics or {}) do
			local routeId = questKey(subject.id, topicId, "route")
			local bossId = questKey(subject.id, topicId, "boss")
			if not questMap[routeId] then
				questMap[routeId] = makeCampaignQuest(subject, topicId, "route", 1, 4, 1 + index * 0.2, "Campaign Route")
			end
			if not questMap[bossId] then
				questMap[bossId] = makeCampaignQuest(subject, topicId, "boss", 4, 5, 1.8 + index * 0.25, "Boss Challenge")
			end
			questMap[routeId].unlocksNextQuest = bossId
			local nextTopicId = subject.topics[index + 1]
			if nextTopicId then
				questMap[bossId].unlocksNextQuest = questKey(subject.id, nextTopicId, "route")
			end
		end
	end
end

local QuestData = {
	Quests = {
		cs_boot_sector = {
			id = "cs_boot_sector",
			subjectId = "cs_hl",
			subjectBase = "computer_science",
			topicId = "cs_hardware",
			title = "Boot Sector: Repair the CPU Layer",
			questType = "demo_chain",
			giver = "Byte Guide",
			briefing = "NULL corruption has scrambled the System Core. Start by proving what the CPU, ALU, control unit, RAM, ROM, cache, and buses actually do.",
			startDialogue = "The Boot Sector is not a quiz room. Every answer repairs a component of the machine.",
			objective = "Defeat Byte Slimes by answering hardware recognition and understanding challenges.",
			enemyName = "Byte Slime Pack",
			enemyHP = 120,
			playerFocus = 100,
			questionFilter = { subjectBase = "computer_science", topicId = "cs_hardware", minDifficulty = 1, maxDifficulty = 3, tags = { "cpu", "memory", "performance" } },
			rewardXP = 120,
			rewardCoins = 55,
			moveUnlock = "debug_pulse",
			badgeUnlock = "Hardware Initiate",
			tokenUnlock = nil,
			unlocksNextQuest = "cs_cpu_core",
			completionDialogue = "Boot Sector stabilised. Debug Pulse unlocked. The CPU Core route is now visible.",
		},
		cs_cpu_core = {
			id = "cs_cpu_core",
			subjectId = "cs_hl",
			subjectBase = "computer_science",
			topicId = "cs_hardware",
			title = "CPU Core: Bottleneck Hunt",
			questType = "application_chain",
			giver = "Byte Guide",
			briefing = "The Core now runs, but games, databases, and simulations still lag. Diagnose the real bottleneck instead of memorising upgrade names.",
			startDialogue = "A strong CS answer explains why a change solves the actual problem.",
			objective = "Defeat Cache Wraiths by applying hardware ideas to scenarios.",
			enemyName = "Cache Wraith",
			enemyHP = 150,
			playerFocus = 100,
			questionFilter = { subjectBase = "computer_science", topicId = "cs_hardware", minDifficulty = 3, maxDifficulty = 4, tags = { "bottleneck", "cache", "ram" } },
			rewardXP = 150,
			rewardCoins = 70,
			moveUnlock = nil,
			badgeUnlock = nil,
			tokenUnlock = nil,
			unlocksNextQuest = "cs_broken_processor",
			completionDialogue = "Performance layer repaired. The Broken Processor is exposed.",
		},
		cs_broken_processor = {
			id = "cs_broken_processor",
			subjectId = "cs_hl",
			subjectBase = "computer_science",
			topicId = "cs_hardware",
			title = "Boss: Broken Processor",
			questType = "boss_question_battle",
			giver = "Byte Guide",
			briefing = "This boss tests explanation, comparison, and justified upgrades. Recall alone will not break the corruption.",
			startDialogue = "Explain cause and effect. Compare alternatives. Justify the best repair.",
			objective = "Defeat the Broken Processor with analysis and synthesis challenges.",
			enemyName = "Broken Processor",
			enemyHP = 180,
			playerFocus = 100,
			questionFilter = { subjectBase = "computer_science", topicId = "cs_hardware", minDifficulty = 4, maxDifficulty = 5, tags = { "boss", "performance", "fetch_execute" } },
			rewardXP = 220,
			rewardCoins = 110,
			moveUnlock = "firewall_shield",
			badgeUnlock = "Hardware Initiate",
			tokenUnlock = "Processor Core Token",
			unlocksNextQuest = "cs_binary_vault_preview",
			completionDialogue = "Broken Processor defeated. Firewall Shield and a Processor Core Token are now attached to your profile.",
		},
		cs_binary_vault_preview = {
			id = "cs_binary_vault_preview",
			subjectId = "cs_hl",
			subjectBase = "computer_science",
			topicId = "cs_data",
			title = "Binary Vault Preview",
			questType = "preview_question_battle",
			giver = "Byte Guide",
			briefing = "The next vault introduces binary conversion, image representation, sound, compression, and logic gates.",
			startDialogue = "Open the first lock by proving place value and Boolean logic.",
			objective = "Answer data representation preview challenges.",
			enemyName = "Logic Lock",
			enemyHP = 100,
			playerFocus = 100,
			questionFilter = { subjectBase = "computer_science", topicId = "cs_data", minDifficulty = 1, maxDifficulty = 3 },
			rewardXP = 100,
			rewardCoins = 45,
			moveUnlock = nil,
			badgeUnlock = nil,
			tokenUnlock = nil,
			unlocksNextQuest = nil,
			completionDialogue = "Binary Vault route opened. Continue into generated route and boss quests from the Topic Map.",
		},

		math_functions_intro = intro("math_functions_intro", "math_aa_hl", "math_functions", "Function Floor: Valid Inputs", "Tower Archivist", "Graph Gate", "vector_dash", nil, nil, "Unlock graph gates by reading notation, substitution, domain restrictions, and transformations."),
		physics_kinematics_intro = intro("physics_kinematics_intro", "physics_hl", "physics_kinematics", "Kinematics Canyon: Motion Sync", "Vector Engineer", "Drifting Motion Layer", "momentum_push", nil, nil, "Repair the Reality Engine by distinguishing displacement, velocity, acceleration, graph gradients, and graph areas."),
		dt_design_intro = intro("dt_design_intro", "dt_hl", "dt_design", "The First Prototype", "Prototype Engineer", "Unclear Brief", "prototype_shield", nil, nil, "A design is strong when it solves a real user need and can be tested against criteria."),
		business_strategy_intro = intro("business_strategy_intro", "business_hl", "business_strategy", "Enter Market City", "Strategy Broker", "Weak Strategy", "risk_hedge", nil, nil, "Use context, stakeholders, SWOT, Ansoff, and evaluation to make better business decisions."),
		economics_markets_intro = intro("economics_markets_intro", "economics_hl", "economics_markets", "Market Square Signals", "Policy Analyst", "Price Shock", "demand_shift", nil, nil, "Scarcity, incentives, demand, supply, and equilibrium power the Global Exchange."),
		ess_systems_intro = intro("ess_systems_intro", "ess_sl", "ess_systems", "Systems Camp: Connected Flows", "Biosphere Ranger", "Feedback Surge", "carbon_sink", nil, nil, "Ecosystems behave as connected systems with inputs, outputs, stores, flows, and feedback loops."),
		japanese_vocab_intro = intro("japanese_vocab_intro", "japanese_b", "language_core", "Sakura Vocab Gate", "Sensei Aiko", "Silent Gate", "vocab_slash", nil, nil, "Read signs and dialogue carefully; vocabulary only matters when it helps communication."),
		french_vocab_intro = intro("french_vocab_intro", "french_b", "language_core", "Francophone Vocab Gate", "Madame Lumière", "Metro Misread", "vocab_slash", nil, nil, "Use context, accents, gender clues, and natural phrases in a Francophone quarter."),
		spanish_vocab_intro = intro("spanish_vocab_intro", "spanish_b", "language_core", "Hispanic Plaza Vocab Gate", "Señor Vega", "Festival Mix-up", "vocab_slash", nil, nil, "Practise useful words and agreement through travel and plaza conversation."),
	},
}

generateFullCampaignQuests(QuestData.Quests)

function QuestData.GetQuest(questId)
	return QuestData.Quests[questId]
end

function QuestData.GetQuestForSubject(subjectId)
	for _, quest in pairs(QuestData.Quests) do
		if quest.subjectId == subjectId then
			return quest
		end
	end
	return QuestData.Quests.cs_boot_sector
end

return QuestData
