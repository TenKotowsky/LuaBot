local commandsModule = {}

function commandsModule.Help(channel, prefix, embedColor)
	channel:send {
		embed = {
			title = "Info",
			description = "LuaBot is a multi-purpose Discord bot equipped with moderation tools, community managment tools and other features!",
			fields = {
				{name = "**Source code:**", value = "https://github.com/TenKotowsky/LuaBot", inline = false},
				{name = "**Prefix:**", value = prefix, inline = false},
				{name = "**General commands:**", value = "`help`, `ping`", inline = false},
				{name = "**QOTD commands (upcoming):**", value = "`addquestion`, `setqotdchannel`, `setqotdtime`, `setqotdthreadname`", inline = false},
				{name = "**4Fun commands:**", value = "`robloxuserinfo [username]`", inline = false}
			},
			color = embedColor.value
		}
	}
end

function commandsModule.Ping(channel)
	channel:send("Pong!")
end

function commandsModule.RobloxUserInfo(channel, embedColor, data, finalThumbnailData)
	print(finalThumbnailData.imageUrl)
	if data and finalThumbnailData then
		local verifiedMsg = "Not verified"
		if data.hasVerifiedBadge then
			verifiedMsg = "Verified"
		end
		channel:send {
			embed = {
				title = "Roblox user info",
				description = data.displayName.." ("..data.name..")",
				thumbnail = {url = finalThumbnailData.imageUrl},
				fields = {
					{name = "Verification status:", value = verifiedMsg, inline = false},
					{name = "User ID:", value = data.id, inline = false}
				},
				color = embedColor.value
			}
		}
	end
end

return commandsModule
