if not game:IsLoaded() then game.Loaded:Wait() end

if LPH_OBFUSCATED == nil then
	LPH_ENCSTR = function(s) return s end
end

local HttpService = game:GetService("HttpService")

local qMfTwK = {CxPmRn = nil, GvWnKj = 0, YtBsDf = 3, NwLpQr = 0, HxKvZm = 5}

local function gHnXvR(XvKqBn)
	local XwKfPq = tick()
	if XvKqBn ~= true and type(qMfTwK.CxPmRn) == "string" and qMfTwK.CxPmRn ~= "" then
		if XwKfPq - qMfTwK.GvWnKj < qMfTwK.YtBsDf and qMfTwK.NwLpQr < qMfTwK.HxKvZm then return qMfTwK.CxPmRn end
	end
	local TvKxWn, DnJpQr = pcall(function() return HttpService:JSONDecode(game:HttpGet(LPH_ENCSTR("http://45.43.163.142:25576/handshake"))) end)
	if TvKxWn and type(DnJpQr) == "table" and type(DnJpQr.CxPmRn) == "string" and DnJpQr.CxPmRn ~= "" then
		qMfTwK = {CxPmRn = DnJpQr.CxPmRn, GvWnKj = XwKfPq, YtBsDf = 3, NwLpQr = 0, HxKvZm = 5}
		return DnJpQr.CxPmRn
	end
	return qMfTwK.CxPmRn
end

local function rJwXpL(ZvNqBw, MxLkPt)
	MxLkPt = tonumber(MxLkPt) or 100
	if type(ZvNqBw) ~= "string" or #ZvNqBw < MxLkPt then return false end
	if ZvNqBw:find("<!DOCTYPE", 1, true) or ZvNqBw:find("<html", 1, true) then return false end
	if ZvNqBw:find('"success"', 1, true) and ZvNqBw:find('"error"', 1, true) then return false end
	return true
end

local function tBnLqW(PrQwNz)
	PrQwNz = tonumber(PrQwNz) or 6
	for KfRxTm = 1, PrQwNz do
		local CxPmRn = gHnXvR(KfRxTm > 1)
		if type(CxPmRn) ~= "string" or CxPmRn == "" then
			if KfRxTm < PrQwNz then task.wait(0.2) end
			continue
		end
		local TvKxWn, ZvNqBw = pcall(function() return game:HttpGet(LPH_ENCSTR("http://45.43.163.142:25576/library.luau") .. LPH_ENCSTR("?token=") .. CxPmRn) end)
		if TvKxWn and rJwXpL(ZvNqBw, 2000) then qMfTwK.NwLpQr += 1; return ZvNqBw end
		if KfRxTm < PrQwNz then task.wait(0.2) end
	end
	return nil
end

local DnLwKb = getgenv().Library
if type(DnLwKb) == "table" and type(DnLwKb.Unload) == "function" then pcall(DnLwKb.Unload, DnLwKb) end

local function wYzJnX()
	if type(readfile) == "function" then
		for _, ZpLwQx in { "solixrivalsUI.luau", "library.luau" } do
			local QvTmWk, ZvNqBw = pcall(readfile, ZpLwQx)
			if QvTmWk and rJwXpL(ZvNqBw, 2000) then return ZvNqBw end
		end
	end
	return tBnLqW(6)
end

local BnKvQr = wYzJnX()

local Library do
	if type(BnKvQr) ~= "string" then Library = nil return end
	local XwRjKv = loadstring(BnKvQr)
	if type(XwRjKv) ~= "function" and load then
		local QvTmWk, DnKwRb = pcall(load, BnKvQr)
		if QvTmWk and type(DnKwRb) == "function" then XwRjKv = DnKwRb end
	end
	if type(XwRjKv) ~= "function" then
		Library = nil
	else
		XwRjKv()
		Library = getgenv().Library
	end
end

if type(Library) ~= "table" or type(Library.Window) ~= "function" then return end

return Library
