local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Constants  = require(ReplicatedStorage.Shared.Constants)
local DataHandler = require(script.Parent.DataHandler)

local PigeonModule = {}

-- ユニークIDを生成する
local function GenerateId()
	return tostring(os.time()) .. "_" .. tostring(math.random(100000, 999999))
end

-- レアリティからベースステータスをコピーして返す
local function CloneBaseStats(rarity)
	local base = Constants.PIGEON_BASE_STATS[rarity]
	return {
		Speed      = base.Speed,
		Stamina    = base.Stamina,
		Navigation = base.Navigation,
		Luck       = base.Luck,
	}
end

-- 新しい鳩データを生成する（保存はしない）
function PigeonModule.CreatePigeon(rarity, name)
	assert(Constants.PIGEON_BASE_STATS[rarity], "Invalid rarity: " .. tostring(rarity))
	return {
		Id        = GenerateId(),
		Name      = name or (rarity .. " Pigeon"),
		Rarity    = rarity,
		Stats     = CloneBaseStats(rarity),
		TrainedAt = {},   -- { trainingType = lastTrainTimestamp }
		HatchedAt = os.time(),
	}
end

-- プレイヤーのプロファイルに鳩を追加して保存する
function PigeonModule.AddPigeonToPlayer(player, pigeonData)
	local profile = DataHandler.GetProfile(player)
	if not profile then
		warn("PigeonModule: No profile for " .. player.Name)
		return false
	end

	table.insert(profile.Data.Pigeons, pigeonData)
	return true
end

-- プレイヤーの鳩をIDで検索する
-- 戻り値: pigeon (table), index (number) または nil
function PigeonModule.GetPigeonById(player, pigeonId)
	local profile = DataHandler.GetProfile(player)
	if not profile then return nil, nil end

	for i, pigeon in ipairs(profile.Data.Pigeons) do
		if pigeon.Id == pigeonId then
			return pigeon, i
		end
	end
	return nil, nil
end

return PigeonModule
