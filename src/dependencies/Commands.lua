local Commands = {}

local commandinfo = require("../commands/commandinfo.lua")
function Commands.CommandInfo(context)
	commandinfo:run(context)
end

local help = require("../commands/help.lua")
function Commands.Help(context)
	help:run(context)
end

local prefix = require("../commands/prefix.lua")
function Commands.Prefix(context)
	prefix:run(context)
end

local serverinfo = require("../commands/serverinfo.lua")
function Commands.ServerInfo(context)
	serverinfo:run(context)
end

local userinfo = require("../commands/userinfo.lua")
function Commands.UserInfo(context)
	userinfo:run(context)
end

local avatar = require("../commands/avatar.lua")
function Commands.Avatar(context)
	avatar:run(context)
end

local ban = require("../commands/ban.lua")
function Commands.Ban(context)
	ban:run(context)
end

local tempban = require("../commands/tempban.lua")
function Commands.TempBan(context)
	tempban:run(context)
end

local kick = require("../commands/kick.lua")
function Commands.Kick(context)
	kick:run(context)
end

local mute = require("../commands/mute.lua")
function Commands.Mute(context)
	mute:run(context)
end

local slowmode = require("../commands/slowmode.lua")
function Commands.Slowmode(context)
	slowmode:run(context)
end

local ping = require("../commands/ping.lua")
function Commands.Ping(context)
    ping:run(context)
end

local echo = require("../commands/echo.lua")
function Commands.Echo(context)
    echo:run(context)
end

local embed = require("../commands/embed.lua")
function Commands.Embed(context)
	embed:run(context)
end

local ship = require("../commands/ship.lua")
function Commands.Ship(context)
    ship:run(context)
end

local quote = require("../commands/quote.lua")
function Commands.Quote(context)
	quote:run(context)
end

local riddle = require("../commands/riddle.lua")
function Commands.Riddle(context)
	riddle:run(context)
end


local fact = require("../commands/fact.lua")
function Commands.Fact(context)
	fact:run(context)
end

local recipe = require("../commands/recipe.lua")
function Commands.Recipe(context)
	recipe:run(context)
end

local rhyme = require("../commands/rhyme.lua")
function Commands.Rhyme(context)
	rhyme:run(context)
end

local urbandict = require("../commands/urbandict.lua")
function Commands.UrbanDict(context)
	urbandict:run(context)
end

local randomnumber = require("../commands/randomnumber.lua")
function Commands.RandomNumber(context)
	randomnumber:run(context)
end

local rps = require("../commands/rps.lua")
function Commands.RPS(context)
	rps:run(context)
end

local spotifyartist = require("../commands/spotifyartist.lua")
function Commands.SpotifyArtist(context)
	spotifyartist:run(context)
end

local spotifyalbum = require("../commands/spotifyalbum.lua")
function Commands.SpotifyAlbum(context)
	spotifyalbum:run(context)
end

local robloxuser = require("../commands/robloxuser.lua")
function Commands.RobloxUser(context)
	robloxuser:run(context)
end

local lolprofile = require("../commands/lolprofile.lua")
function Commands.LOLProfile(context)
	lolprofile:run(context)
end

local eightball = require("../commands/eightball.lua")
function Commands.EightBall(context)
	eightball:run(context)
end

local wyr = require("../commands/wyr.lua")
function Commands.WYR(context)
	wyr:run(context)
end

local epicgamesfree = require("../commands/epicgamesfree.lua")
function Commands.EpicGamesFree(context)
	epicgamesfree:run(context)
end

local steamuser = require("../commands/steamuser.lua")
function Commands.SteamUser(context)
	steamuser:run(context)
end

local patreon = require("../commands/patreon.lua")
function Commands.Patreon(context)
	patreon:run(context)
end

local emoji = require("../commands/emoji.lua")
function Commands.Emoji(context)
	emoji:run(context)
end

local remindme = require("../commands/remindme.lua")
function Commands.RemindMe(context)
	remindme:run(context)
end

local reminders = require("../commands/reminders.lua")
function Commands.Reminders(context)
	reminders:run(context)
end

local removereminder = require("../commands/removereminder.lua")
function Commands.RemoveReminder(context)
	removereminder:run(context)
end

local tickle = require("../commands/tickle.lua")
function Commands.Tickle(context)
	tickle:run(context)
end
local pat = require("../commands/pat.lua")
function Commands.Pat(context)
	pat:run(context)
end
local hug = require("../commands/hug.lua")
function Commands.Hug(context)
	hug:run(context)
end
local cuddle = require("../commands/cuddle.lua")
function Commands.Cuddle(context)
	cuddle:run(context)
end
local kiss = require("../commands/kiss.lua")
function Commands.Kiss(context)
	kiss:run(context)
end
local slap = require("../commands/slap.lua")
function Commands.Slap(context)
	slap:run(context)
end
local smack = require("../commands/smack.lua")
function Commands.Smack(context)
	smack:run(context)
end

return Commands