local help = {}

function help.Help(channel, prefix, embedColor)
	channel:send {
		embed = {
			title = "Info",
			description = "LuaBot is a multi-purpose Discord bot equipped with moderation tools, community managment tools and other features!",
			fields = {
				{name = "**Invite LuaBot!**", value = "https://discord.com/oauth2/authorize?client_id=1103273590280949800&scope=bot&permissions=8", inline = false},
				{name = "**Source code:**", value = "https://github.com/TenKotowsky/LuaBot", inline = false},
				{name = "**Prefix:**", value = prefix, inline = false},
				{name = "**General commands:**", value = "`help`, `ping`, `avatar [user]`", inline = false},
				{name = "**Moderation commands:**", value = "`ban [user]`, `kick [user]`, `slowmode [0-21600s]`", inline = false},
				{name = "**4Fun commands:**", value = "`quote`, `randomnumber [min] [max]`, `robloxuser [username]`", inline = false}
			},
			color = embedColor.value
		}
	}
end

return help