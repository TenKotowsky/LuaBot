local Functions = require("../dependencies/Functions.lua")

local slowmode = {}

function slowmode:run(context)
    local message = context.Message
	local limitArg = context.Args[1]

	local channel = message.channel
	local limit
	if limitArg then
		limit = Functions.convertToSeconds(limitArg)
		if not limit then
			message:reply{
				content = "Specify slowmode duration properly!",
				reference = {
					message = message,
					mention = false
				}
			}
			return
		elseif limit > 21600 then
			limit = 21600
		end
	else
		message:reply{
			content = "Please specify slowmode's duration in seconds!",
			reference = {
				message = message,
				mention = false
			}
		}
		return
	end

	local author = message.guild:getMember(message.author.id)
	if Functions.basicChecks(message, "manageChannels", author, true) == false then
		message:reply{
			content = "You don't have the Manage Channels permission!",
			reference = {
				message = message,
				mention = false
			}
		}
		return
	end

	if channel.type == 0 then
		channel:setRateLimit(limit)
		local convertedSeconds = Functions.secondsToHMS(limit)
		if convertedSeconds == "0 seconds" then
			message:reply{
				content = "Disabled current channel's slowmode",
				reference = {
					message = message,
					mention = false
				}
			}
		else
			message:reply{
				context = "Changed current channel's slowmode to **"..convertedSeconds.."**",
				reference = {
					message = message,
					mention = false
				}
			}
		end
	end
end

return slowmode