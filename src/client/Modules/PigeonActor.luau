local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")

local PigeonActor = {}
PigeonActor.__index = PigeonActor

function PigeonActor.new(model, pigeonData)
	local self = setmetatable({}, PigeonActor)
	self.Model = model
	self.Data = pigeonData
	self.Humanoid = model:FindFirstChildOfClass("Humanoid") or Instance.new("Humanoid")
	if not self.Humanoid.Parent then self.Humanoid.Parent = model end
	
	self.HomePosition = model.PrimaryPart.Position
	self.IsMoving = false
	
	return self
end

function PigeonActor:StartWandering()
	task.spawn(function()
		while self.Model and self.Model.Parent do
			-- Wait for random time
			task.wait(math.random(3, 7))
			
			-- Choose random spot near home
			local offset = Vector3.new(
				math.random(-15, 15),
				0,
				math.random(-15, 15)
			)
			local targetPos = self.HomePosition + offset
			
			-- Move to spot
			if self.Humanoid then
				self.Humanoid:MoveTo(targetPos)
				self.IsMoving = true
				
				-- Handle timeout or arrival
				local arrived = false
				local connection
				connection = self.Humanoid.MoveToFinished:Connect(function()
					arrived = true
					if connection then connection:Disconnect() end
				end)
				
				-- Timeout after 5 seconds if stuck
				task.delay(5, function()
					if not arrived then
						arrived = true
						if connection then connection:Disconnect() end
					end
				end)
				
				repeat task.wait(0.1) until arrived
				self.IsMoving = false
			end
		end
	end)
end

function PigeonActor:PlayAnimation(animName)
	-- Ready for animation logic later
end

return PigeonActor
