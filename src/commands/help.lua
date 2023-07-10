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
			{name = "**You can upvote me here! <3:**", value = "https://top.gg/bot/1103273590280949800", inline = false},
			{name = "**Server prefix:**", value = prefix, inline = false},
			{name = "**General:**", value = "`help`, `commandinfo [command name]`, `patreon`, `ping`, `prefix [prefix]`, `serverinfo`, `userinfo [user]`, `avatar [user]`, `embed [text]`, `emoji [emoji]`, `reminders`, `remindme [time] [reminder]`, `removereminder [id]`", inline = false},
			{name = "**Minigames:**", value = "`wyr`, `riddle`, `rps [rock/paper/scissors]`", inline = false},
			{name = "**4Fun:**", value = "`echo`, `eightball`, `fact`, `quote`, `urbandict [term]`, `recipe [dish]`, `rhyme [word]`, `ship [user1] [user2]`, `randomnumber [min] [max]`, `spotifyartist [name]`, `spotifyalbum [name]`", inline = false},
			{name = "**Gaming:**", value = "`epicgamesfree`, `steamuser [vanity name]`, `lolprofile [region] [summoner name]`, `robloxuser [username]`", inline = false},
			{name = "**Moderation:**", value = "`ban [user] [reason]`, `tempban [user] [time] [reason]`, `kick [user]`, `mute [user] [time]`, `slowmode [time]`", inline = false},
			{name = "**Actions:**", value = "`tickle [user]`, `pat [user]`, `hug [user]`, `cuddle [user]`, `kiss [user]`, `slap [user]`, `smack [user]`", inline = false}
		},
		timestamp = Discordia.Date():toISO('T', 'Z'),
		color = _G.MainColor.value
	}

	local message, err = context.Message:reply {
		embed = embed,
		reference = {
			message = context.Message,
			mention = false
		}
	}
	if not message then
		Functions.printTable(embed)
		print(err) -- see what the error message is
	end
end

return help