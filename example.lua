local SQLite = require(script.SQLite)
local Store = SQLite.new("DataStore", "PlayerStore")
local Players = game:GetService("Players")
local Data = require(script.Data)

local Default_Data = {
	Coins = 0,
	Level = 1,
}

Players.PlayerAdded:Connect(function(player)
	local userId = tostring(player.UserId)

	-- try cache first
	local data = Data.Get(userId)

	if not data then
		local packet = Store:Get(userId)
		
		if packet and packet.value then
			data = packet.value
		else
			data = table.clone(Default_Data)
			Store:Set(userId, data, player.Name)
		end
		Data.Set(userId, data)
	end

	print("Loaded data for", player.Name)

	for name, v in pairs(data) do
		print(name .. " = " .. tostring(v))
	end
end)

Players.PlayerRemoving:Connect(function(player)
	local userId = tostring(player.UserId)

	local data = Data.Get(userId)

	if data then
		Store:Set(userId, data, player.Name)
	end

	Data.Remove(userId)
end)
