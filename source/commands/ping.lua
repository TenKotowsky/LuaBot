local ping = {}

function ping.Ping(channel)
	channel:send("Pong!")
end

return ping