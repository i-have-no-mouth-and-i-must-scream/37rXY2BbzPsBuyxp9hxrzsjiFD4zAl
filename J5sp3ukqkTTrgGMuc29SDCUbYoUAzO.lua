if not game:IsLoaded() then 
	game.Loaded:Wait()
end

if not LPH_OBFUSCATED then
	LPH_ENCSTR = function(...) return ... end
	LPH_JIT_MAX = function(...) return ... end
	LPH_NO_VIRTUALIZE = function(f) return f end
	LPH_NO_UPVALUES = function(...) return ... end
	LPH_CRASH = function(...) return ... end
else
	print = function() end
	warn = function() end
end

local xYqKpR = game:GetService("HttpService")

local mZvBnT = {mQwXy = nil, bKfRt = 0, qJpLs = 3, vNxWz = 0, dGhTv = 5}

local function cWdRkX(fQpLmN)
	local tGjHvS = tick()

	if fQpLmN ~= true and type(mZvBnT.mQwXy) == "string" and mZvBnT.mQwXy ~= "" then
		if tGjHvS - mZvBnT.bKfRt < mZvBnT.qJpLs and mZvBnT.vNxWz < mZvBnT.dGhTv then
			return mZvBnT.mQwXy
		end
	end

	local kXpRwZ, dNqKsF = pcall(function()
		return xYqKpR:JSONDecode(game:HttpGet(LPH_ENCSTR("http://45.43.163.142:25576/handshake")))
	end)

	if kXpRwZ and type(dNqKsF) == "table" and type(dNqKsF.token) == "string" and dNqKsF.token ~= "" then
		mZvBnT = {mQwXy = dNqKsF.token, bKfRt = tGjHvS, qJpLs = 3, vNxWz = 0, dGhTv = 5}
		return dNqKsF.token
	end

	return mZvBnT.mQwXy
end

local function bTwYxL(wPmQrV, hJnFxK)
	hJnFxK = tonumber(hJnFxK) or 100

	if type(wPmQrV) ~= "string" or #wPmQrV < hJnFxK then
		return false
	end
	if wPmQrV:find("<!DOCTYPE", 1, true) or wPmQrV:find("<html", 1, true) then 
		return false 
	end
	if wPmQrV:find('"success"', 1, true) and wPmQrV:find('"error"', 1, true) then
		return false
	end

	return true
end

local function gLsRdM(cYvNwE)
	cYvNwE = tonumber(cYvNwE) or 6

	for pBzHkT = 1, cYvNwE do
		local qXrMwL = cWdRkX(pBzHkT > 1)

		if type(qXrMwL) ~= "string" or qXrMwL == "" then
			if pBzHkT < cYvNwE then 
				task.wait(0.3)
			end
			continue
		end

		local uJdNgS, jLpKcX = pcall(function()
			return game:HttpGet(LPH_ENCSTR("http://45.43.163.142:25576/library.luau") .. LPH_ENCSTR("?token=") .. qXrMwL)
		end)

		if uJdNgS and bTwYxL(jLpKcX, 2000) then
			mZvBnT.vNxWz = mZvBnT.vNxWz + 1
			return jLpKcX
		end

		if pBzHkT < cYvNwE then
			task.wait(0.3)
		end
	end
	return nil
end

local function vKfPqN(sYrMdT)
	if type(sYrMdT) ~= "string" or not bTwYxL(sYrMdT, 2000) then
		sYrMdT = gLsRdM(6)
	end

	if not bTwYxL(sYrMdT, 2000) then
		return nil
	end

	local rXnJwK = loadstring(sYrMdT)

	if type(rXnJwK) ~= "function" and load then
		local oMpVhY, fBdKqL = pcall(load, sYrMdT)

		if oMpVhY and type(fBdKqL) == "function" then 
			rXnJwK = fBdKqL
		end
	end

	if type(rXnJwK) ~= "function" then 
		return nil
	end

	local aCwZxJ = pcall(rXnJwK)

	if not aCwZxJ then 
		return nil
	end

	if type(getgenv().Library) == "table" and type(getgenv().Library.Window) == "function" then
		return getgenv().Library
	end

	return nil
end

local function zQrTmW()
	if type(readfile) == "function" then
		for _, yHwPdN in { "solixrivalsUI.luau", "library.luau" } do
			local eNfLqV, nBxKjR = pcall(readfile, yHwPdN)

			if eNfLqV and bTwYxL(nBxKjR, 2000) then
				local iTpSwM = vKfPqN(nBxKjR)

				if type(iTpSwM) == "table" then 
					return iTpSwM
				end
			end
		end
	end
	return vKfPqN(nil)
end

local sLjYcG = getgenv().Library

if type(sLjYcG) == "table" and type(sLjYcG.Unload) == "function" then
	pcall(sLjYcG.Unload, sLjYcG)
end

local uBxRdZ = zQrTmW()

if type(uBxRdZ) ~= "table" or type(uBxRdZ.Window) ~= "function" then
	return warn("UI library failed to load")
end

getgenv().Library = uBxRdZ

return uBxRdZ