local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local ProximityPromptService = game:GetService("ProximityPromptService")

local player = Players.LocalPlayer
local IBRealms = ReplicatedStorage:WaitForChild("IBRealms")
local Remotes = IBRealms:WaitForChild("Remotes")
local Subjects = require(IBRealms.Data.SubjectData)
local Moves = require(IBRealms.Data.MoveData)
local Config = require(IBRealms.Data.GameConfig)
local QuestService = require(IBRealms.Services.QuestService)

local RequestProfile = Remotes:WaitForChild("RequestProfile")
local SetSubjects = Remotes:WaitForChild("SetSubjects")
local SetActiveSubject = Remotes:WaitForChild("SetActiveSubject")
local StartQuestRemote = Remotes:WaitForChild("StartQuest")
local SubmitAnswer = Remotes:WaitForChild("SubmitAnswer")
local TeleportTo = Remotes:WaitForChild("TeleportTo")
local ProfileUpdated = Remotes:WaitForChild("ProfileUpdated")

local profile = RequestProfile:InvokeServer()
local currentQuestion, currentQuest = nil, nil
local selectedDraft = {}

local gui = Instance.new("ScreenGui")
gui.Name = "IBRealmsGui"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local function make(class, props, parent)
	local o = Instance.new(class)
	for k, v in pairs(props or {}) do o[k] = v end
	o.Parent = parent
	return o
end
local function button(text, parent)
	local b = make("TextButton", {Text=text, Font=Enum.Font.GothamBold, TextScaled=true, TextColor3=Color3.new(1,1,1), BackgroundColor3=Color3.fromRGB(35,45,65), BorderSizePixel=0, AutoButtonColor=true}, parent)
	make("UICorner", {CornerRadius=UDim.new(0,10)}, b)
	return b
end
local function label(text, parent, size)
	return make("TextLabel", {Text=text, Font=Enum.Font.Gotham, TextSize=size or 18, TextWrapped=true, TextXAlignment=Enum.TextXAlignment.Left, TextYAlignment=Enum.TextYAlignment.Top, TextColor3=Color3.fromRGB(235,245,255), BackgroundTransparency=1}, parent)
end
local function panel(name, pos, size)
	local f = make("Frame", {Name=name, Position=pos, Size=size, BackgroundColor3=Color3.fromRGB(13,18,30), BackgroundTransparency=.05, BorderSizePixel=0, Visible=false}, gui)
	make("UICorner", {CornerRadius=UDim.new(0,16)}, f)
	make("UIStroke", {Color=Config.Colors.Nexus, Thickness=1, Transparency=.25}, f)
	return f
end
local function clear(frame)
	for _, c in ipairs(frame:GetChildren()) do if not c:IsA("UICorner") and not c:IsA("UIStroke") and not c:IsA("UIListLayout") and not c:IsA("UIPadding") then c:Destroy() end end
end
local function hasSubject(id)
	for _, sid in ipairs(selectedDraft) do if sid == id then return true end end
	return false
end
local function hideAll()
	for _, c in ipairs(gui:GetChildren()) do if c:IsA("Frame") and c.Name ~= "HUD" and c.Name ~= "SideMenu" then c.Visible = false end end
end

local hud = make("Frame", {Name="HUD", Position=UDim2.fromOffset(14,12), Size=UDim2.fromOffset(520,64), BackgroundColor3=Color3.fromRGB(10,15,26), BackgroundTransparency=.08, BorderSizePixel=0}, gui)
make("UICorner", {CornerRadius=UDim.new(0,12)}, hud)
local hudText = label("", hud, 16); hudText.Size = UDim2.fromScale(.98,.9); hudText.Position = UDim2.fromOffset(10,7)

local side = make("Frame", {Name="SideMenu", AnchorPoint=Vector2.new(1,0), Position=UDim2.new(1,-14,0,92), Size=UDim2.fromOffset(150,206), BackgroundTransparency=1}, gui)
make("UIListLayout", {Padding=UDim.new(0,8)}, side)
local dashboardBtn = button("Dashboard", side); dashboardBtn.Size = UDim2.fromOffset(150,42)
local profileBtn = button("IB Profile", side); profileBtn.Size = UDim2.fromOffset(150,42)
local loadoutBtn = button("Loadout", side); loadoutBtn.Size = UDim2.fromOffset(150,42)
local hubBtn = button("Return Hub", side); hubBtn.Size = UDim2.fromOffset(150,42)

