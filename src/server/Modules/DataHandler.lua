local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ProfileService = require(script.Parent.ProfileService)
local Constants = require(ReplicatedStorage.Shared.Constants)

local DataHandler = {}
local Profiles = {}

local ProfileStore = ProfileService.GetProfileStore(Constants.DATA_STORE_NAME, Constants.TEMPLATE_DATA)

local function PlayerAdded(player)
	local profile = ProfileStore:LoadProfileAsync("Player_" .. player.UserId)
	if profile ~= nil then
		profile:AddUserId(player.UserId) -- GDPR compliance
		profile:Reconcile() -- Fill in missing variables from Constants.TEMPLATE_DATA

		profile:ListenToRelease(function()
			Profiles[player] = nil
			-- The profile could've been loaded on another Roblox server:
			player:Kick()
		end)

		if player:IsDescendantOf(Players) == true then
			Profiles[player] = profile
			-- A profile has been successfully loaded:
			print(player.Name .. "'s profile loaded.")
            -- Warning: In production, do not print entire profile data if it's huge
		else
			-- Player left before the profile loaded:
			profile:Release()
		end
	else
		-- The profile could not be loaded possibly due to other
		--   Roblox servers trying to load this profile at the same time:
		player:Kick() 
	end
end

function DataHandler.Init()
    for _, player in ipairs(Players:GetPlayers()) do
        task.spawn(PlayerAdded, player)
    end

    Players.PlayerAdded:Connect(PlayerAdded)

    Players.PlayerRemoving:Connect(function(player)
        local profile = Profiles[player]
        if profile ~= nil then
            profile:Release()
        end
    end)
    
    print("✅ DataHandler Initialized")
end

function DataHandler.GetProfile(player)
    return Profiles[player]
end

return DataHandler
