local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

local IBRealms = ReplicatedStorage:WaitForChild("IBRealms")
local Subjects = require(IBRealms.Data.SubjectData)
local Config = require(IBRealms.Data.GameConfig)

local WorldBuilder = {}
local root = Instance.new("Folder")
root.Name = "IBRealmsWorld"
root.Parent = Workspace

local function part(name, size, cf, color, material, parent)
	local p = Instance.new("Part")
	p.Name = name
	p.Anchored = true
	p.Size = size
	p.CFrame = cf
	p.Color = color
	p.Material = material or Enum.Material.SmoothPlastic
	p.TopSurface = Enum.SurfaceType.Smooth
	p.BottomSurface = Enum.SurfaceType.Smooth
	p.Parent = parent or root
	return p
end

local function label(parent, text, offset, color)
	local billboard = Instance.new("BillboardGui")
	billboard.Name = "Label"
	billboard.Size = UDim2.fromOffset(260, 64)
	billboard.StudsOffset = offset or Vector3.new(0, 5, 0)
	billboard.AlwaysOnTop = true
	billboard.Parent = parent
	local t = Instance.new("TextLabel")
	t.BackgroundTransparency = 1
	t.Size = UDim2.fromScale(1, 1)
	t.Font = Enum.Font.GothamBold
	t.TextScaled = true
	t.TextColor3 = color or Color3.new(1,1,1)
	t.TextStrokeTransparency = 0.35
	t.Text = text
	t.Parent = billboard
end

local function prompt(parent, action, objectText, tag)
	local pr = Instance.new("ProximityPrompt")
	pr.ActionText = action
	pr.ObjectText = objectText
	pr.HoldDuration = 0
	pr.MaxActivationDistance = 14
	pr:SetAttribute("IBAction", tag)
	pr.Parent = parent
	return pr
end

local function platform(name, center, size, color)
	local folder = Instance.new("Folder")
	folder.Name = name
	folder.Parent = root
	part("Floor", Vector3.new(size.X, 2, size.Z), CFrame.new(center), color, Enum.Material.Slate, folder)
	part("NeonTrimNorth", Vector3.new(size.X, .35, 1), CFrame.new(center + Vector3.new(0, 1.2, -size.Z/2)), Config.Colors.Nexus, Enum.Material.Neon, folder)
	part("NeonTrimSouth", Vector3.new(size.X, .35, 1), CFrame.new(center + Vector3.new(0, 1.2, size.Z/2)), Config.Colors.Nexus, Enum.Material.Neon, folder)
	part("NeonTrimEast", Vector3.new(1, .35, size.Z), CFrame.new(center + Vector3.new(size.X/2, 1.2, 0)), Config.Colors.Nexus, Enum.Material.Neon, folder)
	part("NeonTrimWest", Vector3.new(1, .35, size.Z), CFrame.new(center + Vector3.new(-size.X/2, 1.2, 0)), Config.Colors.Nexus, Enum.Material.Neon, folder)
	return folder
end

local function bridge(name, from, to, width)
	local midpoint = (from + to) / 2
	local delta = to - from
	local length = Vector3.new(delta.X, 0, delta.Z).Magnitude
	local b = part(name, Vector3.new(width or 18, 1.2, length), CFrame.new(midpoint, to) * CFrame.new(0, 0, 0), Color3.fromRGB(38, 45, 62), Enum.Material.Metal)
	b.CFrame = CFrame.new(midpoint, to) * CFrame.new(0, 0, 0)
	part(name.."LeftRail", Vector3.new(1, 2.4, length), b.CFrame * CFrame.new(-(width or 18)/2, 1.5, 0), Config.Colors.Nexus, Enum.Material.Neon)
	part(name.."RightRail", Vector3.new(1, 2.4, length), b.CFrame * CFrame.new((width or 18)/2, 1.5, 0), Config.Colors.Nexus, Enum.Material.Neon)
end

local function npc(name, position, color, actionTag)
	local model = Instance.new("Model")
	model.Name = name
	model.Parent = root
	local base = part("Body", Vector3.new(4, 6, 2), CFrame.new(position + Vector3.new(0, 4, 0)), color, Enum.Material.SmoothPlastic, model)
	part("Head", Vector3.new(3, 2, 2), CFrame.new(position + Vector3.new(0, 8.2, 0)), Color3.fromRGB(235,235,245), Enum.Material.SmoothPlastic, model)
	label(base, name, Vector3.new(0, 5.5, 0), color)
	prompt(base, "Talk", name, actionTag or "Dialogue")
	return model