local subjectPanel = panel("SubjectSelection", UDim2.fromScale(.08,.08), UDim2.fromScale(.78,.82))
local dashboardPanel = panel("Dashboard", UDim2.fromScale(.12,.1), UDim2.fromScale(.70,.76))
local previewPanel = panel("SubjectPreview", UDim2.fromScale(.18,.14), UDim2.fromScale(.58,.68))
local topicPanel = panel("TopicMap", UDim2.fromScale(.18,.14), UDim2.fromScale(.58,.68))
local questionPanel = panel("Question", UDim2.fromScale(.16,.12), UDim2.fromScale(.62,.76))
local loadoutPanel = panel("Loadout", UDim2.fromScale(.18,.14), UDim2.fromScale(.58,.68))
local dialogPanel = panel("Dialogue", UDim2.fromScale(.22,.62), UDim2.fromScale(.56,.25))

local function updateHud()
	local count = #(profile.SelectedSubjects or {})
	hudText.Text = string.format("IB Realms  |  Rank: %s  |  Level: %d  |  XP: %d  |  Coins: %d  |  Accuracy: %d%%  |  Subjects: %d", profile.Rank or "Bronze", profile.Level or 1, profile.XP or 0, profile.Coins or 0, profile.Accuracy or 0, count)
end

local function subjectListByCategory()
	local cats = {STEM={}, ["Individuals & Societies"]={}, Languages={}}
	for id, s in pairs(Subjects) do table.insert(cats[s.Category], {Id=id, Data=s}) end
	for _, list in pairs(cats) do table.sort(list, function(a,b) return a.Data.Name < b.Data.Name end) end
	return cats
end

