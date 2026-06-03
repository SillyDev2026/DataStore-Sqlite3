local HttpService = game:GetService("HttpService")

local BASE_URL = "http://127.0.0.1:3000"
local Data = require(script.Parent.Data)

local DataStore = {}
DataStore.__index = DataStore

local function request(method, path, body)
	local ok, res = pcall(function()
		if method == "GET" then
			return HttpService:GetAsync(BASE_URL .. path)
		else
			return HttpService:PostAsync(
				BASE_URL .. path,
				HttpService:JSONEncode(body or {}),
				Enum.HttpContentType.ApplicationJson
			)
		end
	end)

	if not ok then
		warn("[HTTP ERROR]", res)
		return nil
	end

	local success, decoded = pcall(function()
		return HttpService:JSONDecode(res)
	end)

	if not success then
		warn("[DECODE ERROR]", decoded)
		return nil
	end

	return decoded
end

function DataStore.new(name, scope)
	local self = setmetatable({}, DataStore)

	self.name = name
	self.scope = scope or "global"

	request("POST", "/datastore/new", {
		datastore = self.name,
		scope = self.scope
	})

	return self
end

function DataStore:Get(userId)
	userId = tostring(userId)

	local cached = Data.Get(userId)
	if cached ~= nil then
		return cached
	end

	local res = request("POST", "/datastore/get", {
		datastore = self.name,
		scope = self.scope,
		userId = userId
	})

	if not res then
		return nil
	end

	Data.Set(userId, res.value)

	return res.value
end

function DataStore:Set(userId, value, username)
	userId = tostring(userId)

	Data.Set(userId, value)

	return request("POST", "/datastore/set", {
		datastore = self.name,
		scope = self.scope,
		userId = userId,
		value = value,
		username = username
	})
end

function DataStore:Update(userId, updateFn)
	userId = tostring(userId)

	local current = Data.Get(userId)

	if current == nil then
		current = self:Get(userId) or {}
	end

	local newValue = updateFn(current)

	return self:Set(userId, newValue)
end

function DataStore.List()
	return request("GET", "/datastore/list", {})
end

function DataStore:Full()
	return request("POST", "/datastore/full", {
		datastore = self.name,
		scope = self.scope
	})
end

return DataStore
