local corohttp = require("coro-http")
local json = require("json")
local base64 = require("base64")
local sqlite3 = require("sqlite3")
local conn = sqlite3.open("DataBase.sqlite")
local BotData = require("../dependencies/BotData.lua")

local Commands = {}

local function basicChecks(message, permission, author, member)
	if author.bot then return false end
	if not member then
		-- The user have not mentioned any member to be banned/kicked
		if permission == "banMembers" then
			message:reply("Please mention someone to ban!")
		elseif permission == "kickMembers" then
			message:reply("Please mention someone to kick!")
		end
		return false
	elseif not author:hasPermission(permission) then
		-- The user does not have enough permissions
		if permission == "banMembers" then
			message:reply("You don't have permission to ban members!")
		elseif permission == "kickMembers" then
			message:reply("You don't have permission to kick members!")
		elseif permission == "manageChannels" then
			message:reply("You don't have permission to manage channels!")
		elseif permission == "manageGuild" then
			message:reply("You don't have permission to manage server!")
		end
		return false
	end
end
local function secondsToHMS(seconds)
	local seconds = tonumber(seconds)
  
	if seconds <= 0 then
	  return "0 seconds";
	else
	  local hours = string.format("%02.f", math.floor(seconds/3600));
	  local mins = string.format("%02.f", math.floor(seconds/60 - (hours*60)));
	  local secs = string.format("%02.f", math.floor(seconds - hours*3600 - mins *60));
	  if tonumber(hours) > 0 then
		return hours.." hours "..mins.." minutes "..secs.." seconds"
	  elseif tonumber(mins) > 0 then
		return mins.." minutes "..secs.." seconds"
	  else
		return secs.." seconds"
	  end
	end
end
local function milliToHuman(milliseconds)
    local totalseconds = math.floor(milliseconds / 1000)
    milliseconds = milliseconds % 1000
    local seconds = totalseconds % 60
    local minutes = math.floor(totalseconds / 60)
    local hours = math.floor(minutes / 60)
    minutes = minutes % 60
    if hours > 0 then
        return string.format("%02d:%02d:%02d", hours, minutes, seconds)
    else
        return string.format("%02d:%02d", minutes, seconds)
    end
end

function Commands.Help(context)
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
				{name = "**Source code:**", value = "https://github.com/TenKotowsky/LuaBot", inline = false},
				{name = "**Server prefix:**", value = prefix, inline = false},
				{name = "**General commands:**", value = "`help`, `prefix [prefix]`, `serverinfo`, `userinfo [user]`, `avatar [user]`", inline = false},
				{name = "**Moderation commands:**", value = "`ban [user]`, `kick [user]`, `slowmode [0-21600s]`", inline = false},
				{name = "**[BETA, USE AT YOUR OWN RISK] Periodic questions (QOTD/W) related commands:**", value = "`questionperiod [day/week]`, `questionchannel [channel id]`, `questionlist`, `questionadd [question]`, `questionremove [index]`, `questiontime [hour]`", inline = false},
				{name = "**4Fun commands:**", value = "`ping`, `echo`, `quote`, `randomnumber [min] [max]`, `spotifyartist [name]`, `spotifyalbum [name]`, `robloxuser [username]`", inline = false}
			},
			color = _G.MainColor.value
		}
	}
end

function Commands.Prefix(context)
	local message = context.Message
	local guildId = context.Message.guild.id
	local author = message.guild:getMember(message.author.id)
	if basicChecks(message, "manageGuild", author, true) == false then
		return
	end
	local prefix
	if context.Args and context.Args[1] then
		prefix = context.Args[1]
	end
	if prefix then
		if #prefix > 10 then
			message:reply("The prefix can't have more than 10 characters!")
		else
			local t = conn:exec("SELECT * FROM serverconfig WHERE guildId = '"..guildId.."';")
			if not t then
				-- No rows returned, so insert a new record
				conn:exec("INSERT INTO serverconfig VALUES("..guildId..", '"..prefix.."');")
				message:reply("This server's prefix has been changed to "..prefix)
			else
				-- Rows returned, so update the existing record
				conn:exec("UPDATE serverconfig SET prefix = '"..prefix.."' WHERE guildId = "..guildId..";")
				message:reply("This server's prefix has been changed to "..prefix)
			end
		end
	end
end

