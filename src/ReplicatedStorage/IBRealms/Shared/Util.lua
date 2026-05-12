local Util = {}
function Util.copy(value)
	if type(value) ~= "table" then return value end
	local out = {}
	for k, v in pairs(value) do out[k] = Util.copy(v) end
	return out
end
function Util.contains(list, value)
	for _, item in ipairs(list or {}) do if item == value then return true end end
	return false
end
function Util.keys(map)
	local out = {}
	for key in pairs(map or {}) do table.insert(out, key) end
	table.sort(out)
	return out
end
function Util.round(n) return math.floor((n or 0) + 0.5) end
function Util.safePercent(part, total)
	if not total or total <= 0 then return 0 end
	return math.floor((part / total) * 100 + 0.5)
end
return Util
