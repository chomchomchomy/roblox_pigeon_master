local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local PigeonActor = require(script.Parent.PigeonActor)

local PigeonSpawner = {}
local spawnedPigeons = {} -- { [pigeonId] = PigeonActorInstance }

function PigeonSpawner.Init()
	-- Clean up on dead/respawn if needed
end

function PigeonSpawner.UpdatePigeons(pigeonDataList)
	local player = Players.LocalPlayer
	local character = player.Character or player.CharacterAdded:Wait()
	local rootPart = character:WaitForChild("HumanoidRootPart")
	
	-- Determine center for spawning (near player's home/start)
	local spawnCenter = Vector3.new(0, 5, 0) -- Default world center/lobby
	
	for _, data in pairs(pigeonDataList) do
		if not spawnedPigeons[data.Id] then
			PigeonSpawner.SpawnPigeon(data, spawnCenter)
		end
	end
end

function PigeonSpawner.SpawnPigeon(data, center)
	local model = Instance.new("Model")
	model.Name = "Pigeon_" .. data.Id
	
	-- Body (Main part)
	local body = Instance.new("Part")
	body.Name = "HumanoidRootPart"
	body.Size = Vector3.new(0.8, 0.8, 1.2)
	body.Color = (data.Rarity == "Legendary") and Color3.fromRGB(255, 215, 0) or Color3.fromRGB(120, 120, 120)
	body.Position = center + Vector3.new(math.random(-10, 10), 0, math.random(-10, 10))
	body.Parent = model
	
	local bodyMesh = Instance.new("SpecialMesh")
	bodyMesh.MeshType = Enum.MeshType.Sphere
	bodyMesh.Parent = body

	-- Head
	local head = Instance.new("Part")
	head.Name = "Head"
	head.Size = Vector3.new(0.5, 0.5, 0.5)
	head.Position = body.Position + Vector3.new(0, 0.5, 0.4)
	head.Color = body.Color
	head.CanCollide = false
	head.Parent = model
	
	local headMesh = Instance.new("SpecialMesh")
	headMesh.MeshType = Enum.MeshType.Sphere
	headMesh.Parent = head
	
	local headWeld = Instance.new("WeldConstraint")
	headWeld.Part0 = body
	headWeld.Part1 = head
	headWeld.Parent = head

	-- Beak
	local beak = Instance.new("Part")
	beak.Name = "Beak"
	beak.Size = Vector3.new(0.2, 0.2, 0.3)
	beak.Position = head.Position + Vector3.new(0, 0, 0.3)
	beak.Color = Color3.fromRGB(255, 170, 0)
	beak.CanCollide = false
	beak.Parent = model
	
	local beakWeld = Instance.new("WeldConstraint")
	beakWeld.Part0 = head
	beakWeld.Part1 = beak
	beakWeld.Parent = beak

	local humanoid = Instance.new("Humanoid")
	humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None -- Hide health bar
	humanoid.Parent = model
	
	model.PrimaryPart = body
	model.Parent = workspace:WaitForChild("Pigeons", 5) or workspace
	
	local actor = PigeonActor.new(model, data)
	actor:StartWandering()
	
	spawnedPigeons[data.Id] = actor
	
	print("🕊️ Spawned Detailed " .. data.Rarity .. " Pigeon: " .. data.Id)
end

return PigeonSpawner
