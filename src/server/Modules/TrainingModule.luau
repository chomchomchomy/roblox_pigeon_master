local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Constants    = require(ReplicatedStorage.Shared.Constants)
local PigeonModule = require(script.Parent.PigeonModule)

local TrainingModule = {}

-- クールダウン中かどうかを確認する
-- 戻り値: canTrain (bool), remainingSeconds (number)
function TrainingModule.CanTrain(player, pigeonId, trainingType)
	local pigeon = PigeonModule.GetPigeonById(player, pigeonId)
	if not pigeon then
		return false, 0
	end

	local lastTrained = pigeon.TrainedAt[trainingType]
	if not lastTrained then
		return true, 0
	end

	local elapsed   = os.time() - lastTrained
	local remaining = Constants.TRAINING_COOLDOWN - elapsed

	if remaining <= 0 then
		return true, 0
	end
	return false, remaining
end

-- トレーニングを実行してステータスを上昇させる
-- 戻り値: { success = bool, gains = table or nil, message = string }
function TrainingModule.StartTraining(player, pigeonId, trainingType)
	local trainingConfig = Constants.TRAINING_TYPES[trainingType]
	if not trainingConfig then
		return { success = false, message = "Invalid training type: " .. tostring(trainingType) }
	end

	local pigeon = PigeonModule.GetPigeonById(player, pigeonId)
	if not pigeon then
		return { success = false, message = "Pigeon not found" }
	end

	-- クールダウン確認
	local canTrain, remaining = TrainingModule.CanTrain(player, pigeonId, trainingType)
	if not canTrain then
		return {
			success = false,
			message = string.format("クールダウン中です。あと %d 秒", remaining)
		}
	end

	-- ステータス上昇（上限 STAT_MAX を超えない）
	local actualGains = {}
	for stat, gain in pairs(trainingConfig.StatGains) do
		local current = pigeon.Stats[stat] or 0
		local newVal  = math.min(current + gain, Constants.STAT_MAX)
		local actual  = newVal - current
		pigeon.Stats[stat] = newVal
		actualGains[stat]  = actual
	end

	-- クールダウン記録
	pigeon.TrainedAt[trainingType] = os.time()

	print(string.format(
		"[TrainingModule] %s が %s をトレーニング (%s)",
		player.Name, pigeon.Name, trainingType
	))

	return { success = true, gains = actualGains, pigeon = pigeon }
end

return TrainingModule
