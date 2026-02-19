local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local RemoteEventNames = require(ReplicatedStorage.Shared.RemoteEvents)
local Constants        = require(ReplicatedStorage.Shared.Constants)

local TrainingUI = {}

function TrainingUI.Create(player, screenGui)
	local mainFrame = Instance.new("Frame")
	mainFrame.Name = "TrainingFrame"
	mainFrame.Size = UDim2.new(0, 400, 0, 300)
	mainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
	mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	mainFrame.BorderSizePixel = 0
	mainFrame.Visible = false
	mainFrame.ZIndex = 10
	mainFrame.Parent = screenGui

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 10)
	corner.Parent = mainFrame

	local title = Instance.new("TextLabel")
	title.Name = "Title"
	title.Size = UDim2.new(1, 0, 0, 40)
	title.BackgroundTransparency = 1
	title.Text = "TRAINING CAMP"
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.Font = Enum.Font.GothamBlack
	title.TextSize = 20
	title.Parent = mainFrame

	local subTitle = Instance.new("TextLabel")
	subTitle.Name = "SubTitle"
	subTitle.Size = UDim2.new(1, 0, 0, 20)
	subTitle.Position = UDim2.new(0, 0, 0, 40)
	subTitle.BackgroundTransparency = 1
	subTitle.Text = "Select your pigeon and start training!"
	subTitle.TextColor3 = Color3.fromRGB(180, 180, 180)
	subTitle.Font = Enum.Font.Gotham
	subTitle.TextSize = 14
	subTitle.Parent = mainFrame

	local buttonContainer = Instance.new("Frame")
	buttonContainer.Name = "Buttons"
	buttonContainer.Size = UDim2.new(1, -40, 0, 180)
	buttonContainer.Position = UDim2.new(0, 20, 0, 80)
	buttonContainer.BackgroundTransparency = 1
	buttonContainer.Parent = mainFrame

	local listLayout = Instance.new("UIListLayout")
	listLayout.Padding = UDim.new(0, 10)
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder
	listLayout.Parent = buttonContainer

	local activePigeonId = nil

	-- Create buttons based on Constants.TRAINING_TYPES
	for trainType, config in pairs(Constants.TRAINING_TYPES) do
		local btn = Instance.new("TextButton")
		btn.Name = trainType
		btn.Size = UDim2.new(1, 0, 0, 50)
		btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
		btn.Text = string.format("%s (%s)", trainType, config.Description)
		btn.TextColor3 = Color3.fromRGB(255, 255, 255)
		btn.Font = Enum.Font.GothamBold
		btn.TextSize = 14
		btn.Parent = buttonContainer

		local btnCorner = Instance.new("UICorner")
		btnCorner.CornerRadius = UDim.new(0, 8)
		btnCorner.Parent = btn

		btn.MouseButton1Click:Connect(function()
			if not activePigeonId then return end
			
			local remotes = ReplicatedStorage:WaitForChild("Remotes")
			local trainEvent = remotes:WaitForChild(RemoteEventNames.TrainPigeon)
			
			btn.Text = "Training..."
			btn.Active = false
			
			trainEvent:FireServer(activePigeonId, trainType)
			
			-- Re-enable button on response
			local responseConn
			responseConn = trainEvent.OnClientEvent:Connect(function(result)
				btn.Active = true
				btn.Text = string.format("%s (%s)", trainType, config.Description)
				if result.success then
					TrainingUI.ShowEffect(player, result.gains)
				end
				responseConn:Disconnect()
			end)
		end)
	end

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

	function TrainingUI.Open(pigeonId, pigeonName)
		activePigeonId = pigeonId
		subTitle.Text = "Training: " .. pigeonName
		mainFrame.Visible = true
	end

	return mainFrame
end

function TrainingUI.ShowEffect(player, gains)
	local playerGui = player:WaitForChild("PlayerGui")
	local screenGui = playerGui:FindFirstChild("MainHUD")
	if not screenGui then return end

	local gainText = ""
	for stat, val in pairs(gains) do
		gainText = gainText .. string.format("+%d %s! ", val, stat)
	end

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(0, 200, 0, 50)
	label.Position = UDim2.new(0.5, -100, 0.4, 0)
	label.BackgroundTransparency = 1
	label.Text = gainText
	label.TextColor3 = Color3.fromRGB(0, 255, 0)
	label.Font = Enum.Font.GothamBlack
	label.TextSize = 24
	label.Parent = screenGui

	local tween = TweenService:Create(label, TweenInfo.new(1, Enum.EasingStyle.QuartOut), {
		Position = UDim2.new(0.5, -100, 0.2, 0),
		TextTransparency = 1
	})
	tween:Play()
	tween.Completed:Connect(function()
		label:Destroy()
	end)
end

return TrainingUI
