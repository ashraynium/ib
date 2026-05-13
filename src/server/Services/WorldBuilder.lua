local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local SubjectData = require(ReplicatedStorage:WaitForChild("IBRealms").Data.SubjectData)

local WorldBuilder = {}

local COLORS = {
	navy = Color3.fromRGB(8, 15, 30),
	slate = Color3.fromRGB(28, 34, 48),
	metal = Color3.fromRGB(52, 60, 78),
	teal = Color3.fromRGB(0, 221, 221),
	blue = Color3.fromRGB(90, 170, 255),
	purple = Color3.fromRGB(155, 105, 255),
	gold = Color3.fromRGB(255, 203, 90),
	red = Color3.fromRGB(255, 75, 98),
	orange = Color3.fromRGB(255, 145, 55),
	green = Color3.fromRGB(90, 220, 125),
	white = Color3.fromRGB(235, 245, 255),
}

local function part(parent, name, size, cframe, color, material)
	local p = Instance.new("Part")
	p.Name = name
	p.Anchored = true
	p.Size = size
	p.CFrame = cframe
	p.Color = color
	p.Material = material or Enum.Material.SmoothPlastic
	p.TopSurface = Enum.SurfaceType.Smooth
	p.BottomSurface = Enum.SurfaceType.Smooth
	p.Parent = parent
	return p
end

local function neon(parent, name, size, cframe, color)
	return part(parent, name, size, cframe, color, Enum.Material.Neon)
end

local function label(parent, text, adornee, yOffset, color)
	local gui = Instance.new("BillboardGui")
	gui.Name = text:gsub("%W", "") .. "Label"
	gui.Adornee = adornee
	gui.Size = UDim2.fromOffset(260, 64)
	gui.StudsOffset = Vector3.new(0, yOffset or 5, 0)
	gui.AlwaysOnTop = true
	gui.Parent = parent

	local t = Instance.new("TextLabel")
	t.BackgroundTransparency = 0.25
	t.BackgroundColor3 = Color3.fromRGB(8, 14, 24)
	t.BorderSizePixel = 0
	t.Size = UDim2.fromScale(1, 1)
	t.Font = Enum.Font.GothamBold
	t.Text = text
	t.TextColor3 = color or COLORS.white
	t.TextScaled = true
	t.Parent = gui
	return gui
end

local function prompt(parent, actionText, objectText, kind, targetId)
	local p = Instance.new("ProximityPrompt")
	p.ActionText = actionText
	p.ObjectText = objectText
	p.KeyboardKeyCode = Enum.KeyCode.E
	p.HoldDuration = 0
	p.MaxActivationDistance = 12
	p.RequiresLineOfSight = false
	p:SetAttribute("IBPromptKind", kind)
	if targetId then
		p:SetAttribute("TargetId", targetId)
	end
	p.Parent = parent
	return p
end

local function npc(parent, name, cframe, color, promptKind, targetId)
	local model = Instance.new("Model")
	model.Name = name
	model.Parent = parent
	local base = part(model, "Body", Vector3.new(4, 6, 2), cframe + Vector3.new(0, 3, 0), color, Enum.Material.SmoothPlastic)
	local head = part(model, "Head", Vector3.new(3, 3, 3), cframe + Vector3.new(0, 8, 0), COLORS.white, Enum.Material.SmoothPlastic)
	local glow = neon(model, "Aura", Vector3.new(4.4, 0.2, 2.4), cframe + Vector3.new(0, 0.15, 0), color)
	model.PrimaryPart = base
	label(model, name, head, 4, color)
	prompt(base, "Talk", name, promptKind or "Dashboard", targetId)
	return model
end

local function terminal(parent, name, cframe, color, promptKind, targetId)
	local stand = part(parent, name .. " Stand", Vector3.new(7, 1, 5), cframe, COLORS.metal, Enum.Material.Metal)
	local screen = neon(parent, name .. " Screen", Vector3.new(6, 4, 0.4), cframe * CFrame.new(0, 3, -2.3) * CFrame.Angles(math.rad(-12), 0, 0), color)
	label(parent, name, screen, 4, color)
	prompt(stand, "Open", name, promptKind, targetId)
	return stand
end

local function bridge(parent, name, cframe, size, color)
	part(parent, name .. " Deck", size, cframe, COLORS.slate, Enum.Material.Metal)
	neon(parent, name .. " Left Rail", Vector3.new(size.X, 0.4, 0.5), cframe * CFrame.new(0, 1, -size.Z / 2 + 0.5), color)
	neon(parent, name .. " Right Rail", Vector3.new(size.X, 0.4, 0.5), cframe * CFrame.new(0, 1, size.Z / 2 - 0.5), color)
end

