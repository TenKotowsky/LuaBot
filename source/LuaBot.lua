local commands = require("../../commands")
local botData = require("../../botData")
local discordia = require("discordia")
local client = discordia.Client()
local token = botData.Token
local prefix = botData.Prefix

local mainColor = discordia.Color.fromHex("#000080")

client:on("ready", function()
	print("Logged in as ".. client.user.username)
end)

client:on('messageCreate', function(message)
	local content = message.content
	if content:sub(1,#prefix) == prefix then

		local channel = message.channel

		if content:sub(4,#content) == "help" then
			commands.Help(channel, prefix, mainColor)
		elseif content:sub(4,#content) == "ping" then
			commands.Ping(channel)
		end

	end
end)

client:run(token)
