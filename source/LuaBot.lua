local commands = require("../../commands")
local botData = require("../../botData")
local discordia = require("discordia")
local coroutine = require("coroutine")
local client = discordia.Client()
local token = botData.Token
local sqlite3 = require("../../deps/sqlite3")
local conn = sqlite3.open("DataBase.sqlite")

local mainColor = discordia.Color.fromHex("#000080")

client:once("ready", function()
	print("Logged in as ".. client.user.username)
	client:setActivity("luahelp | "..#client.guilds.." servers!")
end)

local function splitMessage(inputstr, sep)
	if sep == nil then
			sep = "%s"
	end
	local t={}
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
			table.insert(t, str)
	end
	return t
end

client:on('messageCreate', function(message)
	local content = message.content
	local channel = message.channel
	local guildId = tonumber(channel.guild.id)
	local prefix
	local prefixData = conn:exec("SELECT prefix FROM serverconfig WHERE guildId = '"..guildId.."';")
	if prefixData == nil then
		prefix = botData.Prefix
	else
		prefix = prefixData.prefix[1]
	end

	if content:sub(1,#prefix) == prefix then

		if content:sub(#prefix+1,#content) == "help" then
			commands.Help(channel, prefix, mainColor)
		elseif content:sub(#prefix+1,#content) == "ping" then
			commands.Ping(channel)
		elseif content:sub(#prefix+1,#content) == "quote" then
			commands.RandomQuote(channel)
		else
			local words = splitMessage(content)
			if words[1]:sub(#prefix+1,#words[1]) == "robloxuser" and words[2] then
				commands.RobloxUser(channel, mainColor, words)
			elseif words[1]:sub(#prefix+1,#words[1]) == "ban" then
				commands.Ban(message)
			elseif words[1]:sub(#prefix+1,#words[1]) == "kick" then
				commands.Kick(message)
			elseif words[1]:sub(#prefix+1,#words[1]) == "slowmode" then
				commands.Slowmode(message, words)
			elseif words[1]:sub(#prefix+1,#words[1]) == "prefix" and words[2] then
				commands.Prefix(message, channel.guild.id, words[2])
			elseif words[1]:sub(#prefix+1,#words[1]) == "userinfo" and words[2] then
				commands.UserInfo(message.guild, channel, mainColor, message.mentionedUsers.first)
			elseif words[1]:sub(#prefix+1,#words[1]) == "avatar" and words[2] then
				commands.Avatar(channel, mainColor, message.mentionedUsers.first)
			elseif words[1]:sub(#prefix+1,#words[1]) == "spotifyartist" and words[2] then
				local searchedArtist = ""
				local selectedWords = {}
				for i, v in ipairs(words) do
					if i > 1 then
						table.insert(selectedWords, v)
					end
				end
				for i, v in pairs(selectedWords) do
					if i == 1 then
						searchedArtist = v
					else
						searchedArtist = searchedArtist..v
					end
				end
				commands.SpotifyArtist(message, mainColor, searchedArtist, botData.SpotifyClientId, botData.SpotifySecret)
			elseif words[1]:sub(#prefix+1,#words[1]) == "spotifyalbum" and words[2] then
				local searchedAlbum = ""
				local selectedWords = {}
				for i, v in ipairs(words) do
					if i > 1 then
						table.insert(selectedWords, v)
					end
				end
				for i, v in pairs(selectedWords) do
					if i == 1 then
						searchedAlbum = v
					else
						searchedAlbum = searchedAlbum..v
					end
				end
				commands.SpotifyAlbum(message, mainColor, searchedAlbum, botData.SpotifyClientId, botData.SpotifySecret)
			elseif words[1]:sub(#prefix+1,#words[1]) == "randomnumber" and words[2] and words[3] then
				commands.RandomNumber(message, words[2], words[3])
			end
		end
	elseif message.mentionedUsers.first then
		if message.mentionedUsers.first.id == "1103273590280949800" then
			commands.Help(channel, prefix, mainColor)
		end
	end
end)

client:run(token)
