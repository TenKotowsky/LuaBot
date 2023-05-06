local commands = require("../../commands")
local botData = require("../../botData")
local discordia = require("discordia")
local coroutine = require("coroutine")
local client = discordia.Client()
local token = botData.Token
local prefix = botData.Prefix

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
	if content:sub(1,#prefix) == prefix then

		if content:sub(4,#content) == "help" then
			commands.Help(channel, prefix, mainColor)
		elseif content:sub(4,#content) == "ping" then
			commands.Ping(channel)
		elseif content:sub(4,#content) == "quote" then
			commands.RandomQuote(channel)
		else
			local words = splitMessage(content)
			if words[1]:sub(4,#words[1]) == "robloxuser" and words[2] then
				commands.RobloxUser(channel, mainColor, words)
			elseif words[1]:sub(4,#words[1]) == "ban" then
				commands.Ban(message)
			elseif words[1]:sub(4,#words[1]) == "kick" then
				commands.Kick(message)
			elseif words[1]:sub(4,#words[1]) == "slowmode" then
				commands.Slowmode(message, words)
			elseif words[1]:sub(4,#words[1]) == "userinfo" and words[2] then
				commands.UserInfo(message.guild, channel, mainColor, message.mentionedUsers.first)
			elseif words[1]:sub(4,#words[1]) == "avatar" and words[2] then
				commands.Avatar(channel, mainColor, message.mentionedUsers.first)
			elseif words[1]:sub(4,#words[1]) == "randomnumber" and words[2] and words[3] then
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