local function openSubjectSelection()
	hideAll(); subjectPanel.Visible = true; clear(subjectPanel)
	label("Choose Your IB Subjects", subjectPanel, 30).Size = UDim2.new(1,-30,0,42)
	local scroll = make("ScrollingFrame", {Position=UDim2.fromOffset(18,58), Size=UDim2.new(.68,-24,1,-78), CanvasSize=UDim2.fromOffset(0,0), AutomaticCanvasSize=Enum.AutomaticSize.Y, BackgroundTransparency=1, BorderSizePixel=0, ScrollBarThickness=8}, subjectPanel)
	make("UIListLayout", {Padding=UDim.new(0,10)}, scroll)
	local selectedBox = make("Frame", {Position=UDim2.new(.70,10,0,58), Size=UDim2.new(.28,-26,1,-78), BackgroundColor3=Color3.fromRGB(20,28,44), BorderSizePixel=0}, subjectPanel); make("UICorner", {CornerRadius=UDim.new(0,12)}, selectedBox)
	local selectedText = label("Selected subjects appear here. You may choose any number; exactly six is not required.", selectedBox, 17); selectedText.Position=UDim2.fromOffset(12,12); selectedText.Size=UDim2.new(1,-24,1,-84)
	local confirm = button("Confirm Profile", selectedBox); confirm.Position=UDim2.new(0,12,1,-58); confirm.Size=UDim2.new(1,-24,0,44)
	local function refreshSelected()
		local names = {}
		for _, id in ipairs(selectedDraft) do table.insert(names, "• "..Subjects[id].Name) end
		selectedText.Text = (#names > 0 and table.concat(names, "\n") or "No subjects selected yet. Pick one or more subjects to begin.")
	end
	for cat, list in pairs(subjectListByCategory()) do
		local h = label(cat, scroll, 24); h.Size = UDim2.new(1,-8,0,30); h.TextColor3 = Config.Colors.Nexus
		for _, item in ipairs(list) do
			local s = item.Data
			local card = make("Frame", {Size=UDim2.new(1,-8,0,92), BackgroundColor3=Color3.fromRGB(22,30,46), BorderSizePixel=0}, scroll); make("UICorner", {CornerRadius=UDim.new(0,12)}, card); make("UIStroke", {Color=s.Color, Transparency=.35}, card)
			local txt = label(s.Name.." — "..s.Realm.."\n"..s.Description.."\nStarter move: "..Moves[s.StarterMove].Name, card, 15); txt.Position=UDim2.fromOffset(12,8); txt.Size=UDim2.new(1,-150,1,-14)
			local add = button(hasSubject(item.Id) and "Remove" or "Add", card); add.Position=UDim2.new(1,-124,0,24); add.Size=UDim2.fromOffset(104,42)
			add.MouseButton1Click:Connect(function()
				if hasSubject(item.Id) then for i, id in ipairs(selectedDraft) do if id == item.Id then table.remove(selectedDraft, i); break end end else table.insert(selectedDraft, item.Id) end
				openSubjectSelection()
			end)
		end
	end
	confirm.MouseButton1Click:Connect(function()
		profile = SetSubjects:InvokeServer(selectedDraft, nil)
		updateHud()
		openDashboard()
	end)
	refreshSelected()
end

function openDashboard()
	hideAll(); dashboardPanel.Visible = true; clear(dashboardPanel)
	label("Dashboard — Mission Control", dashboardPanel, 30).Position=UDim2.fromOffset(18,14)
	local left = make("Frame", {Position=UDim2.fromOffset(18,62), Size=UDim2.new(.28,-22,1,-84), BackgroundColor3=Color3.fromRGB(20,28,44), BorderSizePixel=0}, dashboardPanel); make("UICorner", {CornerRadius=UDim.new(0,12)}, left)
	local stats = label(string.format("Rank: %s\nLevel: %d\nXP: %d\nCoins: %d\nAccuracy: %d%%", profile.Rank, profile.Level, profile.XP, profile.Coins, profile.Accuracy), left, 20); stats.Position=UDim2.fromOffset(14,14); stats.Size=UDim2.new(1,-28,0,135)
	local weakLines = {"\nWeak topics:"}
	for i, w in ipairs(profile.WeakTopics or {}) do if i <= 5 then table.insert(weakLines, string.format("• %s (%d%%)", w.Tag, w.Score)) end end
	local weakLabel = label(table.concat(weakLines,"\n"), left, 16); weakLabel.Position=UDim2.fromOffset(14,160); weakLabel.Size=UDim2.new(1,-28,0,150)
	local middle = make("ScrollingFrame", {Position=UDim2.new(.30,0,0,62), Size=UDim2.new(.48,-8,1,-84), AutomaticCanvasSize=Enum.AutomaticSize.Y, CanvasSize=UDim2.fromOffset(0,0), BackgroundTransparency=1, BorderSizePixel=0}, dashboardPanel); make("UIListLayout", {Padding=UDim.new(0,10)}, middle)
	for _, id in ipairs(profile.SelectedSubjects or {}) do
		local s = Subjects[id]
		local card = make("Frame", {Size=UDim2.new(1,-8,0,112), BackgroundColor3=Color3.fromRGB(22,30,46), BorderSizePixel=0}, middle); make("UICorner", {CornerRadius=UDim.new(0,12)}, card); make("UIStroke", {Color=s.Color, Transparency=.35}, card)
		local progress = (profile.SubjectProgress and profile.SubjectProgress[id]) or 0
		label(s.Name.."\n"..s.Realm.." | Progress: "..progress.."%\nRecommended: "..(QuestService.GetRecommendedQuest(id, profile.CompletedQuests or {}) or {}).Name, card, 16).Position=UDim2.fromOffset(12,10)
		local open = button("Preview", card); open.Position=UDim2.new(1,-128,0,34); open.Size=UDim2.fromOffset(110,42)
		open.MouseButton1Click:Connect(function() SetActiveSubject:InvokeServer(id); openPreview(id) end)
	end
	local right = make("Frame", {Position=UDim2.new(.79,0,0,62), Size=UDim2.new(.20,-18,1,-84), BackgroundTransparency=1}, dashboardPanel); make("UIListLayout", {Padding=UDim.new(0,10)}, right)
	local edit = button("Edit IB Profile", right); edit.Size=UDim2.new(1,0,0,46); edit.MouseButton1Click:Connect(openSubjectSelection)
	local load = button("Open Loadout", right); load.Size=UDim2.new(1,0,0,46); load.MouseButton1Click:Connect(openLoadout)
	local close = button("Close", right); close.Size=UDim2.new(1,0,0,46); close.MouseButton1Click:Connect(hideAll)
end

function openPreview(subjectId)
	local s = Subjects[subjectId]; if not s then return end
	hideAll(); previewPanel.Visible = true; clear(previewPanel)
	label(s.Name.." — "..s.Realm, previewPanel, 30).Position=UDim2.fromOffset(18,16)
	local info = label(s.Description.."\n\nRole: "..s.Role.."\nStarter move: "..Moves[s.StarterMove].Name.."\nProgress: "..(((profile.SubjectProgress or {})[subjectId]) or 0).."%\nRecommended quest: "..(QuestService.GetRecommendedQuest(subjectId, profile.CompletedQuests or {}) or {}).Name, previewPanel, 19); info.Position=UDim2.fromOffset(22,72); info.Size=UDim2.new(1,-44,0,220)
	local enter = button("Enter Preview", previewPanel); enter.Position=UDim2.fromOffset(30,330); enter.Size=UDim2.fromOffset(170,50); enter.MouseButton1Click:Connect(function() TeleportTo:FireServer("Subject", subjectId); hideAll() end)
	local start = button("Start Quest", previewPanel); start.Position=UDim2.fromOffset(220,330); start.Size=UDim2.fromOffset(170,50); start.MouseButton1Click:Connect(function() openDialogue(subjectId) end)
	local map = button("Topic Map", previewPanel); map.Position=UDim2.fromOffset(410,330); map.Size=UDim2.fromOffset(170,50); map.MouseButton1Click:Connect(function() openTopicMap(subjectId) end)
	local back = button("Back", previewPanel); back.Position=UDim2.fromOffset(600,330); back.Size=UDim2.fromOffset(120,50); back.MouseButton1Click:Connect(openDashboard)
end

function openTopicMap(subjectId)
	local s = Subjects[subjectId]; hideAll(); topicPanel.Visible = true; clear(topicPanel)
	label("Topic Map — "..s.Name, topicPanel, 30).Position=UDim2.fromOffset(18,16)
	local list = make("ScrollingFrame", {Position=UDim2.fromOffset(24,72), Size=UDim2.new(1,-48,1,-140), AutomaticCanvasSize=Enum.AutomaticSize.Y, CanvasSize=UDim2.fromOffset(0,0), BackgroundTransparency=1, BorderSizePixel=0}, topicPanel); make("UIListLayout", {Padding=UDim.new(0,10)}, list)
	for _, t in ipairs(s.Topics) do
		local node = make("Frame", {Size=UDim2.new(1,-8,0,78), BackgroundColor3=Color3.fromRGB(22,30,46), BorderSizePixel=0}, list); make("UICorner", {CornerRadius=UDim.new(0,12)}, node); make("UIStroke", {Color=s.Color, Transparency=.35}, node)
		label(t.Order..". "..t.Name.."\n"..t.Description, node, 17).Position=UDim2.fromOffset(14,10)
	end
	local back = button("Back", topicPanel); back.Position=UDim2.new(1,-150,1,-58); back.Size=UDim2.fromOffset(120,44); back.MouseButton1Click:Connect(function() openPreview(subjectId) end)
end

function openLoadout()
	hideAll(); loadoutPanel.Visible = true; clear(loadoutPanel)
	label("Loadout Forge — 4 normal moves + 1 ultimate later", loadoutPanel, 28).Position=UDim2.fromOffset(18,16)
	local list = make("ScrollingFrame", {Position=UDim2.fromOffset(24,70), Size=UDim2.new(1,-48,1,-96), AutomaticCanvasSize=Enum.AutomaticSize.Y, CanvasSize=UDim2.fromOffset(0,0), BackgroundTransparency=1, BorderSizePixel=0}, loadoutPanel); make("UIListLayout", {Padding=UDim.new(0,10)}, list)
	for id, m in pairs(Moves) do
		local unlocked = profile.UnlockedMoves and profile.UnlockedMoves[id]
		local card = make("Frame", {Size=UDim2.new(1,-8,0,82), BackgroundColor3=unlocked and Color3.fromRGB(30,55,42) or Color3.fromRGB(34,34,42), BorderSizePixel=0}, list); make("UICorner", {CornerRadius=UDim.new(0,12)}, card)
		label((unlocked and "UNLOCKED: " or "LOCKED: ")..m.Name.." ["..m.Category.."]\n"..m.Description.."\nRequirement: "..m.UnlockRequirement, card, 15).Position=UDim2.fromOffset(12,8)
	end
end

function openDialogue(subjectId)
	hideAll(); dialogPanel.Visible = true; clear(dialogPanel)
	local s = Subjects[subjectId]
	local dtext = label("Guide: The "..s.Realm.." has an unstable learning node. You can hear the story later, or skip straight to the objective.", dialogPanel, 18); dtext.Position=UDim2.fromOffset(18,16); dtext.Size=UDim2.new(1,-36,0,86)
	local start = button("Start Quest", dialogPanel); start.Position=UDim2.new(0,18,1,-58); start.Size=UDim2.fromOffset(150,42); start.MouseButton1Click:Connect(function() startQuest(subjectId) end)
	local skip = button("Skip", dialogPanel); skip.Position=UDim2.new(0,184,1,-58); skip.Size=UDim2.fromOffset(110,42); skip.MouseButton1Click:Connect(function() startQuest(subjectId) end)
	local leave = button("Leave", dialogPanel); leave.Position=UDim2.new(1,-132,1,-58); leave.Size=UDim2.fromOffset(110,42); leave.MouseButton1Click:Connect(hideAll)
end

function renderQuestion(feedback)
	hideAll(); questionPanel.Visible = true; clear(questionPanel)
	local q = currentQuestion; if not q then return end
	local header = label((currentQuest and currentQuest.Name or "Quest").."\nEnemy: "..(currentQuest.Enemy and currentQuest.Enemy.Name or "Enemy"), questionPanel, 23); header.Position=UDim2.fromOffset(18,14); header.Size=UDim2.new(1,-36,0,58)
	local promptLabel = label(q.TopicName.." | Difficulty "..q.Difficulty.." | "..q.CommandTerm.." | "..q.QuestionType.."\n\n"..q.Prompt, questionPanel, 19); promptLabel.Position=UDim2.fromOffset(22,82); promptLabel.Size=UDim2.new(1,-44,0,150)
	local y = 240
	local answerBox
	if q.Options then
		for i, opt in ipairs(q.Options) do
			local letter = string.char(64+i)
			local b = button(letter..". "..opt, questionPanel); b.Position=UDim2.fromOffset(34,y); b.Size=UDim2.new(1,-68,0,42); y += 50
			b.MouseButton1Click:Connect(function() submit(letter) end)
		end
	else
		answerBox = make("TextBox", {PlaceholderText="Type your answer here", Text="", Font=Enum.Font.Gotham, TextSize=18, TextColor3=Color3.new(1,1,1), BackgroundColor3=Color3.fromRGB(25,34,52), Size=UDim2.new(1,-68,0,48), Position=UDim2.fromOffset(34,y), ClearTextOnFocus=false}, questionPanel); make("UICorner", {CornerRadius=UDim.new(0,10)}, answerBox); y += 60
		local submitBtn = button("Submit / Attack", questionPanel); submitBtn.Position=UDim2.fromOffset(34,y); submitBtn.Size=UDim2.fromOffset(190,44); submitBtn.MouseButton1Click:Connect(function() submit(answerBox.Text) end)
	end
	if feedback then
		local fb = label((feedback.Correct and "Correct!" or "Wrong — weakness logged.").."\n"..(feedback.Explanation or "").."\nCommon mistake: "..(feedback.CommonMistake or "").."\nXP gained: "..tostring(feedback.XP or 0), questionPanel, 16)
		fb.Position=UDim2.fromOffset(34, y + 18); fb.Size=UDim2.new(1,-68,0,150); fb.TextColor3 = feedback.Correct and Color3.fromRGB(130,255,170) or Color3.fromRGB(255,150,130)
	end
end

function startQuest(subjectId)
	local result = StartQuestRemote:InvokeServer(subjectId)
	if result.Error then warn(result.Error); return end
	currentQuest = result.Quest; currentQuestion = result.Question
	renderQuestion(nil)
end

function submit(answer)
	local result = SubmitAnswer:InvokeServer(answer)
	if result.Error then warn(result.Error); return end
	profile = result.Profile or profile; updateHud()
	if result.Complete then
		currentQuestion = nil
		renderQuestion(result.Feedback)
		task.delay(1.2, function()
			hideAll(); dialogPanel.Visible = true; clear(dialogPanel)
			label("Quest complete! Rewards applied. Check your Dashboard and Loadout Forge for progress and move unlocks.", dialogPanel, 20).Position=UDim2.fromOffset(18,18)
			local d = button("Dashboard", dialogPanel); d.Position=UDim2.fromOffset(18,112); d.Size=UDim2.fromOffset(150,42); d.MouseButton1Click:Connect(openDashboard)
			local l = button("Loadout", dialogPanel); l.Position=UDim2.fromOffset(184,112); l.Size=UDim2.fromOffset(130,42); l.MouseButton1Click:Connect(openLoadout)
		end)
	else
		currentQuestion = result.NextQuestion
		renderQuestion(result.Feedback)
	end
end

ProfileUpdated.OnClientEvent:Connect(function(newProfile) profile = newProfile; updateHud() end)
dashboardBtn.MouseButton1Click:Connect(openDashboard)
profileBtn.MouseButton1Click:Connect(function() selectedDraft = table.clone(profile.SelectedSubjects or {}); openSubjectSelection() end)
loadoutBtn.MouseButton1Click:Connect(openLoadout)
hubBtn.MouseButton1Click:Connect(function() TeleportTo:FireServer("Hub"); hideAll() end)

UserInputService.InputBegan:Connect(function(input, processed)
	if processed then return end
	if input.KeyCode == Enum.KeyCode.LeftShift or input.KeyCode == Enum.KeyCode.RightShift then
		local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
		if hum then hum.WalkSpeed = Config.SprintWalkSpeed end
	end
end)
UserInputService.InputEnded:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.LeftShift or input.KeyCode == Enum.KeyCode.RightShift then
		local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
		if hum then hum.WalkSpeed = Config.DefaultWalkSpeed end
	end
end)

