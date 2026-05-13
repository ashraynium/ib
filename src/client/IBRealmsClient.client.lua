local Players = game:GetService("Players")
local ProximityPromptService = game:GetService("ProximityPromptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local IBRealms = ReplicatedStorage:WaitForChild("IBRealms")
local Remotes = IBRealms:WaitForChild("Remotes")
local SubjectData = require(IBRealms.Data.SubjectData)
local RankData = require(IBRealms.Data.RankData)
local MoveData = require(IBRealms.Data.MoveData)
local GameConfig = require(IBRealms.Data.GameConfig)

local getProfile = Remotes:WaitForChild("GetProfile")
local updateSubjects = Remotes:WaitForChild("UpdateSubjects")
local startQuestRemote = Remotes:WaitForChild("StartQuest")
local answerQuestionRemote = Remotes:WaitForChild("AnswerQuestion")
local teleportRequest = Remotes:WaitForChild("TeleportRequest")
local notifyRemote = Remotes:WaitForChild("Notify")

local state = {
	profile = nil,
	selectedSet = {},
	mainSubject = nil,
	currentSession = nil,
	lastFeedback = nil,
	currentPanel = nil,
}

local gui = Instance.new("ScreenGui")
gui.Name = "IBRealmsGui"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = player:WaitForChild("PlayerGui")

local function colorToHex(color)
	return string.format("#%02X%02X%02X", math.floor(color.R * 255), math.floor(color.G * 255), math.floor(color.B * 255))
end

local function make(className, props, parent)
	local object = Instance.new(className)
	for key, value in pairs(props or {}) do
		object[key] = value
	end
	object.Parent = parent
	return object
end

local function corner(parent, radius)
	make("UICorner", { CornerRadius = UDim.new(0, radius or 12) }, parent)
end

local function stroke(parent, color, thickness)
	make("UIStroke", { Color = color or Color3.fromRGB(55, 220, 220), Thickness = thickness or 1, Transparency = 0.25 }, parent)
end

local function padding(parent, px)
	make("UIPadding", { PaddingTop = UDim.new(0, px), PaddingBottom = UDim.new(0, px), PaddingLeft = UDim.new(0, px), PaddingRight = UDim.new(0, px) }, parent)
end

local function label(parent, text, size, pos, textSize, color)
	return make("TextLabel", {
		Name = "Label",
		BackgroundTransparency = 1,
		Size = size,
		Position = pos or UDim2.fromScale(0, 0),
		Font = Enum.Font.GothamBold,
		Text = text,
		TextColor3 = color or Color3.fromRGB(235, 245, 255),
		TextSize = textSize or 18,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Center,
	}, parent)
end

local function button(parent, text, size, pos, accent)
	local b = make("TextButton", {
		Name = text:gsub("%W", "") .. "Button",
		Size = size,
		Position = pos or UDim2.fromScale(0, 0),
		BackgroundColor3 = Color3.fromRGB(18, 32, 48),
		Text = text,
		TextColor3 = Color3.fromRGB(245, 252, 255),
		Font = Enum.Font.GothamBold,
		TextSize = 16,
		AutoButtonColor = true,
	}, parent)
	corner(b, 10)
	stroke(b, accent or Color3.fromRGB(50, 220, 220), 1)
	return b
end

local function panel(name, size, pos)
	local f = make("Frame", {
		Name = name,
		Size = size,
		Position = pos,
		BackgroundColor3 = Color3.fromRGB(6, 12, 24),
		BackgroundTransparency = 0.06,
		Visible = false,
	}, gui)
	corner(f, 18)
	stroke(f, Color3.fromRGB(70, 220, 240), 2)
	padding(f, 16)
	return f
end

local hud = make("Frame", { Name = "HUD", Size = UDim2.new(1, 0, 0, 72), BackgroundColor3 = Color3.fromRGB(5, 10, 20), BackgroundTransparency = 0.15 }, gui)
local hudTitle = label(hud, "IB Realms", UDim2.new(0, 180, 1, 0), UDim2.fromOffset(16, 0), 24, Color3.fromRGB(45, 230, 230))
local hudStats = label(hud, "Loading profile...", UDim2.new(1, -220, 1, 0), UDim2.fromOffset(205, 0), 15)
hudStats.TextXAlignment = Enum.TextXAlignment.Left

local side = make("Frame", { Name = "SideMenu", Size = UDim2.fromOffset(145, 230), Position = UDim2.new(0, 18, 0.5, -85), BackgroundTransparency = 1 }, gui)
local sideLayout = make("UIListLayout", { Padding = UDim.new(0, 10), SortOrder = Enum.SortOrder.LayoutOrder }, side)

local notification = make("TextLabel", {
	Name = "Notification",
	Size = UDim2.fromOffset(420, 50),
	Position = UDim2.new(0.5, -210, 0, 84),
	BackgroundColor3 = Color3.fromRGB(8, 20, 34),
	Text = "",
	TextColor3 = Color3.fromRGB(235, 255, 255),
	Font = Enum.Font.GothamBold,
	TextSize = 16,
	Visible = false,
}, gui)
corner(notification, 12)
stroke(notification, Color3.fromRGB(50, 220, 220), 1)

local overlay = make("Frame", { Name = "TitleOverlay", Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.fromRGB(2, 6, 16), BackgroundTransparency = 1, ZIndex = 20 }, gui)
local overlayTitle = make("TextLabel", { Size = UDim2.fromOffset(600, 90), Position = UDim2.new(0.5, -300, 0.38, -45), BackgroundTransparency = 1, Font = Enum.Font.GothamBlack, Text = "IB Realms", TextColor3 = Color3.fromRGB(65, 240, 240), TextSize = 58, TextTransparency = 1, ZIndex = 21 }, overlay)
local overlaySub = make("TextLabel", { Size = UDim2.fromOffset(720, 44), Position = UDim2.new(0.5, -360, 0.48, 0), BackgroundTransparency = 1, Font = Enum.Font.Gotham, Text = "Build your profile, enter realms, unlock abilities.", TextColor3 = Color3.fromRGB(235, 245, 255), TextSize = 24, TextTransparency = 1, ZIndex = 21 }, overlay)

local dashboardPanel = panel("Dashboard", UDim2.new(0.86, 0, 0.78, 0), UDim2.new(0.07, 0, 0.13, 0))
local profilePanel = panel("IBProfile", UDim2.new(0.88, 0, 0.82, 0), UDim2.new(0.06, 0, 0.1, 0))
local subjectPanel = panel("SubjectPreview", UDim2.new(0.74, 0, 0.74, 0), UDim2.new(0.13, 0, 0.14, 0))
local topicPanel = panel("TopicMap", UDim2.new(0.76, 0, 0.64, 0), UDim2.new(0.12, 0, 0.2, 0))
local loadoutPanel = panel("Loadout", UDim2.new(0.72, 0, 0.7, 0), UDim2.new(0.14, 0, 0.16, 0))
local rankPanel = panel("RankHall", UDim2.new(0.72, 0, 0.7, 0), UDim2.new(0.14, 0, 0.16, 0))
local battlePanel = panel("QuestionBattle", UDim2.new(0.72, 0, 0.78, 0), UDim2.new(0.14, 0, 0.12, 0))

local panels = { dashboardPanel, profilePanel, subjectPanel, topicPanel, loadoutPanel, rankPanel, battlePanel }
local function clearChildren(container)
	for _, child in ipairs(container:GetChildren()) do
		if not child:IsA("UICorner") and not child:IsA("UIStroke") and not child:IsA("UIPadding") then
			child:Destroy()
		end
	end
end

local function showNotification(text)
	notification.Text = text
	notification.Visible = true
	notification.TextTransparency = 0
	notification.BackgroundTransparency = 0.08
	task.delay(2.6, function()
		if notification.Text == text then
			notification.Visible = false
		end
	end)
end

local function showPanel(target)
	for _, p in ipairs(panels) do
		p.Visible = p == target
	end
	state.currentPanel = target
end

local function closePanels()
	for _, p in ipairs(panels) do
		p.Visible = false
	end
	state.currentPanel = nil
end

local function refreshProfile()
	state.profile = getProfile:InvokeServer()
	state.selectedSet = {}
	for _, id in ipairs(state.profile.selectedSubjects or {}) do
		state.selectedSet[id] = true
	end
	state.mainSubject = state.profile.mainSubject
end

local function weakTopicsText(profile)
	local items = {}
	for key, count in pairs(profile.mistakes or {}) do
		table.insert(items, string.format("%s x%d", key, count))
	end
	table.sort(items)
	if #items == 0 then return "No weak topics logged yet." end
	return table.concat(items, "\n")
end

local function updateHud()
	local p = state.profile
	if not p then return end
	hudStats.Text = string.format("Rank: %s   Level: %d   XP: %d   Coins: %d   Accuracy: %d%%   Subjects: %d   Current: %s", p.overallRank or "Bronze", p.level or 1, p.xp or 0, p.coins or 0, p.accuracy or 100, #(p.selectedSubjects or {}), p.currentSubject or "Hub")
end

local function renderDashboard()
	clearChildren(dashboardPanel)
	label(dashboardPanel, "Dashboard // Holographic Mission Control", UDim2.new(1, -30, 0, 40), UDim2.fromOffset(18, 12), 24, Color3.fromRGB(65, 235, 235))
	local close = button(dashboardPanel, "Close", UDim2.fromOffset(90, 34), UDim2.new(1, -112, 0, 14), Color3.fromRGB(255, 100, 130))
	close.MouseButton1Click:Connect(closePanels)

	local left = make("Frame", { Size = UDim2.new(0.25, -12, 1, -70), Position = UDim2.fromOffset(18, 60), BackgroundColor3 = Color3.fromRGB(10, 20, 34) }, dashboardPanel)
	corner(left, 14); stroke(left, Color3.fromRGB(70, 220, 240), 1); padding(left, 12)
	label(left, string.format("%s\nOverall Rank: %s\nLevel %d  |  XP %d\nCoins: %d\nAccuracy: %d%%\nBadges: %d\nMain Realm: %s", player.DisplayName, state.profile.overallRank, state.profile.level, state.profile.xp, state.profile.coins, state.profile.accuracy, (function() local n=0 for _ in pairs(state.profile.badges or {}) do n+=1 end return n end)(), state.profile.mainSubject or "Optional later"), UDim2.new(1, 0, 0, 210), UDim2.fromOffset(0, 0), 16)
	label(left, "Weak Topics", UDim2.new(1, 0, 0, 28), UDim2.fromOffset(0, 225), 18, Color3.fromRGB(255, 190, 90))
	label(left, weakTopicsText(state.profile), UDim2.new(1, 0, 0, 120), UDim2.fromOffset(0, 258), 14, Color3.fromRGB(245, 230, 210))

	local middle = make("ScrollingFrame", { Size = UDim2.new(0.46, -12, 1, -70), Position = UDim2.new(0.26, 12, 0, 60), BackgroundColor3 = Color3.fromRGB(10, 18, 32), CanvasSize = UDim2.fromOffset(0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollBarThickness = 6 }, dashboardPanel)
	corner(middle, 14); stroke(middle, Color3.fromRGB(70, 220, 240), 1); padding(middle, 10)
	make("UIListLayout", { Padding = UDim.new(0, 10), SortOrder = Enum.SortOrder.LayoutOrder }, middle)
	if #(state.profile.selectedSubjects or {}) == 0 then
		label(middle, "No subjects selected yet. Open IB Profile and choose any number of your real IB subjects.", UDim2.new(1, -20, 0, 90), nil, 18, Color3.fromRGB(255, 215, 120))
	else
		for _, subjectId in ipairs(state.profile.selectedSubjects) do
			local subject = SubjectData.GetSubject(subjectId)
			if subject then
				local card = button(middle, "", UDim2.new(1, -10, 0, 112), nil, subject.color)
				card.Text = ""
				label(card, subject.name .. " // " .. subject.realmName, UDim2.new(1, -20, 0, 30), UDim2.fromOffset(12, 8), 18, subject.color)
				local progress = state.profile.subjectProgress[subjectId] or 0
				label(card, string.format("Rank: %s   Progress: %d%%\nRecommended: %s\nWeak-topic warning: %s", RankData.GetSubjectRank(subject.base, progress), progress, subject.recommendedQuest, progress < 10 and "Starter route ready" or "Review logged mistakes"), UDim2.new(1, -20, 0, 70), UDim2.fromOffset(12, 38), 14)
				card.MouseButton1Click:Connect(function() renderSubjectPreview(subjectId) end)
			end
		end
	end

	local right = make("Frame", { Size = UDim2.new(0.27, -18, 1, -70), Position = UDim2.new(0.73, 0, 0, 60), BackgroundColor3 = Color3.fromRGB(10, 20, 34) }, dashboardPanel)
	corner(right, 14); stroke(right, Color3.fromRGB(70, 220, 240), 1); padding(right, 12)
	local actions = { "Edit IB Profile", "Continue Recommended Quest", "Open Loadout", "Open Rank Hall", "Daily Quest Board", "Return to Hub" }
	for i, action in ipairs(actions) do
		local b = button(right, action, UDim2.new(1, 0, 0, 42), UDim2.fromOffset(0, (i - 1) * 50), Color3.fromRGB(65, 235, 235))
		b.MouseButton1Click:Connect(function()
			if action == "Edit IB Profile" then renderProfile() elseif action == "Open Loadout" then renderLoadout() elseif action == "Open Rank Hall" then renderRankHall() elseif action == "Return to Hub" then teleportRequest:FireServer("Hub"); closePanels() elseif action == "Continue Recommended Quest" then
				local subject = state.profile.selectedSubjects[1] and SubjectData.GetSubject(state.profile.selectedSubjects[1])
				if subject then startQuest(subject.recommendedQuest) else showNotification("Choose subjects first in IB Profile.") end
			else showNotification("Daily mission rotation is scaffolded; use Topic Map routes for repeatable practice.") end
		end)
	end
	showPanel(dashboardPanel)
end

function renderProfile()
	clearChildren(profilePanel)
	label(profilePanel, "IB Profile Builder // Choose any number of subjects", UDim2.new(1, -30, 0, 40), UDim2.fromOffset(18, 12), 24, Color3.fromRGB(65, 235, 235))
	local close = button(profilePanel, "Close", UDim2.fromOffset(90, 34), UDim2.new(1, -112, 0, 14), Color3.fromRGB(255, 100, 130))
	close.MouseButton1Click:Connect(closePanels)
	local scroller = make("ScrollingFrame", { Size = UDim2.new(0.68, -20, 1, -70), Position = UDim2.fromOffset(18, 60), BackgroundColor3 = Color3.fromRGB(10, 18, 32), CanvasSize = UDim2.fromOffset(0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollBarThickness = 6 }, profilePanel)
	corner(scroller, 14); stroke(scroller, Color3.fromRGB(70, 220, 240), 1); padding(scroller, 10)
	local layout = make("UIListLayout", { Padding = UDim.new(0, 12), SortOrder = Enum.SortOrder.LayoutOrder }, scroller)
	for _, category in ipairs(SubjectData.Categories) do
		local head = label(scroller, category.name .. "\n" .. category.description, UDim2.new(1, -18, 0, 62), nil, 18, category.color)
		head.LayoutOrder = category.id == "stem" and 1 or category.id == "individuals" and 20 or 40
		for _, subject in ipairs(SubjectData.GetSubjectsByCategory(category.id)) do
			local card = make("Frame", { Size = UDim2.new(1, -18, 0, 88), BackgroundColor3 = Color3.fromRGB(12, 24, 40), LayoutOrder = head.LayoutOrder + 1 }, scroller)
			corner(card, 12); stroke(card, subject.color, 1); padding(card, 10)
			label(card, subject.name .. " // " .. subject.realmName, UDim2.new(0.62, 0, 0, 26), UDim2.fromOffset(0, 0), 18, subject.color)
			label(card, subject.description, UDim2.new(0.62, 0, 0, 48), UDim2.fromOffset(0, 30), 13)
			local addRemove = button(card, state.selectedSet[subject.id] and "Remove" or "Add", UDim2.fromOffset(90, 34), UDim2.new(1, -212, 0, 12), subject.color)
			local preview = button(card, "Preview", UDim2.fromOffset(90, 34), UDim2.new(1, -108, 0, 12), subject.color)
			addRemove.MouseButton1Click:Connect(function()
				state.selectedSet[subject.id] = not state.selectedSet[subject.id]
				if state.selectedSet[subject.id] and not state.mainSubject then state.mainSubject = subject.id end
				if not state.selectedSet[state.mainSubject] then state.mainSubject = nil end
				renderProfile()
			end)
			preview.MouseButton1Click:Connect(function() renderSubjectPreview(subject.id) end)
		end
	end

	local selected = make("Frame", { Size = UDim2.new(0.29, 0, 1, -70), Position = UDim2.new(0.7, 0, 0, 60), BackgroundColor3 = Color3.fromRGB(10, 20, 34) }, profilePanel)
	corner(selected, 14); stroke(selected, Color3.fromRGB(70, 220, 240), 1); padding(selected, 12)
	label(selected, "Selected Subjects", UDim2.new(1, 0, 0, 30), UDim2.fromOffset(0, 0), 20, Color3.fromRGB(65, 235, 235))
	local y = 42
	local selectedIds = {}
	for subjectId, chosen in pairs(state.selectedSet) do if chosen then table.insert(selectedIds, subjectId) end end
	table.sort(selectedIds)
	for _, subjectId in ipairs(selectedIds) do
		local subject = SubjectData.GetSubject(subjectId)
		local b = button(selected, (state.mainSubject == subjectId and "★ " or "☆ ") .. subject.name, UDim2.new(1, 0, 0, 38), UDim2.fromOffset(0, y), subject.color)
		b.MouseButton1Click:Connect(function() state.mainSubject = subjectId; renderProfile() end)
		y += 44
	end
	local confirm = button(selected, "Confirm Profile", UDim2.new(1, 0, 0, 44), UDim2.new(0, 0, 1, -52), Color3.fromRGB(65, 235, 235))
	confirm.MouseButton1Click:Connect(function()
		local ids = {}
		for subjectId, chosen in pairs(state.selectedSet) do if chosen then table.insert(ids, subjectId) end end
		state.profile = updateSubjects:InvokeServer(ids, state.mainSubject)
		refreshProfile(); updateHud(); showNotification("IB profile saved."); renderDashboard()
	end)
	showPanel(profilePanel)
end

function renderSubjectPreview(subjectId)
	local subject = SubjectData.GetSubject(subjectId)
	if not subject then return end
	clearChildren(subjectPanel)
	label(subjectPanel, subject.realmName .. " // " .. subject.name, UDim2.new(1, -30, 0, 42), UDim2.fromOffset(18, 12), 25, subject.color)
	label(subjectPanel, subject.description, UDim2.new(0.58, 0, 0, 82), UDim2.fromOffset(18, 62), 16)
	local progress = state.profile and (state.profile.subjectProgress[subjectId] or 0) or 0
	label(subjectPanel, string.format("Current Rank: %s\nProgress: %d%%\nStarter Move: %s\nCombat Role: %s\nRecommended Quest: %s", RankData.GetSubjectRank(subject.base, progress), progress, subject.starterMove, subject.role, subject.recommendedQuest), UDim2.new(0.38, 0, 0, 150), UDim2.new(0.61, 0, 0, 64), 16, Color3.fromRGB(235, 245, 255))
	local topicBox = make("Frame", { Size = UDim2.new(1, -36, 0, 245), Position = UDim2.fromOffset(18, 160), BackgroundColor3 = Color3.fromRGB(10, 20, 34) }, subjectPanel)
	corner(topicBox, 14); stroke(topicBox, subject.color, 1); padding(topicBox, 10)
	label(topicBox, "Campaign Topic Path", UDim2.new(1, 0, 0, 28), UDim2.fromOffset(0, 0), 19, subject.color)
	local x = 10
	for index, topicId in ipairs(subject.topics) do
		local topic = SubjectData.Topics[topicId]
		local node = make("Frame", { Size = UDim2.fromOffset(150, 138), Position = UDim2.fromOffset(x, 48), BackgroundColor3 = index == 1 and Color3.fromRGB(16, 54, 62) or Color3.fromRGB(35, 38, 48) }, topicBox)
		corner(node, 14); stroke(node, index == 1 and subject.color or Color3.fromRGB(120, 125, 145), 1)
		label(node, tostring(index), UDim2.fromOffset(28, 28), UDim2.fromOffset(10, 8), 20, index == 1 and subject.color or Color3.fromRGB(190, 195, 210))
		label(node, topic.name, UDim2.new(1, -16, 0, 48), UDim2.fromOffset(8, 38), 14, Color3.fromRGB(235, 245, 255))
		label(node, index == 1 and "In Progress" or "Preview Locked", UDim2.new(1, -16, 0, 32), UDim2.fromOffset(8, 96), 13, index == 1 and Color3.fromRGB(90, 230, 130) or Color3.fromRGB(180, 180, 190))
		x += 164
	end
	local enter = button(subjectPanel, "Enter Preview", UDim2.fromOffset(150, 42), UDim2.new(0, 18, 1, -56), subject.color)
	local quest = button(subjectPanel, "Start Quest", UDim2.fromOffset(150, 42), UDim2.new(0, 184, 1, -56), subject.color)
	local topicMap = button(subjectPanel, "Topic Map", UDim2.fromOffset(150, 42), UDim2.new(0, 350, 1, -56), subject.color)
	local back = button(subjectPanel, "Back", UDim2.fromOffset(120, 42), UDim2.new(1, -140, 1, -56), Color3.fromRGB(255, 120, 140))
	enter.MouseButton1Click:Connect(function() teleportRequest:FireServer("PreviewZone", subject.previewZone); closePanels() end)
	quest.MouseButton1Click:Connect(function() startQuest(subject.recommendedQuest) end)
	topicMap.MouseButton1Click:Connect(function() renderTopicMap(subjectId) end)
	back.MouseButton1Click:Connect(renderDashboard)
	showPanel(subjectPanel)
end

function renderTopicMap(subjectId)
	local subject = SubjectData.GetSubject(subjectId)
	clearChildren(topicPanel)
	label(topicPanel, subject.name .. " Topic Map // campaign path, not a skill tree", UDim2.new(1, -30, 0, 42), UDim2.fromOffset(18, 12), 22, subject.color)
	local y = 70
	for index, topicId in ipairs(subject.topics) do
		local topic = SubjectData.Topics[topicId]
		local status = index == 1 and "Blue: in progress / starter quest available" or "Grey: campaign route available for structured practice"
		label(topicPanel, string.format("%d. %s — %s\n%s", index, topic.name, status, topic.summary), UDim2.new(1, -260, 0, 70), UDim2.fromOffset(24, y), 15, index == 1 and subject.color or Color3.fromRGB(190, 195, 210))
		local routeQuestId = subject.id .. "_" .. topicId .. "_route"
		local bossQuestId = subject.id .. "_" .. topicId .. "_boss"
		local routeButton = button(topicPanel, "Start Route", UDim2.fromOffset(110, 30), UDim2.new(1, -245, 0, y + 8), subject.color)
		local bossButton = button(topicPanel, "Boss", UDim2.fromOffset(90, 30), UDim2.new(1, -125, 0, y + 8), Color3.fromRGB(190, 130, 255))
		routeButton.MouseButton1Click:Connect(function() startQuest(routeQuestId) end)
		bossButton.MouseButton1Click:Connect(function() startQuest(bossQuestId) end)
		y += 78
	end
	local back = button(topicPanel, "Back", UDim2.fromOffset(120, 42), UDim2.new(1, -145, 1, -55), subject.color)
	back.MouseButton1Click:Connect(function() renderSubjectPreview(subjectId) end)
	showPanel(topicPanel)
end

function renderLoadout()
	clearChildren(loadoutPanel)
	label(loadoutPanel, "Loadout Forge // Four normal moves + one ultimate", UDim2.new(1, -30, 0, 42), UDim2.fromOffset(18, 12), 23, Color3.fromRGB(255, 170, 80))
	label(loadoutPanel, "Learning quests unlock abilities. Future PvE/PvP uses ability buttons, cooldowns, energy, hitboxes, and team utility.", UDim2.new(1, -40, 0, 48), UDim2.fromOffset(18, 58), 15)
	local scroller = make("ScrollingFrame", { Size = UDim2.new(1, -36, 1, -135), Position = UDim2.fromOffset(18, 112), BackgroundColor3 = Color3.fromRGB(10, 20, 34), AutomaticCanvasSize = Enum.AutomaticSize.Y, CanvasSize = UDim2.fromOffset(0, 0), ScrollBarThickness = 6 }, loadoutPanel)
	corner(scroller, 14); stroke(scroller, Color3.fromRGB(255, 170, 80), 1); padding(scroller, 10)
	make("UIListLayout", { Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder }, scroller)
	for _, move in ipairs(MoveData.Moves) do
		local unlocked = state.profile.unlockedMoves and state.profile.unlockedMoves[move.id]
		local row = make("Frame", { Size = UDim2.new(1, -12, 0, 78), BackgroundColor3 = unlocked and Color3.fromRGB(18, 44, 42) or Color3.fromRGB(30, 32, 42) }, scroller)
		corner(row, 10); stroke(row, unlocked and Color3.fromRGB(80, 240, 170) or Color3.fromRGB(95, 98, 115), 1); padding(row, 8)
		label(row, string.format("%s [%s | tier %d]  %s", move.name, move.category, move.tier, unlocked and "UNLOCKED" or "LOCKED"), UDim2.new(1, -20, 0, 28), UDim2.fromOffset(0, 0), 17, unlocked and Color3.fromRGB(100, 245, 180) or Color3.fromRGB(200, 205, 220))
		label(row, move.effect .. "\nUnlock: " .. move.unlockCondition, UDim2.new(1, -20, 0, 44), UDim2.fromOffset(0, 30), 13)
	end
	local back = button(loadoutPanel, "Back", UDim2.fromOffset(120, 42), UDim2.new(1, -145, 1, -55), Color3.fromRGB(255, 170, 80))
	back.MouseButton1Click:Connect(renderDashboard)
	showPanel(loadoutPanel)
end

function renderRankHall()
	clearChildren(rankPanel)
	label(rankPanel, "Rank Hall // Aspirational progression preview", UDim2.new(1, -30, 0, 42), UDim2.fromOffset(18, 12), 23, Color3.fromRGB(190, 130, 255))
	label(rankPanel, "Overall ranks: Bronze, Silver, Gold, Platinum, Diamond, Master, IB Champion. Subject ranks are themed by realm.", UDim2.new(1, -36, 0, 48), UDim2.fromOffset(18, 58), 15)
	local y = 115
	for _, subjectId in ipairs(state.profile.selectedSubjects or {}) do
		local subject = SubjectData.GetSubject(subjectId)
		local progress = state.profile.subjectProgress[subjectId] or 0
		label(rankPanel, string.format("%s — %s (%d%%)", subject.name, RankData.GetSubjectRank(subject.base, progress), progress), UDim2.new(1, -40, 0, 34), UDim2.fromOffset(24, y), 17, subject.color)
		y += 38
	end
	if y == 115 then
		label(rankPanel, "No selected subjects yet. Open IB Profile to start ranking.", UDim2.new(1, -40, 0, 40), UDim2.fromOffset(24, y), 17, Color3.fromRGB(255, 215, 120))
	end
	local back = button(rankPanel, "Back", UDim2.fromOffset(120, 42), UDim2.new(1, -145, 1, -55), Color3.fromRGB(190, 130, 255))
	back.MouseButton1Click:Connect(renderDashboard)
	showPanel(rankPanel)
end

local function renderBattle(session, feedback, reward)
	state.currentSession = session
	clearChildren(battlePanel)
	local q = session.question
	label(battlePanel, session.quest.title .. " // " .. session.quest.enemyName, UDim2.new(1, -30, 0, 38), UDim2.fromOffset(18, 12), 22, Color3.fromRGB(65, 235, 235))
	label(battlePanel, string.format("Enemy HP: %d/%d   Focus: %d   Challenge: %d/%d", session.enemyHP, session.maxEnemyHP, session.focus, session.questionIndex, session.questionTotal), UDim2.new(1, -36, 0, 30), UDim2.fromOffset(18, 54), 16, Color3.fromRGB(235, 245, 255))
	if feedback then
		local feedbackColor = feedback.correct and Color3.fromRGB(90, 240, 140) or Color3.fromRGB(255, 110, 120)
		label(battlePanel, (feedback.correct and "Correct" or "Wrong") .. " // " .. feedback.explanation .. "\nCommon mistake: " .. feedback.commonMistake, UDim2.new(1, -36, 0, 92), UDim2.fromOffset(18, 88), 15, feedbackColor)
	end
	if reward then
		label(battlePanel, string.format("Quest complete! +%d XP  +%d coins%s%s%s", reward.xp, reward.coins, reward.moveUnlock and ("  Move: " .. reward.moveUnlock) or "", reward.badgeUnlock and ("  Badge: " .. reward.badgeUnlock) or "", reward.tokenUnlock and ("  Token: " .. reward.tokenUnlock) or ""), UDim2.new(1, -36, 0, 70), UDim2.fromOffset(18, 184), 17, Color3.fromRGB(255, 215, 100))
		if reward.profile then state.profile = reward.profile; updateHud() end
		local dash = button(battlePanel, "Open Dashboard", UDim2.fromOffset(170, 44), UDim2.new(0, 18, 1, -60), Color3.fromRGB(65, 235, 235))
		local hub = button(battlePanel, "Return Hub", UDim2.fromOffset(150, 44), UDim2.new(0, 205, 1, -60), Color3.fromRGB(65, 235, 235))
		dash.MouseButton1Click:Connect(function() refreshProfile(); updateHud(); renderDashboard() end)
		hub.MouseButton1Click:Connect(function() teleportRequest:FireServer("Hub"); closePanels() end)
		showPanel(battlePanel)
		return
	end
	if not q then
		label(battlePanel, "No next question. Open Dashboard to continue.", UDim2.new(1, -36, 0, 80), UDim2.fromOffset(18, 200), 18)
		showPanel(battlePanel)
		return
	end
	local top = feedback and 195 or 94
	label(battlePanel, string.format("Topic: %s   Difficulty: %d   Command term: %s", q.topicId, q.difficulty, q.commandTerm), UDim2.new(1, -36, 0, 28), UDim2.fromOffset(18, top), 15, Color3.fromRGB(145, 220, 255))
	label(battlePanel, q.prompt, UDim2.new(1, -36, 0, 88), UDim2.fromOffset(18, top + 34), 19, Color3.fromRGB(245, 250, 255))
	if q.type == "multiple_choice" then
		for i, optionText in ipairs(q.options) do
			local b = button(battlePanel, string.char(64 + i) .. ". " .. optionText, UDim2.new(0.46, 0, 0, 50), UDim2.new(i % 2 == 1 and 0 or 0.5, i % 2 == 1 and 18 or -2, 0, top + 132 + math.floor((i - 1) / 2) * 60), Color3.fromRGB(65, 235, 235))
			b.TextXAlignment = Enum.TextXAlignment.Left
			b.MouseButton1Click:Connect(function()
				local response = answerQuestionRemote:InvokeServer(i)
				if response.ok then renderBattle(response.result.session, response.result.feedback, response.result.reward) else showNotification(response.error) end
			end)
		end
	else
		local box = make("TextBox", { Size = UDim2.new(1, -36, 0, 82), Position = UDim2.fromOffset(18, top + 132), BackgroundColor3 = Color3.fromRGB(12, 24, 40), Text = "", PlaceholderText = "Type key ideas here...", TextColor3 = Color3.fromRGB(245, 250, 255), Font = Enum.Font.Gotham, TextSize = 17, TextWrapped = true, ClearTextOnFocus = false }, battlePanel)
		corner(box, 10); stroke(box, Color3.fromRGB(65, 235, 235), 1)
		local submit = button(battlePanel, "Submit / Attack", UDim2.fromOffset(170, 44), UDim2.fromOffset(18, top + 228), Color3.fromRGB(65, 235, 235))
		submit.MouseButton1Click:Connect(function()
			local response = answerQuestionRemote:InvokeServer(box.Text)
			if response.ok then renderBattle(response.result.session, response.result.feedback, response.result.reward) else showNotification(response.error) end
		end)
	end
	showPanel(battlePanel)
end

function startQuest(questId)
	local response = startQuestRemote:InvokeServer(questId)
	if response.ok then
		renderBattle(response.session)
	else
		showNotification(response.error or "Could not start quest.")
	end
end

local sideButtons = {
	{ text = "Dashboard", action = function() refreshProfile(); updateHud(); renderDashboard() end },
	{ text = "IB Profile", action = function() refreshProfile(); renderProfile() end },
	{ text = "Loadout", action = function() refreshProfile(); renderLoadout() end },
	{ text = "Return Hub", action = function() teleportRequest:FireServer("Hub"); closePanels() end },
}
for i, item in ipairs(sideButtons) do
	local b = button(side, item.text, UDim2.new(1, 0, 0, 44), nil, Color3.fromRGB(65, 235, 235))
	b.LayoutOrder = i
	b.MouseButton1Click:Connect(item.action)
end

ProximityPromptService.PromptTriggered:Connect(function(prompt, triggeringPlayer)
	if triggeringPlayer ~= player then return end
	local kind = prompt:GetAttribute("IBPromptKind")
	local targetId = prompt:GetAttribute("TargetId")
	refreshProfile(); updateHud()
	if kind == "Dashboard" then renderDashboard()
	elseif kind == "IBProfile" then renderProfile()
	elseif kind == "Loadout" then renderLoadout()
	elseif kind == "RankHall" then renderRankHall()
	elseif kind == "SubjectPreview" then renderSubjectPreview(targetId)
	elseif kind == "StartQuest" then startQuest(targetId)
	elseif kind == "Category" then showNotification("Open IB Profile to choose " .. tostring(targetId) .. " subjects, or use subject preview pads around the Nexus Core.")
	elseif kind == "PvPPreview" then showNotification("PvP preview: Arena Duel, Team Realm Clash, and Boss Race are planned after the learning loop.")
	end
end)

notifyRemote.OnClientEvent:Connect(showNotification)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.LeftShift or input.KeyCode == Enum.KeyCode.RightShift then
		local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
		if humanoid then humanoid.WalkSpeed = GameConfig.SprintWalkSpeed end
	end
end)
UserInputService.InputEnded:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.LeftShift or input.KeyCode == Enum.KeyCode.RightShift then
		local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
		if humanoid then humanoid.WalkSpeed = GameConfig.NormalWalkSpeed end
	end
end)

local function playIntro()
	overlay.BackgroundTransparency = 1
	overlayTitle.TextTransparency = 1
	overlaySub.TextTransparency = 1
	TweenService:Create(overlay, TweenInfo.new(0.35), { BackgroundTransparency = 0.18 }):Play()
	TweenService:Create(overlayTitle, TweenInfo.new(0.45), { TextTransparency = 0 }):Play()
	TweenService:Create(overlaySub, TweenInfo.new(0.55), { TextTransparency = 0 }):Play()
	task.wait(2.1)
	TweenService:Create(overlay, TweenInfo.new(0.55), { BackgroundTransparency = 1 }):Play()
	TweenService:Create(overlayTitle, TweenInfo.new(0.45), { TextTransparency = 1 }):Play()
	TweenService:Create(overlaySub, TweenInfo.new(0.45), { TextTransparency = 1 }):Play()
	task.wait(0.6)
	overlay.Visible = false
end

refreshProfile()
updateHud()
task.spawn(playIntro)
task.delay(2.8, function()
	refreshProfile(); updateHud()
	if not state.profile.onboardingComplete then
		renderProfile()
	else
		renderDashboard()
	end
end)
