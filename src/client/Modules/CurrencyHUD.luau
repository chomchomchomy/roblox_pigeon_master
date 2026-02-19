local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Constants = require(ReplicatedStorage.Shared.Constants)

local CurrencyHUD = {}

function CurrencyHUD.Create(player)
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "MainHUD"
	screenGui.ResetOnSpawn = false
	screenGui.Parent = player:WaitForChild("PlayerGui")

	-- Container for currencies
	local container = Instance.new("Frame")
	container.Name = "CurrencyContainer"
	container.Size = UDim2.new(0, 200, 0, 100)
	container.Position = UDim2.new(0, 20, 0, 20)
	container.BackgroundTransparency = 1
	container.Parent = screenGui

	local listLayout = Instance.new("UIListLayout")
	listLayout.Padding = UDim.new(0, 10)
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder
	listLayout.Parent = container

	-- Coin Label
	local coinFrame = CurrencyHUD.CreateCurrencyItem("Coins", Color3.fromRGB(255, 215, 0), 1)
	coinFrame.Parent = container
	
	-- Gem Label
	local gemFrame = CurrencyHUD.CreateCurrencyItem("Gems", Color3.fromRGB(0, 255, 255), 2)
	gemFrame.Parent = container

	return screenGui
end

function CurrencyHUD.CreateCurrencyItem(name, color, order)
	local frame = Instance.new("Frame")
	frame.Name = name .. "Frame"
	frame.Size = UDim2.new(1, 0, 0, 40)
	frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	frame.BorderSizePixel = 0
	frame.LayoutOrder = order

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = frame

	local stroke = Instance.new("UIStroke")
	stroke.Color = color
	stroke.Thickness = 2
	stroke.Transparency = 0.5
	stroke.Parent = frame

	local icon = Instance.new("TextLabel")
	icon.Name = "Icon"
	icon.Size = UDim2.new(0, 30, 1, 0)
	icon.Position = UDim2.new(0, 5, 0, 0)
	icon.BackgroundTransparency = 1
	icon.Text = (name == "Coins") and "🪙" or "💎"
	icon.TextSize = 20
	icon.Parent = frame

	local label = Instance.new("TextLabel")
	label.Name = "Amount"
	label.Size = UDim2.new(1, -45, 1, 0)
	label.Position = UDim2.new(0, 40, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = "0"
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Font = Enum.Font.GothamBold
	label.TextSize = 18
	label.Parent = frame

	return frame
end

function CurrencyHUD.Update(screenGui, data)
	local container = screenGui:FindFirstChild("CurrencyContainer")
	if not container then return end

	local coinLabel = container:FindFirstChild("CoinsFrame"):FindFirstChild("Amount")
	local gemLabel = container:FindFirstChild("GemsFrame"):FindFirstChild("Amount")

	if coinLabel then coinLabel.Text = tostring(data.Coins or 0) end
	if gemLabel then gemLabel.Text = tostring(data.Gems or 0) end
end

return CurrencyHUD
