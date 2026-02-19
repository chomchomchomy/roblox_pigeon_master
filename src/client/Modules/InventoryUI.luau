local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local Constants = require(ReplicatedStorage.Shared.Constants)

local InventoryUI = {}

function InventoryUI.Create(player, screenGui)
	local mainFrame = Instance.new("Frame")
	mainFrame.Name = "InventoryFrame"
	mainFrame.Size = UDim2.new(0, 500, 0, 400)
	mainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
	mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	mainFrame.Visible = false
	mainFrame.Parent = screenGui

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 10)
	corner.Parent = mainFrame

	local title = Instance.new("TextLabel")
	title.Name = "Title"
	title.Size = UDim2.new(1, 0, 0, 40)
	title.BackgroundTransparency = 1
	title.Text = "MY PIGEONS"
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.Font = Enum.Font.GothamBlack
	title.TextSize = 20
	title.Parent = mainFrame

	local scroll = Instance.new("ScrollingFrame")
	scroll.Name = "PigeonList"
	scroll.Size = UDim2.new(1, -20, 1, -60)
	scroll.Position = UDim2.new(0, 10, 0, 50)
	scroll.BackgroundTransparency = 1
	scroll.ScrollBarThickness = 4
	scroll.Parent = mainFrame

	local grid = Instance.new("UIGridLayout")
	grid.CellSize = UDim2.new(0, 110, 0, 130)
	grid.Padding = UDim2.new(0, 10, 0, 10)
	grid.Parent = scroll

	local closeBtn = Instance.new("TextButton")
	closeBtn.Name = "Close"
	closeBtn.Size = UDim2.new(0, 30, 0, 30)
	closeBtn.Position = UDim2.new(1, -35, 0, 5)
	closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
	closeBtn.Text = "X"
	closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	closeBtn.Font = Enum.Font.GothamBold
	closeBtn.Parent = mainFrame

	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(1, 0)
	btnCorner.Parent = closeBtn

	closeBtn.MouseButton1Click:Connect(function()
		mainFrame.Visible = false
	end)

	-- Inventory Button on HUD
	local invBtnContainer = Instance.new("Frame")
	invBtnContainer.Name = "InvBtnContainer"
	invBtnContainer.Size = UDim2.new(0, 150, 0, 50)
	invBtnContainer.Position = UDim2.new(1, -170, 0, 80)
	invBtnContainer.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	invBtnContainer.BorderSizePixel = 0
	invBtnContainer.Parent = screenGui

	local invCorner = Instance.new("UICorner")
	invCorner.CornerRadius = UDim.new(0, 8)
	invCorner.Parent = invBtnContainer

	local invButton = Instance.new("TextButton")
	invButton.Name = "InventoryButton"
	invButton.Size = UDim2.new(1, 0, 1, 0)
	invButton.BackgroundTransparency = 1
	invButton.Text = "Pigeons 🕊️"
	invButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	invButton.Font = Enum.Font.GothamBold
	invButton.TextSize = 14
	invButton.Parent = invBtnContainer

	invButton.MouseButton1Click:Connect(function()
		mainFrame.Visible = not mainFrame.Visible
	end)

	return mainFrame
end

function InventoryUI.Update(mainFrame, data)
	local scroll = mainFrame:FindFirstChild("PigeonList")
	if not scroll then return end

	-- Clear old items
	for _, child in ipairs(scroll:GetChildren()) do
		if child:IsA("Frame") then child:Destroy() end
	end

	local pigeons = data.Pigeons or {}
	for id, pigeon in pairs(pigeons) do
		local item = Instance.new("Frame")
		item.Name = id
		item.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
		item.Parent = scroll

		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, 8)
		corner.Parent = item

		local icon = Instance.new("TextLabel")
		icon.Size = UDim2.new(1, 0, 0, 60)
		icon.BackgroundTransparency = 1
		icon.Text = "🕊️"
		icon.TextSize = 40
		icon.Parent = item

		local nameLabel = Instance.new("TextLabel")
		nameLabel.Size = UDim2.new(1, 0, 0, 20)
		nameLabel.Position = UDim2.new(0, 0, 0, 65)
		nameLabel.BackgroundTransparency = 1
		nameLabel.Text = pigeon.Rarity
		nameLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
		nameLabel.Font = Enum.Font.GothamBold
		nameLabel.TextSize = 12
		nameLabel.Parent = item

		local statsLabel = Instance.new("TextLabel")
		statsLabel.Size = UDim2.new(1, 0, 0, 40)
		statsLabel.Position = UDim2.new(0, 0, 0, 85)
		statsLabel.BackgroundTransparency = 1
		statsLabel.Text = string.format("SPD: %d\nSTA: %d", pigeon.Stats.Speed, pigeon.Stats.Stamina)
		statsLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
		statsLabel.Font = Enum.Font.Gotham
		statsLabel.TextSize = 10
		statsLabel.Parent = item

		local trainBtn = Instance.new("TextButton")
		trainBtn.Name = "Train"
		trainBtn.Size = UDim2.new(0.8, 0, 0, 20)
		trainBtn.Position = UDim2.new(0.1, 0, 1, -25)
		trainBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
		trainBtn.Text = "Train"
		trainBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		trainBtn.Font = Enum.Font.GothamBold
		trainBtn.TextSize = 10
		trainBtn.Parent = item

		local btnCorner = Instance.new("UICorner")
		btnCorner.CornerRadius = UDim.new(0, 4)
		btnCorner.Parent = trainBtn

		trainBtn.MouseButton1Click:Connect(function()
			local TrainingUI = require(script.Parent.TrainingUI)
			TrainingUI.Open(id, pigeon.Rarity .. " Pigeon")
		end)
	end
end

return InventoryUI