local function island(parent, name, center, size, accent)
	local folder = Instance.new("Folder")
	folder.Name = name
	folder.Parent = parent
	part(folder, "Floor", Vector3.new(size.X, 2, size.Z), CFrame.new(center), COLORS.slate, Enum.Material.Slate)
	neon(folder, "Front Trim", Vector3.new(size.X, 0.4, 1), CFrame.new(center + Vector3.new(0, 1.2, -size.Z / 2)), accent)
	neon(folder, "Back Trim", Vector3.new(size.X, 0.4, 1), CFrame.new(center + Vector3.new(0, 1.2, size.Z / 2)), accent)
	neon(folder, "Left Trim", Vector3.new(1, 0.4, size.Z), CFrame.new(center + Vector3.new(-size.X / 2, 1.2, 0)), accent)
	neon(folder, "Right Trim", Vector3.new(1, 0.4, size.Z), CFrame.new(center + Vector3.new(size.X / 2, 1.2, 0)), accent)
	return folder
end

local function portal(parent, name, cframe, color, kind, targetId, comingSoon)
	local pad = neon(parent, name .. " Pad", Vector3.new(15, 0.35, 10), cframe, color)
	part(parent, name .. " Left Pillar", Vector3.new(1.5, 14, 1.5), cframe * CFrame.new(-6, 7, 0), color, Enum.Material.Neon)
	part(parent, name .. " Right Pillar", Vector3.new(1.5, 14, 1.5), cframe * CFrame.new(6, 7, 0), color, Enum.Material.Neon)
	part(parent, name .. " Header", Vector3.new(13, 1.5, 1.5), cframe * CFrame.new(0, 14, 0), color, Enum.Material.Neon)
	label(parent, comingSoon and (name .. "\nCOMING SOON") or name, pad, 7, color)
	prompt(pad, comingSoon and "Preview" or "Enter", name, kind, targetId)
	return pad
end

local function buildPreviewZones(root)
	local zones = Instance.new("Folder")
	zones.Name = "PreviewZones"
	zones.Parent = root
	local previewDefs = {
		ComputerScience = { pos = Vector3.new(-420, 6, 0), color = COLORS.teal, npc = "Byte Guide", title = "System Core", landmark = "CPU Core", quest = "cs_boot_sector" },
		Maths = { pos = Vector3.new(-260, 6, -260), color = COLORS.blue, npc = "Tower Archivist", title = "Infinite Tower", landmark = "Function Tower", quest = "math_functions_intro" },
		Physics = { pos = Vector3.new(0, 6, -420), color = Color3.fromRGB(100, 230, 255), npc = "Vector Engineer", title = "Reality Engine", landmark = "Energy Orb", quest = "physics_kinematics_intro" },
		DesignTechnology = { pos = Vector3.new(260, 6, -260), color = COLORS.orange, npc = "Prototype Engineer", title = "Innovation Forge", landmark = "Prototype Bench", quest = "dt_design_intro" },
		Business = { pos = Vector3.new(420, 6, 0), color = COLORS.gold, npc = "Strategy Broker", title = "Market City", landmark = "Strategy Tower", quest = "business_strategy_intro" },
		Economics = { pos = Vector3.new(260, 6, 260), color = COLORS.green, npc = "Policy Analyst", title = "Global Exchange", landmark = "Market Board", quest = "economics_markets_intro" },
		ESS = { pos = Vector3.new(0, 6, 420), color = Color3.fromRGB(95, 220, 120), npc = "Biosphere Ranger", title = "Biosphere Frontier", landmark = "Climate Station", quest = "ess_systems_intro" },
		Japanese = { pos = Vector3.new(-260, 6, 260), color = Color3.fromRGB(255, 145, 190), npc = "Sensei Aiko", title = "Sakura Isles", landmark = "Torii Gate", quest = "japanese_vocab_intro" },
		French = { pos = Vector3.new(-520, 6, 220), color = Color3.fromRGB(90, 140, 255), npc = "Madame Lumière", title = "Francophone Quarter", landmark = "Metro Café", quest = "french_vocab_intro" },
		Spanish = { pos = Vector3.new(520, 6, 220), color = Color3.fromRGB(255, 138, 80), npc = "Señor Vega", title = "Hispanic Plaza", landmark = "Festival Market", quest = "spanish_vocab_intro" },
	}
	for zoneId, def in pairs(previewDefs) do
		local f = island(zones, zoneId, def.pos, Vector3.new(90, 2, 76), def.color)
		f:SetAttribute("PreviewZoneId", zoneId)
		local sign = neon(f, def.title .. " Sign", Vector3.new(28, 8, 1), CFrame.new(def.pos + Vector3.new(0, 7, -31)), def.color)
		label(f, def.title, sign, 6, def.color)
		npc(f, def.npc, CFrame.new(def.pos + Vector3.new(-24, 1.2, 15)), def.color, "StartQuest", def.quest)
		terminal(f, "Start Quest", CFrame.new(def.pos + Vector3.new(22, 1.4, 15)), def.color, "StartQuest", def.quest)
		if zoneId == "ComputerScience" then
			for x = -30, 30, 15 do neon(f, "Circuit X " .. x, Vector3.new(1, 0.2, 55), CFrame.new(def.pos + Vector3.new(x, 1.4, 0)), def.color) end
			for z = -20, 25, 15 do neon(f, "Circuit Z " .. z, Vector3.new(65, 0.2, 1), CFrame.new(def.pos + Vector3.new(0, 1.45, z)), def.color) end
			part(f, "Server Column A", Vector3.new(8, 28, 8), CFrame.new(def.pos + Vector3.new(-8, 15, -8)), COLORS.metal, Enum.Material.Metal)
			part(f, "Server Column B", Vector3.new(8, 24, 8), CFrame.new(def.pos + Vector3.new(10, 13, -6)), COLORS.metal, Enum.Material.Metal)
		elseif zoneId == "Maths" then
			for i = 1, 5 do part(f, "Layered Geometric Platform " .. i, Vector3.new(34 - i * 3, 1.5, 34 - i * 3), CFrame.new(def.pos + Vector3.new(0, 2 + i * 3, -8)), COLORS.metal, Enum.Material.Metal) end
		elseif zoneId == "Physics" then
			neon(f, "Reality Energy Orb", Vector3.new(12, 12, 12), CFrame.new(def.pos + Vector3.new(0, 15, -8)), def.color).Shape = Enum.PartType.Ball
			neon(f, "Motion Track", Vector3.new(55, 0.4, 3), CFrame.new(def.pos + Vector3.new(0, 2, 5)), def.color)
		elseif zoneId == "ESS" then
			for i = 1, 8 do part(f, "Tree " .. i, Vector3.new(3, 12, 3), CFrame.new(def.pos + Vector3.new(-35 + i * 9, 7, -18)), Color3.fromRGB(80, 120, 70), Enum.Material.Wood) end
		else
			part(f, def.landmark, Vector3.new(18, 18, 18), CFrame.new(def.pos + Vector3.new(0, 10, -10)), COLORS.metal, Enum.Material.Metal)
		end
		label(f, def.landmark, f:FindFirstChild(def.landmark) or sign, 8, def.color)
	end
