local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RemoteEventNames = require(ReplicatedStorage.Shared.RemoteEvents)
local DataHandler      = require(script.Parent.DataHandler)
local HatchModule      = require(script.Parent.HatchModule)
local TrainingModule   = require(script.Parent.TrainingModule)

local RemoteHandler = {}

-- RemoteEvent / RemoteFunction を ReplicatedStorage に作成または取得する
local function GetOrCreate(className, name)
	local folder = ReplicatedStorage:FindFirstChild("Remotes")
	if not folder then
		folder = Instance.new("Folder")
		folder.Name = "Remotes"
		folder.Parent = ReplicatedStorage
	end

	local existing = folder:FindFirstChild(name)
	if existing then return existing end

	local obj = Instance.new(className)
	obj.Name   = name
	obj.Parent = folder
	return obj
end

function RemoteHandler.Init()
	-- HatchEgg RemoteEvent
	local hatchEvent = GetOrCreate("RemoteEvent", RemoteEventNames.HatchEgg)
	hatchEvent.OnServerEvent:Connect(function(player, eggType)
		if typeof(eggType) ~= "string" then return end

		local result = HatchModule.HatchEgg(player, eggType)

		-- 結果をクライアントに返す
		hatchEvent:FireClient(player, result)
		
		-- データ更新を通知
		RemoteHandler.FireUpdateData(player)
	end)

	-- TrainPigeon RemoteEvent
	local trainEvent = GetOrCreate("RemoteEvent", RemoteEventNames.TrainPigeon)
	trainEvent.OnServerEvent:Connect(function(player, pigeonId, trainingType)
		if typeof(pigeonId) ~= "string" or typeof(trainingType) ~= "string" then return end

		local result = TrainingModule.StartTraining(player, pigeonId, trainingType)
		trainEvent:FireClient(player, result)
		
		-- データ更新を通知
		RemoteHandler.FireUpdateData(player)
	end)

	-- GetPlayerData RemoteFunction
	local getDataFunc = GetOrCreate("RemoteFunction", RemoteEventNames.GetPlayerData)
	getDataFunc.OnServerInvoke = function(player)
		local profile = DataHandler.GetProfile(player)
		if not profile then return nil end

		return {
			Coins    = profile.Data.Coins,
			Gems     = profile.Data.Gems,
			Pigeons  = profile.Data.Pigeons,
			Stats    = profile.Data.Stats,
		}
	end

	-- UpdatePlayerData RemoteEvent
	GetOrCreate("RemoteEvent", RemoteEventNames.UpdatePlayerData)

	print("✅ RemoteHandler Initialized")
end

function RemoteHandler.FireUpdateData(player)
	local profile = DataHandler.GetProfile(player)
	if not profile then return end

	local event = ReplicatedStorage.Remotes:FindFirstChild(RemoteEventNames.UpdatePlayerData)
	if event then
		event:FireClient(player, {
			Coins    = profile.Data.Coins,
			Gems     = profile.Data.Gems,
			Pigeons  = profile.Data.Pigeons,
			Stats    = profile.Data.Stats,
		})
	end
end

return RemoteHandler
