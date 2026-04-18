local Webhook = {}

local HttpService = cloneref(game:GetService("HttpService"))
local Request = request or httprequest or http_request

function Webhook.CreateMessage(Url, Username, Content)
	local data = {
		username = Username or "",
		content = Content or "",
		embeds = {}
	}

	return {
		embeds = {},

		AddEmbed = function(Title, Color, Description)
			local embed = {
				title = Title or "",
				color = tonumber(Color) or 0,
				description = Description or "",
				fields = {},
				thumbnail = {url = "https://cdn.discordapp.com/attachments/1366160415444439160/1450846645045694474/solix_logo-min_1.png"},
				footer = {text = "discord.gg/solixhub"},
				timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
			}

			table.insert(data.embeds, embed)

			return {
				AddField = function(Name, Value, Inline)
					table.insert(embed.fields, {
						name = Name or "",
						value = Value or "",
						inline = Inline == true
					})
					return embed
				end
			}
		end,

		Send = function()
			local response = Request({
				Url = Url,
				Method = "POST",
				Headers = {["Content-Type"] = "application/json"},
				Body = HttpService:JSONEncode(data)
			})
			return response
		end
	}
end

return Webhook