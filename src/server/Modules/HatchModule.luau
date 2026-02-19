local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Constants    = require(ReplicatedStorage.Shared.Constants)
local DataHandler  = require(script.Parent.DataHandler)
local PigeonModule = require(script.Parent.PigeonModule)

local HatchModule = {}

-- 重み付きランダムでレアリティを返す
-- weightsTable: { { rarity = "Common", weight = 60 }, ... }
local function GetWeightedRarity(weightsTable)
	local total = 0
	for _, entry in ipairs(weightsTable) do
		total = total + entry.weight
	end

	local roll = math.random(1, total)
	local cumulative = 0
	for _, entry in ipairs(weightsTable) do
		cumulative = cumulative + entry.weight
		if roll <= cumulative then
			return entry.rarity
		end
	end

	-- フォールバック（通常到達しない）
	return "Common"
end

-- 卵を孵化させる
-- 戻り値: { success = bool, pigeon = pigeonData or nil, message = string }
function HatchModule.HatchEgg(player, eggType)
	local eggConfig = Constants.EGG_TYPES[eggType]
	if not eggConfig then
		return { success = false, message = "Invalid egg type: " .. tostring(eggType) }
	end

	local profile = DataHandler.GetProfile(player)
	if not profile then
		return { success = false, message = "Profile not found" }
	end

	-- コスト確認
	local currency = eggConfig.CostType
	local cost     = eggConfig.CostAmount
	if profile.Data[currency] < cost then
		return {
			success = false,
			message = currency .. " が足りません。必要数: " .. cost
		}
	end

	-- コスト消費
	profile.Data[currency] = profile.Data[currency] - cost

	-- レアリティ抽選
	local weights = eggConfig.RarityBonus or Constants.RARITY_WEIGHTS
	local rarity  = GetWeightedRarity(weights)

	-- 鳩生成 & 保存
	local newPigeon = PigeonModule.CreatePigeon(rarity)
	PigeonModule.AddPigeonToPlayer(player, newPigeon)

	print(string.format("[HatchModule] %s が %s の鳩を孵化 (ID: %s)", player.Name, rarity, newPigeon.Id))

	return { success = true, pigeon = newPigeon }
end

return HatchModule
