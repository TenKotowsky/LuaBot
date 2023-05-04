local commands = require("../../commands")
local botData = require("../../botData")
local discordia = require("discordia")
local corohttp = require("coro-http")
local coroutine = require("coroutine")
local json = require("json")
local client = discordia.Client()
local token = botData.Token
local prefix = botData.Prefix

local mainColor = discordia.Color.fromHex("#000080")

client:once("ready", function()
	print("Logged in as ".. client.user.username)
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

local function basicChecks(message, author, member, permission)
	if author.bot then return false end
	if not member then
		-- The user have not mentioned any member to be banned
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
		end
		return false
	end
end

client:on('messageCreate', function(message)
	local content = message.content
	local channel = message.channel
	if content:sub(1,#prefix) == prefix then

		if content:sub(4,#content) == "help" then
			commands.Help(channel, prefix, mainColor)
		elseif content:sub(4,#content) == "ping" then
			commands.Ping(channel)
		elseif content:sub(4,#content) == "quote" then
			local header = {
				{"X-Api-Key", "HHRHB6I+UTHeeZJx1ZWNBA==17idOV9lboycNcUD"}
				}

			local res, quoteData = corohttp.request("GET", "https://api.api-ninjas.com/v1/quotes", header)
			local finalQuoteData = json.decode(quoteData)[1]

			if finalQuoteData and finalQuoteData.quote then
				channel:send(finalQuoteData.quote.."\n- "..finalQuoteData.author)
			else
				print(res)
				commands.RandomQuote(channel)
			end
		else
			local words = splitMessage(content)
			if words[1]:sub(4,#words[1]) == "robloxuser" and words[2] then
				coroutine.wrap(function()
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

					commands.RobloxUser(channel, mainColor, finalData[1], finalThumbnailData[1])
				end)()
			elseif words[1]:sub(4,#words[1]) == "ban" then

				local author = message.guild:getMember(message.author.id)
				local member = message.mentionedUsers.first

				if basicChecks(message, author, member, "banMembers") == false then
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
			elseif words[1]:sub(4,#words[1]) == "kick" then

				local author = message.guild:getMember(message.author.id)
				local member = message.mentionedUsers.first

				if basicChecks(message, author, member, "kickMembers") == false then
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
		end
	elseif message.mentionedUsers then
		for i, v in pairs(message.mentionedUsers) do
			if v.id == "1103273590280949800" then
				commands.Help(channel, prefix, mainColor)
				break
			end
		end
	end
end)

client:run(token)
