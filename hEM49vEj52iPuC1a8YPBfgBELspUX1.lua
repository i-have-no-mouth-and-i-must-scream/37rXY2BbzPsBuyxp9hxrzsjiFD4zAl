local Webhook = {}

local HttpService = cloneref(game:GetService("HttpService")) or game:GetService("HttpService")
local Request = request or httprequest or http_request

function Webhook.CreateMessage(Url, Username, Content)
	local data = {
		username = Username or "",
		content = Content or "",
		embeds = {}
	}

	local embeds = {}

	local function send()
		Request({
			Url = Url,
			Method = "POST",
			Headers = {["Content-Type"] = "application/json"},
			Body = HttpService:JSONEncode(data)
		})
	end

	local webhook = {}

	function webhook:AddEmbed(title, description)
		local embed = {
			title = title or "",
			color = math.random(0, 16777215),
			description = description or "",
			fields = {},
			thumbnail = {url = "https://cdn.discordapp.com/attachments/1366160415444439160/1450846645045694474/solix_logo-min_1.png"},
			footer = {text = "discord.gg/solixhub"},
			timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
		}

		table.insert(data.embeds, embed)
		table.insert(embeds, embed)

		local embed = {}

		function embed:AddField(name, value)
			table.insert(embed.fields, {
				name = name or "",
				value = value or ""
			})
		end

		return embed
	end
	function main:Send()
		send()
	end
	return main
end

return Webhook