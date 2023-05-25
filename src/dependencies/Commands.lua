local Commands = {}

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

local kick = require("../commands/kick.lua")
function Commands.Kick(context)
	kick:run(context)
end

local slowmode = require("../commands/slowmode.lua")
function Commands.Slowmode(context)
	slowmode:run(context)
end

local questionchannel = require("../commands/questionchannel.lua")
function Commands.QuestionChannel(context)
	questionchannel:run(context)
end

local questionperiod = require("../commands/questionperiod.lua")
function Commands.QuestionPeriod(context)
	questionperiod:run(context)
end

local questionadd = require("../commands/questionadd.lua")
function Commands.QuestionAdd(context)
	questionadd:run(context)
end

local questionlist = require("../commands/questionlist.lua")
function Commands.QuestionList(context)
	questionlist:run(context)
end

local questionremove = require("../commands/questionremove.lua")
function Commands.QuestionRemove(context)
	questionremove:run(context)
end

local questiontime = require("../commands/questiontime.lua")
function Commands.QuestionTime(context)
	questiontime:run(context)
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

local quote = require("../commands/quote.lua")
function Commands.Quote(context)
	quote:run(context)
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

local eightball = require("../commands/eightball.lua")
function Commands.EightBall(context)
	eightball:run(context)
end

return Commands