if not game:IsLoaded() then game.Loaded:Wait() end

if LPH_OBFUSCATED == nil then
	LPH_ENCSTR = function(s) return s end
end

local HttpService = game:GetService("HttpService")

local api_token_cache = { token = nil, fetched_at = 0, ttl = 3, uses = 0, max_uses = 5 }

local function api_handshake_token(force_refresh)
	local now_time = tick()

	if force_refresh ~= true and type(api_token_cache.token) == "string" and api_token_cache.token ~= "" then
		if now_time - api_token_cache.fetched_at < api_token_cache.ttl and api_token_cache.uses < api_token_cache.max_uses then
			return api_token_cache.token
		end
	end

	local ok, data = pcall(function()
		return HttpService:JSONDecode(game:HttpGet(LPH_ENCSTR("http://45.43.163.142:25576/handshake")))
	end)

	if ok and type(data) == "table" and type(data.token) == "string" and data.token ~= "" then
		api_token_cache = { token = data.token, fetched_at = now_time, ttl = 3, uses = 0, max_uses = 5 }
		return data.token
	end

	return api_token_cache.token
end

local function is_valid_lua_asset_body(body, min_length)
	min_length = tonumber(min_length) or 100

	if type(body) ~= "string" or #body < min_length then return false end
	if body:find("<!DOCTYPE", 1, true) or body:find("<html", 1, true) then return false end
	if body:find('"success"', 1, true) and body:find('"error"', 1, true) then return false end

	return true
end

local function fetch_cdn_library(max_attempts)
	max_attempts = tonumber(max_attempts) or 6

	for attempt = 1, max_attempts do
		local token = api_handshake_token(attempt > 1)

		if type(token) ~= "string" or token == "" then
			if attempt < max_attempts then task.wait(0.2) end
			continue
		end

		local ok, body = pcall(function()
			return game:HttpGet(LPH_ENCSTR("http://45.43.163.142:25576/library.luau") .. LPH_ENCSTR("?token=") .. token)
		end)

		if ok and is_valid_lua_asset_body(body, 2000) then
			api_token_cache.uses += 1
			return body
		end

		if attempt < max_attempts then task.wait(0.2) end
	end
	return nil
end

local function load_bootstrap_library(source_body)
	if type(source_body) ~= "string" or not is_valid_lua_asset_body(source_body, 2000) then
		source_body = fetch_cdn_library(6)
	end

	if not is_valid_lua_asset_body(source_body, 2000) then return nil end

	local chunk = loadstring(source_body)

	if type(chunk) ~= "function" and load then
		local ok_load, loaded_chunk = pcall(load, source_body)

		if ok_load and type(loaded_chunk) == "function" then chunk = loaded_chunk end
	end
	if type(chunk) ~= "function" then return nil end
	local ok_run = pcall(chunk)

	if not ok_run then return nil end

	if type(getgenv().Library) == "table" and type(getgenv().Library.Window) == "function" then
		return getgenv().Library
	end

	return nil
end

local function load_ui_library()
	if type(readfile) == "function" then
		for _, path in { "solixrivalsUI.luau", "library.luau" } do
			local ok_read, body = pcall(readfile, path)

			if ok_read and is_valid_lua_asset_body(body, 2000) then
				local library = load_bootstrap_library(body)

				if type(library) == "table" then return library end
			end
		end
	end
	return load_bootstrap_library(nil)
end

local old_library = getgenv().Library

if type(old_library) == "table" and type(old_library.Unload) == "function" then
	pcall(old_library.Unload, old_library)
end

local Library = load_ui_library()

if type(Library) ~= "table" or type(Library.Window) ~= "function" then
	return warn("[SolixHub.com] UI library failed to load")
end

getgenv().Library = Library

return Library
