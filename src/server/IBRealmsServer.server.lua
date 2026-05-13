local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local IBRealms = ReplicatedStorage:WaitForChild("IBRealms")
local ProgressService = require(script.Services.ProgressService)
local QuestService = require(script.Services.QuestService)
local WorldBuilder = require(script.Services.WorldBuilder)
local GameConfig = require(IBRealms.Data.GameConfig)

local remotes = IBRealms:FindFirstChild("Remotes") or Instance.new("Folder")
remotes.Name = "Remotes"
remotes.Parent = IBRealms

local function remoteFunction(name)
	local rf = remotes:FindFirstChild(name)
	if not rf then
		rf = Instance.new("RemoteFunction")
		rf.Name = name
		rf.Parent = remotes
	end
	return rf
end

local function remoteEvent(name)
	local re = remotes:FindFirstChild(name)
	if not re then
		re = Instance.new("RemoteEvent")
		re.Name = name
		re.Parent = remotes
	end
	return re
end

local GetProfile = remoteFunction("GetProfile")
local UpdateSubjects = remoteFunction("UpdateSubjects")
local StartQuest = remoteFunction("StartQuest")
local AnswerQuestion = remoteFunction("AnswerQuestion")
local TeleportRequest = remoteEvent("TeleportRequest")
local Notify = remoteEvent("Notify")

local previewPositions = {
	ComputerScience = CFrame.new(-420, 9, 24) * CFrame.Angles(0, math.rad(180), 0),
	Maths = CFrame.new(-260, 9, -236) * CFrame.Angles(0, math.rad(180), 0),
	Physics = CFrame.new(0, 9, -396) * CFrame.Angles(0, math.rad(180), 0),
	DesignTechnology = CFrame.new(260, 9, -236) * CFrame.Angles(0, math.rad(180), 0),
	Business = CFrame.new(420, 9, 24) * CFrame.Angles(0, math.rad(180), 0),
	Economics = CFrame.new(260, 9, 284) * CFrame.Angles(0, math.rad(180), 0),
	ESS = CFrame.new(0, 9, 444) * CFrame.Angles(0, math.rad(180), 0),
	Japanese = CFrame.new(-260, 9, 284) * CFrame.Angles(0, math.rad(180), 0),
	French = CFrame.new(-520, 9, 244) * CFrame.Angles(0, math.rad(180), 0),
	Spanish = CFrame.new(520, 9, 244) * CFrame.Angles(0, math.rad(180), 0),
}

local function teleportCharacter(player, cframe)
	local character = player.Character
	if not character then
		return
	end
	local root = character:FindFirstChild("HumanoidRootPart")
	if root then
		root.CFrame = cframe
	end
end

WorldBuilder.Build()

GetProfile.OnServerInvoke = function(player)
	return ProgressService.GetPublicProfile(player)
end

UpdateSubjects.OnServerInvoke = function(player, subjectIds, mainSubject)
	return ProgressService.SetSubjects(player, subjectIds, mainSubject)
end

StartQuest.OnServerInvoke = function(player, questId)
	local session, err = QuestService.StartQuest(player, questId)
	return { ok = session ~= nil, session = session, error = err }
end

AnswerQuestion.OnServerInvoke = function(player, response)
	local result, err = QuestService.Answer(player, response)
	return { ok = result ~= nil, result = result, error = err }
end

TeleportRequest.OnServerEvent:Connect(function(player, destination, payload)
	if destination == "Hub" then
		teleportCharacter(player, GameConfig.HubSpawnCFrame)
	elseif destination == "PreviewZone" and previewPositions[payload] then
		teleportCharacter(player, previewPositions[payload])
	else
		Notify:FireClient(player, "Unknown teleport destination.")
	end
end)

Players.PlayerAdded:Connect(function(player)
	ProgressService.GetProfile(player)
	player.CharacterAdded:Connect(function(character)
		local humanoid = character:WaitForChild("Humanoid", 10)
		local root = character:WaitForChild("HumanoidRootPart", 10)
		if humanoid then
			humanoid.WalkSpeed = GameConfig.NormalWalkSpeed
		end
		if root then
			task.wait(0.1)
			root.CFrame = GameConfig.HubSpawnCFrame
		end
	end)
end)

Players.PlayerRemoving:Connect(function(player)
	QuestService.Clear(player)
	ProgressService.RemovePlayer(player)
end)
