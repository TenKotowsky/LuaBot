local help = {}

function help.Help(channel, prefix, embedColor)
	channel:send {
		embed = {
			title = "Info",
			description = "LuaBot is a multi-purpose Discord bot equipped with moderation tools, community managment tools and other features!",
			fields = {
				{name = "**Website:**", value = "https://tenkotowsky.github.io/", inline = false},
				{name = "**Source code:**", value = "https://github.com/TenKotowsky/LuaBot", inline = false},
				{name = "**Server prefix:**", value = prefix, inline = false},
				{name = "**General commands:**", value = "`help`, `ping`, `prefix [prefix]`, `userinfo [user]`, `avatar [user]`", inline = false},
				{name = "**Moderation commands:**", value = "`ban [user]`, `kick [user]`, `slowmode [0-21600s]`", inline = false},
				{name = "**4Fun commands:**", value = "`quote`, `randomnumber [min] [max]`, `spotifyartist [name]`, `spotifyalbum [name]`, `robloxuser [username]`", inline = false}
			},
			color = embedColor.value
		}
	}
end

return help