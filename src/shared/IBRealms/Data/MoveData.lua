local MoveData = {
	Moves = {
		{ id = "debug_pulse", name = "Debug Pulse", subjectBase = "computer_science", category = "damage", tier = 1, cooldown = 5, energyCost = 12, effect = "Fires a precise logic pulse that damages corrupted topic enemies.", unlockCondition = "Complete Boot Sector", masteryRequirement = 0 },
		{ id = "firewall_shield", name = "Firewall Shield", subjectBase = "computer_science", category = "defence", tier = 2, cooldown = 14, energyCost = 25, effect = "Raises a protective barrier; future upgrades absorb team damage.", unlockCondition = "Clear Broken Processor", masteryRequirement = 25 },

		{ id = "packet_trap", name = "Packet Trap", subjectBase = "computer_science", category = "control", tier = 2, cooldown = 12, energyCost = 24, effect = "Places a logic snare that slows corrupted enemies crossing it.", unlockCondition = "Clear Algorithms route", masteryRequirement = 20 },
		{ id = "recursive_strike", name = "Recursive Strike", subjectBase = "computer_science", category = "damage", tier = 3, cooldown = 16, energyCost = 34, effect = "Repeats a precise strike if the first hit lands on a weakened enemy.", unlockCondition = "Clear Algorithm Arena boss", masteryRequirement = 35 },
		{ id = "cache_blink", name = "Cache Blink", subjectBase = "computer_science", category = "mobility", tier = 2, cooldown = 9, energyCost = 22, effect = "Short-range blink to a previously marked safe node.", unlockCondition = "Clear CPU Core", masteryRequirement = 20 },
		{ id = "diagnostic_link", name = "Diagnostic Link", subjectBase = "computer_science", category = "support", tier = 2, cooldown = 18, energyCost = 30, effect = "Marks an enemy weakness so allies deal bonus damage.", unlockCondition = "Clear Databases route", masteryRequirement = 30 },
		{ id = "logic_key", name = "Logic Key", subjectBase = "computer_science", category = "utility", tier = 2, cooldown = 11, energyCost = 18, effect = "Opens future dungeon locks and reveals hidden rule states.", unlockCondition = "Clear Binary Vault", masteryRequirement = 25 },
		{ id = "proof_guard", name = "Proof Guard", subjectBase = "maths", category = "defence", tier = 2, cooldown = 13, energyCost = 26, effect = "Creates a short shield that strengthens after exact reasoning chains.", unlockCondition = "Clear Functions boss", masteryRequirement = 25 },
		{ id = "parabola_launch", name = "Parabola Launch", subjectBase = "maths", category = "damage", tier = 2, cooldown = 10, energyCost = 24, effect = "Launches an arcing projectile whose path previews quadratic motion.", unlockCondition = "Clear Trigonometry Gate route", masteryRequirement = 20 },
		{ id = "angle_bind", name = "Angle Bind", subjectBase = "maths", category = "control", tier = 3, cooldown = 18, energyCost = 36, effect = "Locks enemies into a sector and rewards correct angle reasoning.", unlockCondition = "Clear Trigonometry boss", masteryRequirement = 35 },
		{ id = "limit_step", name = "Limit Step", subjectBase = "maths", category = "utility", tier = 3, cooldown = 14, energyCost = 28, effect = "Lets the player phase through a narrow future puzzle gate.", unlockCondition = "Clear Calculus route", masteryRequirement = 35 },
		{ id = "field_barrier", name = "Field Barrier", subjectBase = "physics", category = "defence", tier = 2, cooldown = 14, energyCost = 28, effect = "Creates a force-field shield aligned to incoming vectors.", unlockCondition = "Clear Force Bridge route", masteryRequirement = 25 },
		{ id = "kinetic_burst", name = "Kinetic Burst", subjectBase = "physics", category = "damage", tier = 2, cooldown = 9, energyCost = 22, effect = "Converts stored motion into an area burst.", unlockCondition = "Clear Energy Reactor route", masteryRequirement = 25 },
		{ id = "wave_step", name = "Wave Step", subjectBase = "physics", category = "mobility", tier = 2, cooldown = 8, energyCost = 20, effect = "Surfs along a short wave path and avoids ground hazards.", unlockCondition = "Clear Wave Chamber route", masteryRequirement = 25 },
		{ id = "efficiency_aura", name = "Efficiency Aura", subjectBase = "physics", category = "support", tier = 3, cooldown = 24, energyCost = 42, effect = "Reduces ally energy waste for a short duration.", unlockCondition = "Clear Energy Reactor boss", masteryRequirement = 40 },
		{ id = "stakeholder_rally", name = "Stakeholder Rally", subjectBase = "business", category = "support", tier = 2, cooldown = 20, energyCost = 32, effect = "Buffs nearby allies after a balanced decision.", unlockCondition = "Clear Strategy Street route", masteryRequirement = 25 },
		{ id = "cashflow_guard", name = "Cashflow Guard", subjectBase = "business", category = "defence", tier = 2, cooldown = 16, energyCost = 30, effect = "Absorbs a burst of damage and converts part into coins in PvE.", unlockCondition = "Clear Finance District route", masteryRequirement = 25 },
		{ id = "brand_flash", name = "Brand Flash", subjectBase = "business", category = "damage", tier = 2, cooldown = 8, energyCost = 18, effect = "A quick ranged strike that marks a target segment.", unlockCondition = "Clear Marketing Avenue route", masteryRequirement = 20 },
		{ id = "elastic_snap", name = "Elastic Snap", subjectBase = "economics", category = "damage", tier = 2, cooldown = 9, energyCost = 20, effect = "Deals bonus damage when an enemy is already pressured.", unlockCondition = "Clear Market Square route", masteryRequirement = 20 },
		{ id = "subsidy_field", name = "Subsidy Field", subjectBase = "economics", category = "support", tier = 2, cooldown = 22, energyCost = 38, effect = "Creates a team buff zone with a visible opportunity-cost warning.", unlockCondition = "Clear Market Failure Field route", masteryRequirement = 30 },
		{ id = "interest_rate_lock", name = "Interest Rate Lock", subjectBase = "economics", category = "control", tier = 3, cooldown = 20, energyCost = 40, effect = "Slows enemy ability cycles in a policy field.", unlockCondition = "Clear Macro Central Bank boss", masteryRequirement = 45 },
		{ id = "biodiversity_wall", name = "Biodiversity Wall", subjectBase = "ess", category = "defence", tier = 2, cooldown = 16, energyCost = 30, effect = "Creates layered protection that gets stronger with ecosystem mastery.", unlockCondition = "Clear Ecosystem Trail route", masteryRequirement = 25 },
		{ id = "feedback_loop", name = "Feedback Loop", subjectBase = "ess", category = "control", tier = 2, cooldown = 18, energyCost = 34, effect = "Either stabilises allies or amplifies enemy vulnerability depending on target.", unlockCondition = "Clear Systems Camp boss", masteryRequirement = 35 },
		{ id = "habitat_dash", name = "Habitat Dash", subjectBase = "ess", category = "mobility", tier = 1, cooldown = 7, energyCost = 16, effect = "Dash through environmental cover and leave a small restorative trail.", unlockCondition = "Clear Systems Camp route", masteryRequirement = 10 },
		{ id = "repair_drone", name = "Repair Drone", subjectBase = "design_technology", category = "support", tier = 2, cooldown = 20, energyCost = 34, effect = "Deploys a small helper that repairs shields or terminals.", unlockCondition = "Clear Prototype Bench route", masteryRequirement = 25 },
		{ id = "ergonomic_dash", name = "Ergonomic Dash", subjectBase = "design_technology", category = "mobility", tier = 1, cooldown = 7, energyCost = 16, effect = "A low-fatigue movement burst designed around user control.", unlockCondition = "Clear Design Brief Bench route", masteryRequirement = 10 },
		{ id = "stress_test", name = "Stress Test", subjectBase = "design_technology", category = "damage", tier = 2, cooldown = 11, energyCost = 24, effect = "Applies repeated test strikes and reveals structural weaknesses.", unlockCondition = "Clear Materials Lab route", masteryRequirement = 25 },
		{ id = "dialogue_counter", name = "Dialogue Counter", subjectBase = "languages", category = "defence", tier = 2, cooldown = 10, energyCost = 18, effect = "Counters a hit after choosing an appropriate response register.", unlockCondition = "Clear Dialogue Street route", masteryRequirement = 20 },
		{ id = "grammar_dash", name = "Grammar Dash", subjectBase = "languages", category = "mobility", tier = 1, cooldown = 6, energyCost = 14, effect = "A quick reposition that chains after accurate grammar choices.", unlockCondition = "Clear Grammar Shrine route", masteryRequirement = 10 },
		{ id = "culture_shift", name = "Culture Shift", subjectBase = "languages", category = "utility", tier = 2, cooldown = 15, energyCost = 26, effect = "Reveals contextual clues in dialogue and future culture quests.", unlockCondition = "Clear Culture Quest route", masteryRequirement = 25 },
		{ id = "system_override", name = "System Override", subjectBase = "computer_science", category = "control", tier = 5, cooldown = 60, energyCost = 90, effect = "Ultimate: disables enemy abilities in a field in future real-time PvE/PvP.", unlockCondition = "Future System Core boss", masteryRequirement = 70 },
		{ id = "vector_dash", name = "Vector Dash", subjectBase = "maths", category = "mobility", tier = 1, cooldown = 6, energyCost = 15, effect = "Dash along a clean vector path; later upgrades bend around graph gates.", unlockCondition = "Complete Function Floor intro", masteryRequirement = 0 },
		{ id = "asymptote_wall", name = "Asymptote Wall", subjectBase = "maths", category = "control", tier = 3, cooldown = 18, energyCost = 34, effect = "Creates a barrier line that enemies cannot cross briefly.", unlockCondition = "Future functions boss", masteryRequirement = 35 },
		{ id = "momentum_push", name = "Momentum Push", subjectBase = "physics", category = "control", tier = 1, cooldown = 7, energyCost = 15, effect = "Applies a clean force impulse to push enemies away.", unlockCondition = "Complete Kinematics Canyon intro", masteryRequirement = 0 },
		{ id = "gravity_well", name = "Gravity Well", subjectBase = "physics", category = "control", tier = 4, cooldown = 25, energyCost = 55, effect = "Creates a pull zone for future team combat.", unlockCondition = "Future energy boss", masteryRequirement = 55 },
		{ id = "risk_hedge", name = "Risk Hedge", subjectBase = "business", category = "defence", tier = 1, cooldown = 10, energyCost = 18, effect = "Reduces incoming damage after choosing a sound strategy.", unlockCondition = "Complete Strategy Street intro", masteryRequirement = 0 },
		{ id = "demand_shift", name = "Demand Shift", subjectBase = "economics", category = "control", tier = 1, cooldown = 9, energyCost = 18, effect = "Applies market pressure that weakens enemy output.", unlockCondition = "Complete Market Square intro", masteryRequirement = 0 },
		{ id = "carbon_sink", name = "Carbon Sink", subjectBase = "ess", category = "support", tier = 1, cooldown = 12, energyCost = 20, effect = "Creates a restorative zone that rewards accurate systems thinking.", unlockCondition = "Complete Systems Camp intro", masteryRequirement = 0 },
		{ id = "prototype_shield", name = "Prototype Shield", subjectBase = "design_technology", category = "utility", tier = 1, cooldown = 10, energyCost = 20, effect = "Deploys a tested barrier prototype for the team.", unlockCondition = "Complete Design Brief Bench intro", masteryRequirement = 0 },
		{ id = "vocab_slash", name = "Vocab Slash", subjectBase = "languages", category = "damage", tier = 1, cooldown = 4, energyCost = 10, effect = "A fast combo strike powered by contextual vocabulary recall.", unlockCondition = "Complete a Language World vocab intro", masteryRequirement = 0 },
	},
}

function MoveData.GetMove(moveId)
	for _, move in ipairs(MoveData.Moves) do
		if move.id == moveId then
			return move
		end
	end
	return nil
end

function MoveData.GetMovesForBase(subjectBase)
	local result = {}
	for _, move in ipairs(MoveData.Moves) do
		if move.subjectBase == subjectBase then
			table.insert(result, move)
		end
	end
	return result
end

return MoveData
