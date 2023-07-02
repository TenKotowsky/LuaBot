local Functions = require("../dependencies/Functions.lua")

local serverinfo = {}

function serverinfo:run(context)
    local message = context.Message
	local guild = message.guild
	local serverFeatures = ""
	if #guild.features ~= 0 then
		for i, v in pairs(guild.features) do
			if i == 1 then
				serverFeatures = Functions.firstCharToUpper(string.lower(v:gsub("_", "")))
			else
				serverFeatures  = serverFeatures.."\n"..Functions.firstCharToUpper(string.lower(v:gsub("_", "")))
			end
		end
	else
		serverFeatures = "None"
	end
	if guild.description ~= nil then
		message:reply {
			embed = {
				title = guild.name,
				thumbnail = {url = guild.iconURL},
				fields = {
					{name = "**Owner:**", value = "<@"..guild.ownerId..">", inline = false},
					{name = "**Server description:**", value = guild.description, inline = false},
					{name = "**Server created:**", value = "<t:"..math.floor(tonumber(guild.createdAt))..":R>", inline = true},
					{name = "**Server boost level:**", value = guild.premiumTier, inline = true},
					{name = "**Members:**", value = guild.totalMemberCount, inline = true},
					{name = "**Text channels:**", value = #guild.textChannels, inline = true},
					{name = "**Voice channels:**", value = #guild.voiceChannels, inline = true},
					{name = "**Server ID:**", value = guild.id, inline = true},
					{name = "**Server Features:**", value = serverFeatures, inline = false}
				},
				timestamp = Discordia.Date():toISO('T', 'Z'),
				color = _G.MainColor.value
			},
			reference = {
				message = message,
				mention = false
			}
		}
	else
		message:reply {
			embed = {
				title = guild.name,
				thumbnail = {url = guild.iconURL},
				fields = {
					{name = "**Owner:**", value = "<@"..guild.ownerId..">", inline = false},
					{name = "**Server created:**", value = "<t:"..math.floor(tonumber(guild.createdAt))..":R>", inline = true},
					{name = "**Server boost level:**", value = guild.premiumTier, inline = true},
					{name = "**Members:**", value = guild.totalMemberCount, inline = true},
					{name = "**Text channels:**", value = #guild.textChannels, inline = true},
					{name = "**Voice channels:**", value = #guild.voiceChannels, inline = true},
					{name = "**Server ID:**", value = guild.id, inline = true},
					{name = "**Server Features:**", value = serverFeatures, inline = false}
				},
				timestamp = Discordia.Date():toISO('T', 'Z'),
				color = _G.MainColor.value
			},
			reference = {
				message = message,
				mention = false
			}
		}
	end
end

return serverinfo