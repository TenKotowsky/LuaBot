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
			elseif words[1]:sub(#prefix+1,#words[1]) == "questionchannel" and words[2] then
				commands.QuestionChannel(message, channel.guild.id, words[2])
			elseif words[1]:sub(#prefix+1,#words[1]) == "questiontime" and words[2] then
				commands.QuestionTime(message, channel.guild.id, words[2])
			elseif words[1]:sub(#prefix+1,#words[1]) == "questionlist" then
				commands.QuestionList(message, mainColor, channel.guild.id)
			elseif words[1]:sub(#prefix+1,#words[1]) == "questionadd" then
				local question = ""
				local selectedWords = {}
				for i, v in ipairs(words) do
					if i > 1 then
						table.insert(selectedWords, v)
					end
				end
				for i, v in pairs(selectedWords) do
					if i == 1 then
						question = v
					else
						question = question.." "..v
					end
				end
				commands.QuestionAdd(message, channel.guild.id, question)
			elseif words[1]:sub(#prefix+1,#words[1]) == "questionremove" and words[2] then
				commands.QuestionRemove(message, channel.guild.id, words[2])
			elseif words[1]:sub(#prefix+1,#words[1]) == "questionperiod" and words[2] then
				commands.QuestionPeriod(message, channel.guild.id, words[2])
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
						searchedArtist = searchedArtist.." "..v
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
						searchedAlbum = searchedAlbum.." "..v
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

local function sendQuestion(channel, questionsData, guildId)
	local questions = questionsData[1][1]
	local deserialized = {}
	for s in questions:gmatch("[^%%%%]+") do
	   table.insert(deserialized, s)
	end
	if channel and deserialized and #deserialized > 0 then
		channel:send{
			content = deserialized[1]
		}
		table.remove(deserialized, 1)
		conn:exec("UPDATE periodicquestions SET questions = '"..table.concat(deserialized, "&|&|").."' WHERE guildId = "..guildId..";")
		conn:exec("UPDATE periodicquestions SET lastTimeSent = '"..os.time().."' WHERE guildId = "..guildId..";")
	end
end

--send qotd/w
client:on("heartbeat", function(shardId, latency)
	client:setActivity("luahelp | "..#client.guilds.." servers!")
	local hour = os.date("*t").hour
	local allData = conn:exec("SELECT guildId FROM periodicquestions")
	if allData ~= nil then
		for i, v in ipairs(allData) do
			local success, result = pcall(function()
				local time = conn:exec("SELECT time FROM periodicquestions WHERE guildId = '"..v[1].."'")
				if time and hour == time[1][1] then
					local guild = (client:getGuild(v[1]))
					local channelId = conn:exec("SELECT channelId FROM periodicquestions WHERE guildId = '"..v[1].."'")
					local questionsData = conn:exec("SELECT questions FROM periodicquestions WHERE guildId = '"..v[1].."'")
					if channelId and questionsData then
						local channel = guild:getChannel(channelId[1][1])
						local lastTimeSent = conn:exec("SELECT lastTimeSent FROM periodicquestions WHERE guildId = '"..v[1].."'")
						local periodData = conn:exec("SELECT period FROM periodicquestions WHERE guildId = '"..v[1].."'")
						if lastTimeSent and lastTimeSent[1][1] and periodData and periodData[1][1] then
							-- Convert the Unix timestamp to a Lua os.date object
							local datetime_obj = os.date("*t", tonumber(lastTimeSent[1][1]))

							if periodData[1][1] == "day" then
								
								local newDate = os.date("*t", os.time({year=datetime_obj.year, month=datetime_obj.month, day=datetime_obj.day+1}))

								if os.date("*t", os.time()).day == newDate.day then
									sendQuestion(channel, questionsData, v[1])
								end
							elseif periodData[1][1] == "week" then

								local newDate = os.date("*t", os.time({year=datetime_obj.year, month=datetime_obj.month, day=datetime_obj.day+7}))

								if os.date("*t", os.time()).day == newDate.day then
									sendQuestion(channel, questionsData, v[1])
								end
							end
						else
							sendQuestion(channel, questionsData, v[1])
						end
					end
				end
			end)
			if not success then print(result) end
		end
	end
end)

client:run(token)
