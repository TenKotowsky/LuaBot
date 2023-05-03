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
				{name = "**QOTD commands:**", value = "`addquestion`, `setqotdchannel`, `setqotdtime`, `setqotdthreadname`", inline = false}
			},
			color = embedColor.value
		}
	}
end

function commandsModule.Ping(channel)
	channel:send("Pong!")
end

return commandsModule
