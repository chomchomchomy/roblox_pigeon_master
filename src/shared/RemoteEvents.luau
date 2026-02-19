-- RemoteEvent / RemoteFunction の名前定数
-- サーバーとクライアントで同じ名前を参照するために使用する

local RemoteEvents = {
	-- 孵化（ガチャ）
	HatchEgg       = "HatchEgg",

	-- 育成
	TrainPigeon    = "TrainPigeon",

	-- プレイヤーデータ取得（RemoteFunction）
	GetPlayerData  = "GetPlayerData",

	-- データ更新通知（RemoteEvent）
	UpdatePlayerData = "UpdatePlayerData",
}

return RemoteEvents
