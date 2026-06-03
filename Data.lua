local Data = {}
local cache = {}

function Data.Get(userId)
	return cache[userId]
end

function Data.Set(userId, value)
	cache[userId] = value
end

function Data.Remove(userId)
	cache[userId] = nil
end

function Data.GetAll()
	return cache
end

return Data
