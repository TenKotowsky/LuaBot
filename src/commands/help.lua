local sqlite3 = require("sqlite3")
local conn = sqlite3.open("DataBase.sqlite")
local BotData = require("../dependencies/BotData.lua")

local help = {}

function help:run(context)
    local prefix
	local prefixData = conn:exec("SELECT prefix FROM serverconfig WHERE guildId = '"..context.Message.guild.id.."';")
	if prefixData == nil then
		prefix = BotData.Prefix
	else
		prefix = prefixData.prefix[1]
	end

    context.Message.channel:send {
		embed = {
			title = "Info",
			description = "LuaBot is a multi-purpose Discord bot equipped with moderation tools, community managment tools and other features!",
			fields = {
				{name = "**Website:**", value = "https://tenkotowsky.github.io/", inline = false},
				{name = "**You can upvote me here! <3:**", value = "https://discordbotlist.com/bots/luabot", inline = false},
				{name = "**Server prefix:**", value = prefix, inline = false},
				{name = "**General commands:**", value = "`help`, `prefix [prefix]`, `serverinfo`, `userinfo [user]`, `avatar [user]`", inline = false},
				{name = "**Moderation commands:**", value = "`ban [user] [reason]`, `tempban [user] [days] [reason]`, `kick [user]`, `slowmode [0-21600s]`", inline = false},
				{name = "**[BETA, USE AT YOUR OWN RISK] Periodic questions (QOTD/W) related commands:**", value = "`questionperiod [day/week]`, `questionchannel [channel id]`, `questionlist`, `questionadd [question]`, `questionremove [index]`, `questiontime [hour]`", inline = false},
				{name = "**4Fun commands:**", value = "`ping`, `echo`, `eightball`, `quote`, `recipe [dish]`, `rhyme [word]`, `urbandict [term]`, `randomnumber [min] [max]`, `spotifyartist [name]`, `spotifyalbum [name]`, `robloxuser [username]`", inline = false}
			},
			color = _G.MainColor.value
		}
	}
end

return help