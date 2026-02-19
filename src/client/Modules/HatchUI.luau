local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local RemoteEventNames = require(ReplicatedStorage.Shared.RemoteEvents)
local Constants        = require(ReplicatedStorage.Shared.Constants)

local HatchUI = {}

function HatchUI.Create(player, screenGui)
	local container = Instance.new("Frame")
	container.Name = "HatchContainer"
	container.Size = UDim2.new(0, 150, 0, 50)
	container.Position = UDim2.new(1, -170, 0, 20)
	container.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	container.BorderSizePixel = 0
	container.Parent = screenGui

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = container

	local button = Instance.new("TextButton")
	button.Name = "HatchButton"
	button.Size = UDim2.new(1, 0, 1, 0)
	button.BackgroundTransparency = 1
	button.Text = "Hatch Egg (100 🪙)"
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.Font = Enum.Font.GothamBold
	button.TextSize = 14
	button.Parent = container

	local remotes = ReplicatedStorage:WaitForChild("Remotes")
	local hatchEvent = remotes:WaitForChild(RemoteEventNames.HatchEgg)

	button.MouseButton1Click:Connect(function()
		button.Text = "Hatching..."
		button.Active = false
		
		hatchEvent:FireServer("BasicEgg")
	end)

	hatchEvent.OnClientEvent:Connect(function(result)
		button.Active = true
		button.Text = "Hatch Egg (100 🪙)"

		if result.success then
			HatchUI.ShowResult(player, result.pigeon)
		else
			warn("Hatch failed:", result.message)
			-- Could show a small toast here
		end
	end)

	return container
end

function HatchUI.ShowResult(player, pigeon)
	local playerGui = player:WaitForChild("PlayerGui")
	local screenGui = playerGui:FindFirstChild("MainHUD")
	if not screenGui then return end

	-- Overlay for immersion
	local overlay = Instance.new("Frame")
	overlay.Name = "HatchOverlay"
	overlay.Size = UDim2.new(1, 0, 1, 0)
	overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	overlay.BackgroundTransparency = 1
	overlay.ZIndex = 100
	overlay.Parent = screenGui

	-- Initial Egg Icon
	local egg = Instance.new("TextLabel")
	egg.Name = "Egg"
	egg.Size = UDim2.new(0, 200, 0, 200)
	egg.Position = UDim2.new(0.5, -100, 0.5, -100)
	egg.BackgroundTransparency = 1
	egg.Text = "🥚"
	egg.TextSize = 120
	egg.ZIndex = 101
	egg.Parent = overlay

	-- Stage 1: Shake the egg
	task.spawn(function()
		-- Fade in overlay
		TweenService:Create(overlay, TweenInfo.new(0.3), {BackgroundTransparency = 0.5}):Play()
		
		for i = 1, 10 do
			local offset = Vector2.new(math.random(-10, 10), math.random(-10, 10))
			egg.Position = UDim2.new(0.5, -100 + offset.X, 0.5, -100 + offset.Y)
			task.wait(0.05)
		end
		
		egg.Text = "💥"
		task.wait(0.2)
		egg:Destroy()

		-- Stage 2: Show result card
		local resultFrame = Instance.new("Frame")
		resultFrame.Name = "HatchResult"
		resultFrame.Size = UDim2.new(0, 300, 0, 400)
		resultFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
		resultFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
		resultFrame.BorderSizePixel = 0
		resultFrame.ZIndex = 102
		resultFrame.Parent = overlay

		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, 15)
		corner.Parent = resultFrame

		local rarityColor = (pigeon.Rarity == "Legendary") and Color3.fromRGB(255, 215, 0) 
						 or (pigeon.Rarity == "Epic") and Color3.fromRGB(255, 0, 255)
						 or (pigeon.Rarity == "Rare") and Color3.fromRGB(0, 170, 255)
						 or Color3.fromRGB(200, 200, 200)

		local stroke = Instance.new("UIStroke")
		stroke.Thickness = 4
		stroke.Color = rarityColor
		stroke.Parent = resultFrame

		local title = Instance.new("TextLabel")
		title.Size = UDim2.new(1, 0, 0, 50)
		title.BackgroundTransparency = 1
		title.Text = "NEW PIGEON!"
		title.TextColor3 = rarityColor
		title.Font = Enum.Font.GothamBlack
		title.TextSize = 28
		title.ZIndex = 103
		title.Parent = resultFrame

		local rarity = Instance.new("TextLabel")
		rarity.Size = UDim2.new(1, 0, 0, 30)
		rarity.Position = UDim2.new(0, 0, 0, 50)
		rarity.BackgroundTransparency = 1
		rarity.Text = pigeon.Rarity:upper()
		rarity.TextColor3 = rarityColor
		rarity.Font = Enum.Font.GothamBold
		rarity.TextSize = 20
		rarity.ZIndex = 103
		rarity.Parent = resultFrame

		local icon = Instance.new("TextLabel")
		icon.Size = UDim2.new(0, 150, 0, 150)
		icon.Position = UDim2.new(0.5, -75, 0, 120)
		icon.BackgroundTransparency = 1
		icon.Text = "🕊️"
		icon.TextSize = 120
		icon.ZIndex = 103
		icon.Parent = resultFrame

		-- Light burst effect
		local burst = Instance.new("Frame")
		burst.Size = UDim2.new(0, 0, 0, 0)
		burst.Position = UDim2.new(0.5, 0, 0.5, 0)
		burst.BackgroundColor3 = rarityColor
		burst.ZIndex = 101
		burst.Parent = resultFrame
		local burstCorner = Instance.new("UICorner")
		burstCorner.CornerRadius = UDim.new(1, 0)
		burstCorner.Parent = burst
		
		TweenService:Create(burst, TweenInfo.new(0.8, Enum.EasingStyle.QuartOut), {
			Size = UDim2.new(0, 600, 0, 600),
			Position = UDim2.new(0.5, -300, 0.5, -300),
			BackgroundTransparency = 1
		}):Play()

		local closeButton = Instance.new("TextButton")
		closeButton.Size = UDim2.new(0, 120, 0, 45)
		closeButton.Position = UDim2.new(0.5, -60, 1, -70)
		closeButton.BackgroundColor3 = rarityColor
		closeButton.Text = "AWESOME!"
		closeButton.TextColor3 = Color3.fromRGB(0, 0, 0)
		closeButton.Font = Enum.Font.GothamBlack
		closeButton.ZIndex = 104
		closeButton.Parent = resultFrame

		local btnCorner = Instance.new("UICorner")
		btnCorner.CornerRadius = UDim.new(0, 8)
		btnCorner.Parent = closeButton

		closeButton.MouseButton1Click:Connect(function()
			overlay:Destroy()
		end)

		-- Animation
		resultFrame.Size = UDim2.new(0, 0, 0, 0)
		resultFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
		TweenService:Create(resultFrame, TweenInfo.new(0.5, Enum.EasingStyle.BackOut), {
			Size = UDim2.new(0, 300, 0, 400),
			Position = UDim2.new(0.5, -150, 0.5, -200)
		}):Play()
	end)
end

return HatchUI
