local Constants = {
	DATA_STORE_NAME = "PigeonData_Dev_001",
	TEMPLATE_DATA = {
		Coins = 100,
		Gems = 0,
		Pigeons = {},
		Inventory = {},
		Stats = {
			RacesWon = 0,
			DistanceFlown = 0,
		},
		LoginTimes = 0,
	},

	-- レアリティ定義
	RARITIES = {
		COMMON    = "Common",
		UNCOMMON  = "Uncommon",
		RARE      = "Rare",
		EPIC      = "Epic",
		LEGENDARY = "Legendary",
	},

	-- 重み付き確率テーブル (合計100)
	RARITY_WEIGHTS = {
		{ rarity = "Common",    weight = 60 },
		{ rarity = "Uncommon",  weight = 25 },
		{ rarity = "Rare",      weight = 10 },
		{ rarity = "Epic",      weight = 4  },
		{ rarity = "Legendary", weight = 1  },
	},

	-- レアリティ別ベースステータス { Speed, Stamina, Navigation, Luck }
	PIGEON_BASE_STATS = {
		Common    = { Speed = 10, Stamina = 10, Navigation = 10, Luck = 5  },
		Uncommon  = { Speed = 15, Stamina = 15, Navigation = 15, Luck = 8  },
		Rare      = { Speed = 22, Stamina = 22, Navigation = 22, Luck = 12 },
		Epic      = { Speed = 32, Stamina = 32, Navigation = 32, Luck = 18 },
		Legendary = { Speed = 45, Stamina = 45, Navigation = 45, Luck = 28 },
	},

	-- ステータス上限
	STAT_MAX = 100,

	-- 卵の種類
	EGG_TYPES = {
		BasicEgg = {
			CostType   = "Coins",
			CostAmount = 100,
			-- 標準確率 (RARITY_WEIGHTS をそのまま使用)
			RarityBonus = nil,
		},
		PremiumEgg = {
			CostType   = "Gems",
			CostAmount = 50,
			-- レア以上の確率を2倍に (weight 再定義)
			RarityBonus = {
				{ rarity = "Common",    weight = 40 },
				{ rarity = "Uncommon",  weight = 30 },
				{ rarity = "Rare",      weight = 18 },
				{ rarity = "Epic",      weight = 8  },
				{ rarity = "Legendary", weight = 4  },
			},
		},
	},

	-- トレーニング種別と上昇ステータス
	TRAINING_TYPES = {
		Strength = {
			StatGains    = { Speed = 2, Stamina = 1 },
			Description  = "速度と体力を鍛える",
		},
		Endurance = {
			StatGains    = { Stamina = 2, Navigation = 1 },
			Description  = "持久力と方向感覚を鍛える",
		},
		Navigation = {
			StatGains    = { Navigation = 2, Luck = 1 },
			Description  = "方向感覚と運を鍛える",
		},
	},

	-- トレーニングのクールダウン（秒）
	TRAINING_COOLDOWN = 300,
}

return Constants
