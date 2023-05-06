local corohttp = require("../../deps/coro-http")
local json = require("json")

local help = require("../../commands/help")
local ping = require("../../commands/ping")
local avatar = require("../../commands/avatar")
local ban = require("../../commands/ban")
local kick = require("../../commands/kick")
local slowmode = require("../../commands/slowmode")
local quote = require("../../commands/quote")
local randomnumber = require("../../commands/randomnumber")
local robloxuser = require("../../commands/robloxuser")

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

local commandsModule = {}

function commandsModule.Help(channel, prefix, embedColor)
	help.Help(channel, prefix, embedColor)
end

function commandsModule.Ping(channel)
	ping.Ping(channel)
end

function commandsModule.RandomQuote(channel)
	local header = {
		{"X-Api-Key", "HHRHB6I+UTHeeZJx1ZWNBA==17idOV9lboycNcUD"}
	}

	local res, quoteData = corohttp.request("GET", "https://api.api-ninjas.com/v1/quotes", header)
	local finalQuoteData = json.decode(quoteData)[1]

	if finalQuoteData and finalQuoteData.quote then
		channel:send(finalQuoteData.quote.."\n- "..finalQuoteData.author)
	else
		print(res)
		quote.Quote(channel)
	end
end

function commandsModule.RandomNumber(message, argument1, argument2)
	randomnumber.RandomNumber(message, argument1, argument2)
end

function commandsModule.RobloxUser(channel, embedColor, words)
	--general info
	local infobody = {
		usernames = {
			words[2]
		},
		excludeBannedUsers = true
	}
	local url = "https://users.roblox.com/v1/usernames/users"
	local body = {
		content = "Hello There!\nThis is an example for a POST request using coro-http!"
	}
	local encodedBody = require("json").encode(infobody)
	
	local headers = {
		{"Content-Length", tostring(#encodedBody)},
		{"Content-Type", "application/json"},
	}
		
	local res, body = corohttp.request("POST", url, headers, encodedBody, 5000)
	local finalData = json.decode(body).data
	
	--thumbnail
	local res, thumbnailBody = corohttp.request("GET", "https://thumbnails.roblox.com/v1/users/avatar-bust?userIds="..finalData[1].id.."&size=180x180&format=Png&isCircular=false")
	local finalThumbnailData = json.decode(thumbnailBody).data
	
	robloxuser.RobloxUser(channel, embedColor, finalData[1], finalThumbnailData[1])
end

function commandsModule.Avatar(channel, embedColor, member)
	avatar.Avatar(channel, embedColor, member)
end

function commandsModule.Ban(message)
	local author = message.guild:getMember(message.author.id)
	local member = message.mentionedUsers.first

	if basicChecks(message, "banMembers", author, member) == false then
		return
	end

	for user in message.mentionedUsers:iter() do
		-- Check if mention isn't a reply
		if string.find(message.content, "<@[!]?" .. user.id .. ">") then
			member = message.guild:getMember(user.id)
			member:ban()
			message:reply("Successfully banned **"..user.username.."**")
		end
	end
end

function commandsModule.Kick(message)
	local author = message.guild:getMember(message.author.id)
	local member = message.mentionedUsers.first

	if basicChecks(message, "kickMembers", author, member) == false then
		return
	end

	for user in message.mentionedUsers:iter() do
		-- Check if mention isn't a reply
		if string.find(message.content, "<@[!]?" .. user.id .. ">") then
			member = message.guild:getMember(user.id)
			member:kick()
			message:reply("Successfully kicked **"..user.username.."**")
		end
	end
end

function commandsModule.Slowmode(message, words)
	local channel = message.channel
	local limit
	if tonumber(words[2]) then
		limit = tonumber(words[2])
		if limit > 21600 then
			limit = 21600
		end
	else
		message:reply("Please specify slowmode's duration in seconds!")
		return
	end

	local author = message.guild:getMember(message.author.id)
	if basicChecks(message, "banMembers", author, true) == false then
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

return commandsModule