end

function WorldBuilder.Build()
	local old = Workspace:FindFirstChild("IBRealmsWorld")
	if old then old:Destroy() end
	local root = Instance.new("Folder")
	root.Name = "IBRealmsWorld"
	root.Parent = Workspace

	Lighting.ClockTime = 19.5
	Lighting.Brightness = 2
	Lighting.Ambient = Color3.fromRGB(25, 34, 60)
	Lighting.OutdoorAmbient = Color3.fromRGB(15, 22, 38)
	local atmosphere = Lighting:FindFirstChildOfClass("Atmosphere") or Instance.new("Atmosphere")
	atmosphere.Density = 0.28
	atmosphere.Offset = 0.15
	atmosphere.Color = Color3.fromRGB(135, 170, 220)
	atmosphere.Decay = Color3.fromRGB(14, 20, 45)
	atmosphere.Parent = Lighting
	local bloom = Lighting:FindFirstChildOfClass("BloomEffect") or Instance.new("BloomEffect")
	bloom.Intensity = 0.35
	bloom.Size = 28
	bloom.Threshold = 1.4
	bloom.Parent = Lighting
	local cc = Lighting:FindFirstChildOfClass("ColorCorrectionEffect") or Instance.new("ColorCorrectionEffect")
	cc.Contrast = 0.12
	cc.Saturation = 0.05
	cc.TintColor = Color3.fromRGB(220, 245, 255)
	cc.Parent = Lighting

	local hub = island(root, "IB Nexus Central Plaza", Vector3.new(0, 0, 0), Vector3.new(160, 2, 160), COLORS.teal)
	local spawn = neon(hub, "Safe Spawn Pad", Vector3.new(22, 0.5, 18), CFrame.new(0, 1.6, 24), COLORS.teal)
	spawn.Name = "IBRealmsSpawnPad"
	local spawnLocation = Instance.new("SpawnLocation")
	spawnLocation.Name = "IBRealmsSpawnLocation"
	spawnLocation.Anchored = true
	spawnLocation.Size = Vector3.new(20, 1, 16)
	spawnLocation.CFrame = CFrame.new(0, 2.2, 24)
	spawnLocation.Transparency = 1
	spawnLocation.Neutral = true
	spawnLocation.CanCollide = false
	spawnLocation.Parent = hub

	local core = neon(hub, "Nexus Core", Vector3.new(18, 18, 18), CFrame.new(0, 16, 0), COLORS.teal)
	core.Shape = Enum.PartType.Ball
	local light = Instance.new("PointLight")
	light.Color = COLORS.teal
	light.Range = 70
	light.Brightness = 2
	light.Parent = core
	label(hub, "IB Nexus", core, 14, COLORS.teal)
	npc(hub, "Nexus Mentor", CFrame.new(22, 1.2, 22), COLORS.teal, "IBProfile")
	terminal(hub, "Quick Dashboard", CFrame.new(-25, 1.4, 25), COLORS.blue, "Dashboard")

	bridge(root, "Dashboard Bridge", CFrame.new(-118, 0.4, 0), Vector3.new(88, 1.2, 14), COLORS.blue)
	local dashboard = island(root, "Dashboard Island", Vector3.new(-205, 0, 0), Vector3.new(86, 2, 72), COLORS.blue)
	terminal(dashboard, "Dashboard Terminal", CFrame.new(-220, 1.4, 0), COLORS.blue, "Dashboard")
	terminal(dashboard, "IB Profile Terminal", CFrame.new(-188, 1.4, 0), COLORS.teal, "IBProfile")

	bridge(root, "Rank Bridge", CFrame.new(118, 0.4, 0), Vector3.new(88, 1.2, 14), COLORS.purple)
	local rank = island(root, "Rank Hall", Vector3.new(205, 0, 0), Vector3.new(86, 2, 72), COLORS.purple)
	terminal(rank, "Rank Board", CFrame.new(205, 1.4, -14), COLORS.purple, "RankHall")
	npc(rank, "Rank Keeper", CFrame.new(205, 1.2, 18), COLORS.gold, "RankHall")

	bridge(root, "PvP Bridge", CFrame.new(0, 0.4, -118) * CFrame.Angles(0, math.rad(90), 0), Vector3.new(88, 1.2, 14), COLORS.red)
	local pvp = island(root, "PvP Island", Vector3.new(0, 0, -205), Vector3.new(104, 2, 74), COLORS.red)
	portal(pvp, "Arena Duel", CFrame.new(-32, 1.6, -205), COLORS.red, "PvPPreview", nil, true)
	portal(pvp, "Team Realm Clash", CFrame.new(0, 1.6, -205), COLORS.purple, "PvPPreview", nil, true)
	portal(pvp, "Boss Race", CFrame.new(32, 1.6, -205), COLORS.orange, "PvPPreview", nil, true)

	bridge(root, "Loadout Bridge", CFrame.new(0, 0.4, 118) * CFrame.Angles(0, math.rad(90), 0), Vector3.new(88, 1.2, 14), COLORS.orange)
	local forge = island(root, "Loadout Forge", Vector3.new(0, 0, 205), Vector3.new(96, 2, 72), COLORS.orange)
	terminal(forge, "Loadout Terminal", CFrame.new(-18, 1.4, 205), COLORS.orange, "Loadout")
	npc(forge, "Loadout Engineer", CFrame.new(20, 1.2, 205), COLORS.orange, "Loadout")
	for i = 1, 5 do neon(forge, "Move Stand " .. i, Vector3.new(7, 0.6, 7), CFrame.new(-40 + i * 14, 1.8, 232), COLORS.teal) end

	local category = island(root, "Category Wing", Vector3.new(0, 0, -330), Vector3.new(126, 2, 78), COLORS.teal)
	portal(category, "STEM Realms", CFrame.new(-40, 1.6, -330), COLORS.teal, "Category", "stem")
	portal(category, "Individuals and Societies", CFrame.new(0, 1.6, -330), COLORS.gold, "Category", "individuals")
	portal(category, "Language World", CFrame.new(40, 1.6, -330), Color3.fromRGB(255, 122, 184), "Category", "language")

	local daily = island(root, "Daily Quest Island", Vector3.new(-205, 0, 120), Vector3.new(76, 2, 58), COLORS.green)
	terminal(daily, "Daily Quest Board", CFrame.new(-205, 1.4, 105), COLORS.green, "Dashboard")
	npc(daily, "Quest Clerk", CFrame.new(-205, 1.2, 132), COLORS.green, "Dashboard")

	buildPreviewZones(root)

	-- Lightweight subject preview pads around the Nexus Core until dynamic portals become full realm routes.
	for i, subject in ipairs(SubjectData.Subjects) do
		local angle = (math.pi * 2) * (i / #SubjectData.Subjects)
		local x = math.cos(angle) * 58
		local z = math.sin(angle) * 58
		local pad = neon(hub, subject.shortName .. " Preview Pad", Vector3.new(12, 0.35, 7), CFrame.new(x, 1.7, z) * CFrame.Angles(0, -angle, 0), subject.color)
		label(hub, subject.shortName, pad, 4.5, subject.color)
		prompt(pad, "Preview", subject.name, "SubjectPreview", subject.id)
	end
end

return WorldBuilder