end

local function portal(name, position, color, actionTag, subjectId)
	local folder = Instance.new("Folder")
	folder.Name = name
	folder.Parent = root
	local pad = part("PortalPad", Vector3.new(16, 1, 10), CFrame.new(position), Color3.fromRGB(25, 30, 45), Enum.Material.Metal, folder)
	part("LeftFrame", Vector3.new(1.5, 16, 1.5), CFrame.new(position + Vector3.new(-6, 8, 0)), color, Enum.Material.Neon, folder)
	part("RightFrame", Vector3.new(1.5, 16, 1.5), CFrame.new(position + Vector3.new(6, 8, 0)), color, Enum.Material.Neon, folder)
	part("TopFrame", Vector3.new(13.5, 1.5, 1.5), CFrame.new(position + Vector3.new(0, 15.5, 0)), color, Enum.Material.Neon, folder)
	local field = part("PortalField", Vector3.new(10, 12, .5), CFrame.new(position + Vector3.new(0, 8, 0)), color, Enum.Material.Neon, folder)
	field.Transparency = 0.45
	field.CanCollide = false
	label(pad, name, Vector3.new(0, 8, 0), color)
	local pr = prompt(pad, "Open", name, actionTag)
	if subjectId then pr:SetAttribute("SubjectId", subjectId) end
	return folder
end

local function buildHub()
	platform("Central Nexus Plaza", Vector3.new(0,0,0), Vector3.new(160,0,160), Color3.fromRGB(32,36,54))
	local spawn = Instance.new("SpawnLocation")
	spawn.Name = "NexusSpawn"
	spawn.Anchored = true
	spawn.Size = Vector3.new(14,1,14)
	spawn.CFrame = CFrame.new(0,2,24)
	spawn.Color = Config.Colors.Nexus
	spawn.Material = Enum.Material.Neon
	spawn.Neutral = true
	spawn.Parent = root
	local core = part("NexusCore", Vector3.new(18,18,18), CFrame.new(0,15,0), Config.Colors.Nexus, Enum.Material.Neon)
	core.Shape = Enum.PartType.Ball
	label(core, "IB NEXUS", Vector3.new(0, 13, 0), Config.Colors.Nexus)
	npc("Nexus Mentor", Vector3.new(-24,2,26), Config.Colors.Nexus, "Mentor")
	portal("Dashboard Terminal", Vector3.new(-46,2,-18), Config.Colors.Nexus, "Dashboard")
	portal("IB Profile Terminal", Vector3.new(46,2,-18), Color3.fromRGB(160,220,255), "Profile")

	local islands = {
		{"Dashboard Island", Vector3.new(-180,0,0), Vector3.new(80,0,80), Color3.fromRGB(29,43,58), "Dashboard Console", Config.Colors.Nexus, "Dashboard"},
		{"Rank Hall", Vector3.new(180,0,0), Vector3.new(80,0,80), Color3.fromRGB(45,38,50), "Rank Keeper", Color3.fromRGB(255,210,90), "Rank"},
		{"PvP Island", Vector3.new(0,0,-180), Vector3.new(95,0,80), Color3.fromRGB(50,32,45), "Arena Master", Color3.fromRGB(255,90,90), "PVP"},
		{"Loadout Forge", Vector3.new(0,0,180), Vector3.new(90,0,80), Color3.fromRGB(54,42,34), "Loadout Engineer", Color3.fromRGB(255,160,70), "Loadout"},
		{"Category Wing", Vector3.new(0,0,320), Vector3.new(110,0,80), Color3.fromRGB(34,42,58), "Quest Clerk", Color3.fromRGB(140,220,255), "Category"},
		{"Daily Quest Board", Vector3.new(-150,0,180), Vector3.new(70,0,60), Color3.fromRGB(36,48,42), "Quest Clerk", Color3.fromRGB(120,255,170), "Daily"},
	}
	for _, item in ipairs(islands) do
		platform(item[1], item[2], item[3], item[4])
		bridge("BridgeTo"..item[1], Vector3.new(0,1.5,0), item[2] + Vector3.new(0,1.5,0), 18)
		npc(item[5], item[2] + Vector3.new(0,2,10), item[6], item[7])
	end
	portal("Arena Duel - Coming Soon", Vector3.new(-28,2,-180), Color3.fromRGB(255,90,90), "PVP")
	portal("Team Realm Clash - Preview", Vector3.new(0,2,-205), Color3.fromRGB(190,90,255), "PVP")
	portal("Boss Race - Preview", Vector3.new(28,2,-180), Color3.fromRGB(255,150,60), "PVP")
	portal("STEM Realms", Vector3.new(-32,2,320), Color3.fromRGB(80,200,255), "CategorySTEM")
	portal("Individuals & Societies", Vector3.new(0,2,344), Color3.fromRGB(255,210,90), "CategoryIndividuals & Societies")
	portal("Language World", Vector3.new(32,2,320), Color3.fromRGB(255,130,175), "CategoryLanguages")