function Commands.ServerInfo(context)
	local message = context.Message
	local guild = message.guild
	if guild.description ~= nil then
		message.channel:send {
			embed = {
				title = guild.name,
				thumbnail = {url = guild.iconURL},
				fields = {
					{name = "**Server description:**", value = guild.description, inline = false},
					{name = "**Server created:**", value = "<t:"..math.floor(tonumber(guild.createdAt))..":R>", inline = true},
					{name = "**Server boost level:**", value = guild.premiumTier, inline = true},
					{name = "**Members:**", value = guild.totalMemberCount, inline = true},
					{name = "**Text channels:**", value = #guild.textChannels, inline = true},
					{name = "**Voice channels:**", value = #guild.voiceChannels, inline = true},
					{name = "**Server ID:**", value = guild.id, inline = true}
				},
				color = _G.MainColor.value
			}
		}
	else
		message.channel:send {
			embed = {
				title = guild.name,
				thumbnail = {url = guild.iconURL},
				fields = {
					{name = "**Server created:**", value = "<t:"..math.floor(tonumber(guild.createdAt))..":R>", inline = true},
					{name = "**Server boost level:**", value = guild.premiumTier, inline = true},
					{name = "**Members:**", value = guild.totalMemberCount, inline = true},
					{name = "**Text channels:**", value = #guild.textChannels, inline = true},
					{name = "**Voice channels:**", value = #guild.voiceChannels, inline = true},
					{name = "**Server ID:**", value = guild.id, inline = true}
				},
				color = _G.MainColor.value
			}
		}
	end
end

function Commands.UserInfo(context)
	local message = context.Message
	local user
	if message.mentionedUsers.first then
		user = message.mentionedUsers.first
	elseif tonumber(context.Args[1]) and _G.Client:getUser(context.Args[1]) then
		user = _G.Client:getUser(context.Args[1])
	else
		return
	end
	local dateCreated = math.floor(tonumber(user.createdAt))
	if message.guild:getMember(user.id) then
		local member = message.guild:getMember(user.id)
		if member.nickname ~= nil then
			message.channel:send {
				embed = {
					title = user.name,
					thumbnail = {url = user.avatarURL},
					fields = {
						{name = "**Nickname:**", value = member.nickname, inline = false},
						{name = "**ID:**", value = user.id, inline = false},
						{name = "**Joined Discord:**", value = "<t:"..dateCreated..":R>", inline = false},
						{name = "**Joined this server:**", value = "<t:"..dateCreated..":R>", inline = false}
					},
					color = _G.MainColor.value
				}
			}
		else
			message.channel:send {
				embed = {
					title = user.name,
					thumbnail = {url = user.avatarURL},
					fields = {
						{name = "**ID:**", value = user.id, inline = false},
						{name = "**Joined Discord:**", value = "<t:"..dateCreated..":R>", inline = false},
						{name = "**Joined this server:**", value = "<t:"..dateCreated..":R>", inline = false}
					},
					color = _G.MainColor.value
				}
			}
		end
	else
		message.channel:send {
			embed = {
				title = user.name,
				thumbnail = {url = user.avatarURL},
				fields = {
					{name = "**ID:**", value = user.id, inline = false},
					{name = "**Joined Discord:**", value = "<t:"..dateCreated..":R>", inline = false}
				},
				color = _G.MainColor.value
			}
		}
	end
end

function Commands.Avatar(context)
	local message = context.Message
	local user
	if message.mentionedUsers.first then
		user = message.mentionedUsers.first
	elseif tonumber(context.Args[1]) and _G.Client:getUser(context.Args[1]) then
		user = _G.Client:getUser(context.Args[1])
	else
		return
	end
	message.channel:send {
		embed = {
			title = user.name.."'s avatar",
			image = {url = user.avatarURL},
			color = _G.MainColor.value
		}
	}
end

function Commands.Ban(context)
	local message = context.Message
	local author = message.guild:getMember(message.author.id)
	local user
	if message.mentionedUsers.first then
		user = message.mentionedUsers.first
	elseif tonumber(context.Args[1]) and _G.Client:getUser(context.Args[1]) then
		user = _G.Client:getUser(context.Args[1])
	else
		return
	end
	local member
	if not message.guild:getMember(user.id) then
		message:reply("Couldn't find such user!")
		return
	else
		member = message.guild:getMember(user.id)
	end

	if basicChecks(message, "banMembers", author, member) == false then
		return
	end

	member:ban()
	message:reply("Successfully banned **"..user.username.."**")
end

function Commands.Kick(context)
	local message = context.Message
	local author = message.guild:getMember(message.author.id)
	local user
	if message.mentionedUsers.first then
		user = message.mentionedUsers.first
	elseif tonumber(context.Args[1]) and _G.Client:getUser(context.Args[1]) then
		user = _G.Client:getUser(context.Args[1])
	else
		return
	end
	local member
	if not message.guild:getMember(user.id) then
		message:reply("Couldn't find such user!")
		return
	else
		member = message.guild:getMember(user.id)
	end

	if basicChecks(message, "kickMembers", author, member) == false then
		return
	end

	member:kick()
	message:reply("Successfully kicked **"..user.username.."**")
end

function Commands.Slowmode(context)
	local message = context.Message
	local limitArg = context.Args[1]

	local channel = message.channel
	local limit
	if limitArg and tonumber(limitArg) then
		limit = tonumber(limitArg)
		if limit > 21600 then
			limit = 21600
		end
	else
		message:reply("Please specify slowmode's duration in seconds!")
		return
	end

	local author = message.guild:getMember(message.author.id)
	if basicChecks(message, "manageChannels", author, true) == false then
		return
	end

	if channel.type == 0 then
		channel:setRateLimit(limit)
		local convertedSeconds = secondsToHMS(limit)
		if convertedSeconds == "0 seconds" then
			message:reply("Disabled current channel's slowmode")
		else
			message:reply("Changed current channel's slowmode to **"..convertedSeconds.."**")
		end
	end
end

function Commands.QuestionChannel(context)
	local message = context.Message
	local guildId = message.guild.id
	local channelId
	if context.Args and context.Args[1] then
		channelId = context.Args[1]
	else
		return
	end
	local success, res = pcall(function()
		local author = message.guild:getMember(message.author.id)
		if basicChecks(message, "manageChannels", author, true) == false then
			return
		end
		if not tonumber(channelId) then
			message:reply("Add a proper channel ID!")
		else
			local t = conn:exec("SELECT * FROM periodicquestionsconfig WHERE guildId = '"..guildId.."';")
			if not t then
				-- No rows returned, so insert a new record
				conn:exec("INSERT INTO periodicquestionsconfig VALUES("..guildId..", '".."day".."', "..channelId..", NULL, NULL);")
				message:reply("Periodic question channel has been changed to <#"..channelId..">")
			else
				-- Rows returned, so update the existing record
				conn:exec("UPDATE periodicquestionsconfig SET channelId = "..channelId.." WHERE guildId = "..guildId..";")
				message:reply("Periodic question channel has been changed to <#"..channelId..">")
			end
		end
	end)
	if not success then
		print(res)
	end
end

function Commands.QuestionPeriod(context)
	local message = context.Message
	local guildId = message.guild.id
	local period
	if context.Args and context.Args[1] then
		period = context.Args[1]
	else
		return
	end
	local success, res = pcall(function()
		local author = message.guild:getMember(message.author.id)
		if basicChecks(message, "manageChannels", author, true) == false then
			return
		end
		if period ~= "day" and period ~= "week" then
			message:reply("Add a proper period (day/week)!")
		else
			local t = conn:exec("SELECT * FROM periodicquestionsconfig WHERE guildId = '"..guildId.."';")
			if not t then
				-- No rows returned, so insert a new record
				conn:exec("INSERT INTO periodicquestionsconfig VALUES("..guildId..", '"..period.."', NULL, NULL, NULL);")
				local modeName
				if period == "day" then
					modeName = "QOTD"
				else
					modeName = "QOTW"
				end
				message:reply("Period has been changed to "..period.." **("..modeName..")**.")
			else
				-- Rows returned, so update the existing record
				conn:exec("UPDATE periodicquestionsconfig SET period = '"..period.."' WHERE guildId = "..guildId..";")
				local modeName
				if period == "day" then
					modeName = "QOTD"
				else
					modeName = "QOTW"
				end
				message:reply("Period has been changed to "..period.." **("..modeName..")**.")
			end
		end
	end)
	if not success then
		print(res)
	end
end

function Commands.QuestionAdd(context)
	local message = context.Message
	local guildId = message.guild.id
	local question
	if context.Args and context.Args[1] then
		for i, v in pairs(context.Args) do
			if i == 1 then
				question = v
			else
				question = question.." "..v
			end
		end
	else
		return
	end
	local success, res = pcall(function()
		local author = message.guild:getMember(message.author.id)
		if basicChecks(message, "manageChannels", author, true) == false then
			return
		end
		if not question or #question < 0 then
			message:reply("Add a proper question!")
		else
			-- No rows returned, so insert a new record
			conn:exec("INSERT INTO periodicquestions VALUES("..guildId..", '"..question.."');")
			message:reply("Added question to the pool!")
		end
	end)
	if not success then
		message:reply("An error occured while trying to add this question!\n"..res)
		print(res)
	end
end

function Commands.QuestionList(context)
	local message = context.Message
	local guildId = message.guild.id
	local success, res = pcall(function()
		local author = message.guild:getMember(message.author.id)
		if basicChecks(message, "manageChannels", author, true) == false then
			return
		end

		local rowIds = conn:exec("SELECT rowid FROM periodicquestions WHERE guildid = '"..guildId.."'")

		if rowIds and rowIds[1] then

			local finalString = ""
			local questionsAmount = 0
			for i, v in ipairs(rowIds[1]) do
				local numb = tonumber(v)
				local questionData = conn:exec("SELECT question FROM periodicquestions WHERE rowid = '"..numb.."'")
				if questionData then
					questionsAmount = questionsAmount + 1
					if i == 1 then
						finalString = i..".\nID: "..numb.."\n"..questionData[1][1]
					else
						finalString = finalString.."\n"..i..".\nID: "..numb.."\n"..questionData[1][1]
					end
				end
			end

			message:reply{
				embed = {
					title = "Question pool",
					fields = {
						{name = "Amount of questions:", value = questionsAmount, inline = false},
						{name = "Questions: ", value = finalString, inline = false}
					},
					color = _G.MainColor.value
				}
			}
		else
			message:reply("The question pool is empty!")
		end
	end)
	if not success then
		print(res)
	end
end

function Commands.QuestionRemove(context)
	local message = context.Message
	local guildId = message.guild.id
	local index
	if context.Args and context.Args[1] then
		index = context.Args[1]
	else
		return
	end
	local success, res = pcall(function()
		local author = message.guild:getMember(message.author.id)
		if basicChecks(message, "manageChannels", author, true) == false then
			return
		end
		local index = tonumber(index)
		if index then
			local row = conn:exec("SELECT * FROM periodicquestions WHERE rowid = '"..index.."'")
			if row then
				if guildId == row[1][1] then
					conn:exec("DELETE FROM periodicquestions WHERE rowid = '"..index.."';")
					message:reply("Removed the question from the pool!")
				else
					message:reply("Couldn't find a question with such id in this guild!")
				end
			end
		else
			message:reply("Provide a proper question index!")
		end
	end)
	if not success then
		print(res)
	end
end

function Commands.QuestionTime(context)
	local message = context.Message
	local guildId = message.guild.id
	local hour
	if context.Args and context.Args[1] then
		hour = context.Args[1]
	else
		return
	end
	local success, res = pcall(function()
		local author = message.guild:getMember(message.author.id)
		if basicChecks(message, "manageChannels", author, true) == false then
			return
		end
		if tonumber(hour) and tonumber(hour) <= 24 then
			local hour = tonumber(hour)
			if hour == 24 then
				hour = 0
			end
			local t = conn:exec("SELECT * FROM periodicquestionsconfig WHERE guildId = '"..guildId.."';")
			if not t then
				-- No rows returned, so insert a new record
				local lastTimeSent = nil
				conn:exec("INSERT INTO periodicquestionsconfig VALUES ("..guildId..", 'day', NULL, "..hour..", NULL);")
				message:reply("The time of sending period questions set to **"..hour..":00**.")
			else
				-- Rows returned, so update the existing record
				conn:exec("UPDATE periodicquestionsconfig SET time = '"..hour.."' WHERE guildId = "..guildId..";")
				message:reply("The time of sending period questions set to **"..hour..":00**.")
			end
		else
			message:reply("Add a valid hour! *(Remember to use 24-hour clock)*")
		end
	end)
	if not success then
		print(res)
	end
end

function Commands.Ping(context)
    context.Message:reply("Pong!")
end

function Commands.Echo(context)
    local args = context.Args

    context.Message:reply(table.concat(args, " "))
end

function Commands.Quote(context)
	local message = context.Message
	local channel = message.channel
	local header = {
		{"X-Api-Key", "HHRHB6I+UTHeeZJx1ZWNBA==17idOV9lboycNcUD"}
	}

	local res, quoteData = corohttp.request("GET", "https://api.api-ninjas.com/v1/quotes", header)
	local finalQuoteData = json.decode(quoteData)[1]

	if finalQuoteData and finalQuoteData.quote then
		channel:send(finalQuoteData.quote.."\n- "..finalQuoteData.author)
	else
		print(res)
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
		channel:send(quotes[math.random(1,#quotes)])
	end
end

function Commands.RandomNumber(context)
	local message = context.Message
	local argument1 = context.Args[1]
	local argument2 = context.Args[2]
	local number1
	if tonumber(argument1) then
		number1 = tonumber(argument1)
		if number1 > 1000000000000 then
			number1 = 1000000000000
		end
	else
		message:reply("Enter a valid minimum number!")
		return
	end

	local number2
	if tonumber(argument2) then
		number2 = tonumber(argument2)
		if number2 > 1000000000000 then
			number2 = 1000000000000
		end
	else
		message:reply("Enter a valid maximum number!")
		return
	end

	message:reply(math.random(number1, number2))
end

local function getSpotifyToken(clientId, clientSecret)
	local headers = {
		{"Authorization", "Basic "..base64.encode(clientId..":"..clientSecret)},
		{"Content-Type", "application/x-www-form-urlencoded"},
	}

	local res, body = corohttp.request("POST", "https://accounts.spotify.com/api/token", headers, "grant_type=client_credentials")
	return json.decode(body).access_token
end
local function getSpotifyAuthHeader(token)
	return {{"Authorization", "Bearer "..token}}
end
local function getSpotifySongsByArtist(token, artistId)
	local url = "https://api.spotify.com/v1/artists/"..artistId.."/top-tracks?country=US"
	local headers = getSpotifyAuthHeader(token)

	local res, body = corohttp.request("GET", url, headers)
	return json.decode(body)
end
local function getAlbumTracks(token, albumId)
	local url = "https://api.spotify.com/v1/albums/"..albumId.."/tracks?q=&limit=49"
	local headers = getSpotifyAuthHeader(token)

	local res, body = corohttp.request("GET", url, headers)
	return json.decode(body)
end
function Commands.SpotifyArtist(context)
	local message = context.Message
	local channel = message.channel
	local args = context.Args
	local artistName = ""
	for _, v in pairs(args) do
		artistName = artistName.."%20"..v
	end
	local token
	local decodedData
	local success, res = pcall(function()
		token = getSpotifyToken(BotData.SpotifyClientId, BotData.SpotifySecret)
		local url = "https://api.spotify.com/v1/search"
		local headers = getSpotifyAuthHeader(token)
		local query = "?q="..artistName.."&type=artist&limit=1"
		local queryUrl = url..query

		local res, body = corohttp.request("GET", queryUrl, headers)
		decodedData = json.decode(body).artists.items
	end)
	if success then
		if decodedData[1] then
			local tracksData = getSpotifySongsByArtist(token, decodedData[1].id)
			if tracksData then
				local artistData = decodedData[1]
				local fieldsT = {
					{name = "Followers:", value = artistData.followers.total, inline = false}
				}
				for i, v in pairs(tracksData.tracks) do
					table.insert(fieldsT, #fieldsT + 1, {name = "Top "..tostring(i).." track: ", value = v.name, inline = false})
				end
				channel:send {
					embed = {
						title = artistData.name,
						url = artistData.external_urls.spotify,
						thumbnail = {url = artistData.images[1].url},
						fields = fieldsT,
						color = _G.MainColor.value
					}
				}
			end
		else
			message:reply("No artist with this name was found!")
		end
	else
		message:reply("An error occured while trying to get artist info!")
	end
end

function Commands.SpotifyAlbum(context)
	local message = context.Message
	local channel = message.channel
	local args = context.Args
	local albumName = ""
	for _, v in pairs(args) do
		albumName = albumName.."%20"..v
	end
	local token
	local decodedData
	local success, res = pcall(function()
		token = getSpotifyToken(BotData.SpotifyClientId, BotData.SpotifySecret)
		local url = "https://api.spotify.com/v1/search"
		local headers = getSpotifyAuthHeader(token)
		local query = "?q="..albumName.."&type=album&limit=1"
		local queryUrl = url..query

		local res, body = corohttp.request("GET", queryUrl, headers)
		decodedData = json.decode(body).albums.items
	end)

	if success then
		if decodedData[1] then
			local albumTracks = getAlbumTracks(token, decodedData[1].id).items
			if decodedData[1] then
				local albumData = decodedData[1]
				local fieldsT = {
					{name = "Type:", value = albumData.album_type:gsub("^%l", string.upper), inline = false}
				}
				for i, v in pairs(albumTracks) do
					local artists = ""
					for ii, vv in pairs(v.artists) do
						if ii == 1 then
							artists = vv.name
						else
							artists = artists..", "..vv.name
						end
					end
				   table.insert(fieldsT, #fieldsT + 1, {name = i..". "..v.name.." ("..milliToHuman(v.duration_ms)..")", value = artists, inline = false})
				end
				if #fieldsT <= 25 then
					channel:send {
						embed = {
							title = albumData.name,
							url = albumData.external_urls.spotify,
							thumbnail = {url = albumData.images[1].url},
							fields = fieldsT,
							color = _G.MainColor.value
						}
					}
				else
					channel:send {
						embed = {
							title = albumData.name,
							url = albumData.external_urls.spotify,
							thumbnail = {url = albumData.images[1].url},
							fields = fieldsT,
							color = _G.MainColor.value
						}
					}
					local secondFieldsT = {}
					for i, v in ipairs(fieldsT) do
						if i > 25 then
							table.insert(secondFieldsT, v)
						end
					end
					channel:send {
						embed = {
							title = albumData.name,
							url = albumData.external_urls.spotify,
							thumbnail = {url = albumData.images[1].url},
							fields = secondFieldsT,
							color = _G.MainColor.value
						}
					}
				end
			end
		else
			message:reply("No album with this name was found!")
		end
	else
		message:reply("An error occured while trying to get album info!")
	end
end

function Commands.RobloxUser(context)
	if context.Args and context.Args[1] then
		--general info
		local infobody = {
			usernames = {
				context.Args[1]
			},
			excludeBannedUsers = true
		}
		local url = "https://users.roblox.com/v1/usernames/users"
		local encodedBody = json.encode(infobody)
		
		local headers = {
			{"Content-Length", tostring(#encodedBody)},
			{"Content-Type", "application/json"},
		}
			
		local res, body = corohttp.request("POST", url, headers, encodedBody, 5000)
		local finalData = json.decode(body).data

		if not finalData[1] then
			context.Message:reply("Couldn't find such user!")
			return
		end
		
		--thumbnail
		local res, thumbnailBody = corohttp.request("GET", "https://thumbnails.roblox.com/v1/users/avatar-bust?userIds="..finalData[1].id.."&size=180x180&format=Png&isCircular=false")
		local finalThumbnailData = json.decode(thumbnailBody)
		if finalThumbnailData then
			finalThumbnailData = finalThumbnailData.data
		else
			finalThumbnailData = nil
		end
		
		if finalData[1] then
			if finalThumbnailData and finalThumbnailData[1] then
				local data = finalData[1]
				local verifiedMsg = "Not verified"
				if data.hasVerifiedBadge then
					verifiedMsg = "Verified"
				end
				context.Message.channel:send {
					embed = {
						title = "Roblox user info",
						description = data.displayName.." ("..data.name..")",
						thumbnail = {url = finalThumbnailData[1].imageUrl},
						fields = {
							{name = "Verification status:", value = verifiedMsg, inline = false},
							{name = "User ID:", value = data.id, inline = false}
						},
						color = _G.MainColor.value
					}
				}
			else
				local data = finalData[1]
				local verifiedMsg = "Not verified"
				if data.hasVerifiedBadge then
					verifiedMsg = "Verified"
				end
				context.Message.channel:send {
					embed = {
						title = "Roblox user info",
						description = data.displayName.." ("..data.name..")",
						fields = {
							{name = "Verification status:", value = verifiedMsg, inline = false},
							{name = "User ID:", value = data.id, inline = false}
						},
						color = _G.MainColor.value
					}
				}
			end
		end
	end
end

return Commands