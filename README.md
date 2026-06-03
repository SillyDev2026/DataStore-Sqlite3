ROBUX DATASTORE API (Lua Client)
================================

A Roblox DataStore system that connects your game to an external backend
(Node.js + Flask + SQLite) for persistent player data storage.

--------------------------------
FEATURES
--------------------------------

- HTTP-based external datastore system
- Fast in-memory caching per player
- Auto-create player data on first join
- Update / patch-based system
- SQLite persistent backend
- Clean modular Lua API
- Scalable multiplayer structure

--------------------------------
BACKEND REQUIREMENTS
--------------------------------

This system requires:

- Node.js server running on port 3000
- Flask API running on port 5000
- SQLite database file (data.db)

Base URL:
http://127.0.0.1:3000

--------------------------------
DATA FORMAT
--------------------------------

Each player is stored like:
```lua
{
  "value": {
    "Coins": 100,
    "Level": 5
  },
  "username": "PlayerName",
  "updated": 1710000000
}
```
--------------------------------
SETUP
--------------------------------

1. CREATE DATASTORE

local Store = require(script.DataStore)

local PlayerStore = Store.new("GameData", "Players")


--------------------------------
2. GET PLAYER DATA
```lua
local data = PlayerStore:Get(player.UserId)

if data then
    print(data.Coins)
end
```

--------------------------------
3. SET PLAYER DATA
```lua
PlayerStore:Set(player.UserId, {
    Coins = 100,
    Level = 2
}, player.Name)
```

--------------------------------
4. UPDATE PLAYER DATA
```lua
PlayerStore:Update(player.UserId, function(current)
    current.Coins += 10
    return current
end)
```

--------------------------------
DEFAULT DATA TEMPLATE
--------------------------------
```lua
local DEFAULT_DATA = {
    Coins = 0,
    Level = 1,
    Inventory = {}
}
```


--------------------------------
PLAYER HANDLING (RECOMMENDED)
--------------------------------

PlayerAdded:
```lua
Players.PlayerAdded:Connect(function(player)
    local data = PlayerStore:Get(player.UserId)

    if not data then
        data = table.clone(DEFAULT_DATA)
        PlayerStore:Set(player.UserId, data, player.Name)
    end
end)
```

PlayerRemoving:
```lua
Players.PlayerRemoving:Connect(function(player)
    local data = PlayerStore:Get(player.UserId)

    if data then
        PlayerStore:Set(player.UserId, data, player.Name)
    end
end)
```

--------------------------------
LOCAL CACHE SYSTEM
--------------------------------

- Data is cached in memory (Data.lua)
- Reduces HTTP requests
- Improves performance
- Always syncs with backend on save

--------------------------------
ARCHITECTURE FLOW
--------------------------------

Roblox Game
   ↓
Lua API Wrapper
   ↓
Node.js Server (3000)
   ↓
Flask API (5000)
   ↓
SQLite Database

--------------------------------
LIST ALL DATASTORES

local list = PlayerStore.List()

--------------------------------
FULL DATASTORE DUMP

local full = PlayerStore:Full()

--------------------------------
IMPORTANT NOTES

- This is NOT Roblox DataStoreService
- Requires external server running at all times
- Do not expose localhost in production
- Always validate data before saving
- Designed for scalable multiplayer games

--------------------------------
USE CASES

- RPG systems
- Inventory systems
- Player progression
- Game analytics
- Persistent multiplayer saves
- Sends to a open source DataStore Explorer link
[DataStore-Explorer](https://sillydev2026.github.io/DataStore.io/)

--------------------------------
END
