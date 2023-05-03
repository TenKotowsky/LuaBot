local commands = require("../../commands")
local botData = require("../../botData")
local discordia = require("discordia")
local client = discordia.Client()
local token = botData.Token
local prefix = botData.Prefix

local mainColor = discordia.Color.fromHex("#000080")

client:once("ready", function()
	print("Logged in as ".. client.user.username)
end)

client:on('messageCreate', function(message)
	local content = message.content
	local channel = message.channel
	if content:sub(1,#prefix) == prefix then

		if content:sub(4,#content) == "help" then
			commands.Help(channel, prefix, mainColor)
		elseif content:sub(4,#content) == "ping" then
			commands.Ping(channel)
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
