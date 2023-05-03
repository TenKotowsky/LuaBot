local commandsModule = {}

function commandsModule.Help(channel)
	channel:send("Help")
end

function commandsModule.Ping(channel)
	channel:send("Pong!")
end

return commandsModule