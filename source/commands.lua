local commandsModule = {}

function commandsModule.Help(channel, prefix, embedColor)
	channel:send {
		embed = {
			title = "Info",
			description = "LuaBot is a multi-purpose Discord bot equipped with moderation tools, community managment tools and other features!",
			fields = {
				{name = "**Invite LuaBot!**", value = "https://discord.com/oauth2/authorize?client_id=1103273590280949800&scope=bot&permissions=8", inline = false},
				{name = "**Source code:**", value = "https://github.com/TenKotowsky/LuaBot", inline = false},
				{name = "**Prefix:**", value = prefix, inline = false},
				{name = "**General commands:**", value = "`help`, `ping`", inline = false},
				{name = "**Moderation commands:**", value = "`ban [user]`, `kick [user]`, `slowmode [0-21600s]`", inline = false},
				{name = "**4Fun commands:**", value = "`quote`, `robloxuser [username]`", inline = false}
			},
			color = embedColor.value
		}
	}
end

function commandsModule.Ping(channel)
	channel:send("Pong!")
end

local quotes = {
	"In three words I can sum up everything I've learned about life: it goes on.\n- Robert Frost.",
	"When something is important enough, you do it even if the odds are not in your favor.\n- Elon Musk",
	"Life is really simple, but we insist on making it complicated.\n- Confucius",
	"Learn from yesterday, live for today, hope for tomorrow. The important thing is not to stop questioning.\n- Albert Einstein",
	"For what shall it profit a man, if he gain the whole world, and suffer the loss of his soul?\n- Jesus Christ",
	"'Tis better to have loved and lost than never to have loved at all.\n- Alfred Tennyson",
	"The most hateful human misfortune is for a wise man to have no influence.\n- Herodotus",
	"Be yourself; everyone else is already taken.\n- Oscar Wilde"
}

function commandsModule.RandomQuote(channel)
	channel:send(quotes[math.random(1,#quotes)])
end

function commandsModule.RobloxUser(channel, embedColor, data, finalThumbnailData)
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