ProximityPromptService.PromptTriggered:Connect(function(prompt, who)
	if who ~= player then return end
	local action = prompt:GetAttribute("IBAction")
	local subjectId = prompt:GetAttribute("SubjectId") or (profile.ActiveSubject or (profile.SelectedSubjects or {})[1])
	if action == "Dashboard" then openDashboard()
	elseif action == "Profile" then selectedDraft = table.clone(profile.SelectedSubjects or {}); openSubjectSelection()
	elseif action == "Loadout" then openLoadout()
	elseif action == "ReturnHub" then TeleportTo:FireServer("Hub")
	elseif action == "StartQuest" then openDialogue(subjectId)
	elseif action and string.sub(action,1,8) == "Category" then selectedDraft = table.clone(profile.SelectedSubjects or {}); openSubjectSelection()
	else
		hideAll(); dialogPanel.Visible = true; clear(dialogPanel)
		label("Welcome to IB Realms. Choose subjects, follow recommended quests, and let learning unlock power. Use the Dashboard or IB Profile to begin.", dialogPanel, 19).Position=UDim2.fromOffset(18,18)
		local b = button("Open Dashboard", dialogPanel); b.Position=UDim2.fromOffset(18,112); b.Size=UDim2.fromOffset(170,42); b.MouseButton1Click:Connect(openDashboard)
	end
end)

profile = RequestProfile:InvokeServer(); updateHud()
if #(profile.SelectedSubjects or {}) == 0 then selectedDraft = {}; task.defer(openSubjectSelection) else task.defer(openDashboard) end
