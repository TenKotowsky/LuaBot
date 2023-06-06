require("discordia-expanded")
local Functions = require("../dependencies/Functions.lua")

local slowmode = {}

function slowmode:run(context)
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
	if Functions.basicChecks(message, "manageChannels", author, true) == false then
		return
	end

	if channel.type == 0 then
		channel:setRateLimit(limit)
		local convertedSeconds = Functions.secondsToHMS(limit)
		if convertedSeconds == "0 seconds" then
			message:reply("Disabled current channel's slowmode")
		else
			message:reply("Changed current channel's slowmode to **"..convertedSeconds.."**")
		end
	end
end

return slowmode