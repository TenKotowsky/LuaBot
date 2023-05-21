local serverinfo = {}
function serverinfo:run(context)
    local message = context.Message
	local guild = message.guild
	local serverFeatures = ""
	if #guild.features ~= 0 then
		for i, v in pairs(guild.features) do
			if i == 1 then
				serverFeatures = v
			else
				serverFeatures  = serverFeatures.."\n"..v
			end
		end
	else
		serverFeatures = "None"
	end
	if guild.description ~= nil then
		message.channel:send {
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
				color = _G.MainColor.value
			}
		}
	else
		message.channel:send {
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
				color = _G.MainColor.value
			}
		}
	end
end

return serverinfo