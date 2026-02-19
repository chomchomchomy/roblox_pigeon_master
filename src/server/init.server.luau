local DataHandler    = require(script.Modules.DataHandler)
local RemoteHandler  = require(script.Modules.RemoteHandler)

print("🕊️ Pigeon Masters Server Starting...")

-- データ管理を最初に初期化（他モジュールが依存するため）
DataHandler.Init()

-- RemoteEvents の登録
RemoteHandler.Init()

print("✅ Server Initialized")
