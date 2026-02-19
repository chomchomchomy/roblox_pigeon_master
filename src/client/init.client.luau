local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RemoteEventNames = require(ReplicatedStorage.Shared.RemoteEvents)
local CurrencyHUD      = require(script.Modules.CurrencyHUD)
local HatchUI          = require(script.Modules.HatchUI)
local InventoryUI      = require(script.Modules.InventoryUI)
local PigeonSpawner    = require(script.Modules.PigeonSpawner)
local TrainingUI      = require(script.Modules.TrainingUI)

local player = Players.LocalPlayer
local remotes = ReplicatedStorage:WaitForChild("Remotes")

print("🕊️ Pigeon Masters Client Starting...")

-- Initialize World
local pigeonsFolder = Instance.new("Folder")
pigeonsFolder.Name = "Pigeons"
pigeonsFolder.Parent = workspace

-- Initialize UI
local mainHUD = CurrencyHUD.Create(player)
local hatchButton = HatchUI.Create(player, mainHUD)
local inventoryFrame = InventoryUI.Create(player, mainHUD)
local trainingFrame = TrainingUI.Create(player, mainHUD)

-- Request initial data
local getDataFunc = remotes:WaitForChild(RemoteEventNames.GetPlayerData)
local initialData = getDataFunc:InvokeServer()
if initialData then
	CurrencyHUD.Update(mainHUD, initialData)
	InventoryUI.Update(inventoryFrame, initialData)
	PigeonSpawner.UpdatePigeons(initialData.Pigeons)
end

-- Listen for updates
local updateEvent = remotes:WaitForChild(RemoteEventNames.UpdatePlayerData)
updateEvent.OnClientEvent:Connect(function(data)
	CurrencyHUD.Update(mainHUD, data)
	InventoryUI.Update(inventoryFrame, data)
	PigeonSpawner.UpdatePigeons(data.Pigeons)
end)

print("✅ Client Initialized")