end

local function buildPreview(subjectId, subject)
	local c = subject.PreviewCFrame.Position
	platform(subject.Realm .. " Preview", Vector3.new(c.X,0,c.Z), Vector3.new(82,0,62), Color3.fromRGB(30,34,46))
	local color = subject.Color
	part(subject.Base.."Landmark", Vector3.new(14,22,14), CFrame.new(c.X,13,c.Z), color, Enum.Material.Neon)
	label(root[subject.Realm .. " Preview"].Floor, subject.Realm .. "\n" .. subject.Name, Vector3.new(0,9,0), color)
	npc((subject.Realm == "System Core" and "Core Guide") or subject.Realm .. " Guide", Vector3.new(c.X-22,2,c.Z+12), color, "StartQuest")
	portal("Start "..subject.Name, Vector3.new(c.X+22,2,c.Z+12), color, "StartQuest", subjectId)
	portal("Return to IB Nexus", Vector3.new(c.X,2,c.Z-20), Config.Colors.Nexus, "ReturnHub")
	if subject.Base == "CS" then
		part("ServerTowerA", Vector3.new(8,18,8), CFrame.new(c.X-25,10,c.Z-15), Color3.fromRGB(10,80,80), Enum.Material.Metal)
		part("CodeStream", Vector3.new(2,18,28), CFrame.new(c.X+28,10,c.Z-8), color, Enum.Material.Neon).Transparency = .25
	elseif subject.Base == "MATHS" then
		part("GraphGrid", Vector3.new(45,.3,45), CFrame.new(c.X,2.2,c.Z), color, Enum.Material.Neon).Transparency = .75
	elseif subject.Base == "PHYSICS" then
		local orb = part("GravityWell", Vector3.new(16,16,16), CFrame.new(c.X+24,13,c.Z-12), color, Enum.Material.Neon); orb.Shape = Enum.PartType.Ball; orb.Transparency=.15
	elseif subject.Base == "BUSINESS" then
		part("OfficeBlock", Vector3.new(14,26,14), CFrame.new(c.X+24,15,c.Z-10), Color3.fromRGB(60,60,70), Enum.Material.SmoothPlastic)
	elseif subject.Base == "ECON" then
		part("ExchangeBoard", Vector3.new(32,16,2), CFrame.new(c.X,11,c.Z-18), color, Enum.Material.Neon).Transparency=.25
	elseif subject.Base == "ESS" then
		part("EcoCanopy", Vector3.new(24,8,24), CFrame.new(c.X+18,16,c.Z-10), Color3.fromRGB(60,160,85), Enum.Material.Grass)
	elseif subject.Base == "DT" then
		part("PrototypeBench", Vector3.new(28,4,12), CFrame.new(c.X+18,4,c.Z-12), Color3.fromRGB(100,70,45), Enum.Material.Wood)
	else
		part("CultureGate", Vector3.new(30,12,3), CFrame.new(c.X+18,8,c.Z-12), color, Enum.Material.Neon).Transparency=.35
	end
end

function WorldBuilder.Build()
	Lighting.Technology = Enum.Technology.Future
	Lighting.ClockTime = 18.2
	Lighting.Brightness = 2.2
	Lighting.Ambient = Color3.fromRGB(45,55,75)
	local atmosphere = Instance.new("Atmosphere")
	atmosphere.Density = 0.35
	atmosphere.Offset = 0.15
	atmosphere.Color = Color3.fromRGB(160,190,255)
	atmosphere.Decay = Color3.fromRGB(20,25,45)
	atmosphere.Parent = Lighting
	buildHub()
	local built = {}
	for id, subject in pairs(Subjects) do
		local key = subject.Realm .. tostring(subject.PreviewCFrame.Position)
		if not built[key] then buildPreview(id, subject); built[key]=true end
	end
end

WorldBuilder.Build()
return WorldBuilder
