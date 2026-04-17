local webhookLibrary = {}

local HttpService = cloneref(game:GetService("HttpService"))
local request = request or httprequest or http_request

local DefaultThumbnail = "https://cdn.discordapp.com/attachments/1366160415444439160/1450846645045694474/solix_logo-min_1.png?ex=694405bb&is=6942b43b&hm=084bc5cd54d82d66ac7f79fdd90c412df5071e69d1c70b9a896f707ac44c8606"
local DefaultFooter = "discord.gg/solixhub"
local BaseHeaders = { ["Content-Type"] = "application/json" }

function webhookLibrary.createMessage(properties)
	assert(properties.Url, "Url required")

	local EmbedIndex = 0

	local body = {
		username = properties.username or "",
		content = properties.content or "",
		embeds = {}
	}

	local function sendMessage()
		local Success, Response = pcall(HttpService.JSONEncode, HttpService, body)

		if not Success then
			return { Success = false, error = Response }
		end

		Success, Response = pcall(request, {
			Url = properties.Url,
			Method = "POST",
			Headers = BaseHeaders,
			Body = Response
		})

		return { Success = Success, Response = Response }
	end

	local webhookFunctions = {
		addEmbed = function(title, color, description)
			assert(title, "title required")
			assert(color, "color required")
			assert(description, "description required")

			EmbedIndex += 1
			local idx = EmbedIndex

			body.embeds[idx] = {
				title = title,
				color = tonumber(color),
				description = description,
				fields = {},
				thumbnail = { url = DefaultThumbnail },
				footer = { text = DefaultFooter },
				timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
			}

			return {
				addField = function(name, value)
					assert(name, "name required")
					assert(value, "value required")
					table.insert(body.embeds[idx].fields, { name = name, value = value })
				end
			}
		end,
		sendMessage = sendMessage
	}
	return webhookFunctions
end
return webhookLibrary
