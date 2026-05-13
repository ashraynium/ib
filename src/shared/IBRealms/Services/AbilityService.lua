local MoveData = require(script.Parent.Parent.Data.MoveData)

local AbilityService = {}

local function ownsMove(profile, moveId)
	return profile and profile.unlockedMoves and profile.unlockedMoves[moveId] == true
end

function AbilityService.GetAvailableMoves(profile, subjectBase)
	local moves = MoveData.GetMovesForBase(subjectBase)
	local available = {}
	for _, move in ipairs(moves) do
		local copy = table.clone(move)
		copy.unlocked = ownsMove(profile, move.id) or move.tier == 1
		table.insert(available, copy)
	end
	return available
end

function AbilityService.BuildDefaultLoadout(profile, subjectBases)
	local normal = {}
	local ultimate = nil
	local seen = {}
	for _, subjectBase in ipairs(subjectBases or {}) do
		for _, move in ipairs(AbilityService.GetAvailableMoves(profile, subjectBase)) do
			if move.unlocked and not seen[move.id] then
				seen[move.id] = true
				if move.tier >= 5 and not ultimate then
					ultimate = move.id
				elseif move.tier < 5 and #normal < 4 then
					table.insert(normal, move.id)
				end
			end
		end
	end
	return { normal = normal, ultimate = ultimate }
end

function AbilityService.ValidateLoadout(profile, loadout)
	local normal = {}
	local ultimate = nil
	local seen = {}
	for _, moveId in ipairs((loadout and loadout.normal) or {}) do
		local move = MoveData.GetMove(moveId)
		if move and move.tier < 5 and ownsMove(profile, moveId) and not seen[moveId] and #normal < 4 then
			seen[moveId] = true
			table.insert(normal, moveId)
		end
	end
	local ultimateMove = loadout and loadout.ultimate and MoveData.GetMove(loadout.ultimate)
	if ultimateMove and ultimateMove.tier >= 5 and ownsMove(profile, ultimateMove.id) then
		ultimate = ultimateMove.id
	end
	return { normal = normal, ultimate = ultimate }
end

return AbilityService
