require("discordia-expanded")
local sqlite3 = require("sqlite3")
local conn = sqlite3.open("DataBase.sqlite")
local BotData = require("../dependencies/BotData.lua")
local Functions = require("../dependencies/Functions.lua")

local help = {}

function help:run(context)
    local prefix
	local prefixData = conn:exec("SELECT prefix FROM serverconfig WHERE guildId = '"..context.Message.guild.id.."';")
	if prefixData == nil then
		prefix = BotData.Prefix
	else
		prefix = prefixData.prefix[1]
	end

	local embed = {
		title = "Info",
		description = "LuaBot is a multi-purpose Discord bot equipped with moderation tools, community managment tools and other features!",
		fields = {
			{name = "**Website:**", value = "https://tenkotowsky.github.io/", inline = false},
			{name = "**You can upvote me here! <3:**", value = "https://discordbotlist.com/bots/luabot", inline = false},
			{name = "**Server prefix:**", value = prefix, inline = false},
			{name = "**General:**", value = "`help`, `patreon`, `ping`, `prefix [prefix]`, `serverinfo`, `userinfo [user]`, `avatar [user]`, `embed [text]`, `emoji [emoji]`, `remindme [time] [reminder]`, `reminders`", inline = false},
			{name = "**Moderation:**", value = "`ban [user] [reason]`, `tempban [user] [hours] [reason]`, `kick [user]`, `slowmode [0-21600s]`", inline = false},
			{name = "**[BETA] Periodic questions (QOTD/W):**", value = "`questioninfo`, `questionlist`, `questionperiod [day/week]`, `questionchannel [channel id]`, `questionadd [question]`, `questionremove [index]`, `questiontime [hour]`", inline = false},
			{name = "**Actions:**", value = "`tickle [user]`, `pat [user]`, `hug [user]`, `cuddle [user]`, `kiss [user]`, `slap [user]`, `smack [user]`", inline = false},
			{name = "**Gaming:**", value = "`epicgamesfree`, `steamuser [vanity name]`, `robloxuser [username]`", inline = false},
			{name = "**4Fun:**", value = "`echo`, `eightball`, `quote`, `recipe [dish]`, `rhyme [word]`, `urbandict [term]`, `randomnumber [min] [max]`, `spotifyartist [name]`, `spotifyalbum [name]`", inline = false}
		},
		color = _G.MainColor.value
	}

	local message, err = context.Message:reply {
		embed = embed
	}
	if not message then
		Functions.printTable(embed)
		print(err) -- see what the error message is
	end
end

return help