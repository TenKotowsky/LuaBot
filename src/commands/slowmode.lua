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
				embed = {
					title = "Specify slowmode duration properly!",
					description = "Having problems with the command? Try using `commandinfo "..context.CommandName.."` to get more information about it!",
					timestamp = Discordia.Date():toISO('T', 'Z'),
					color = _G.MainColor.value
				},
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
			embed = {
				title = "Specify slowmode duration properly!",
				description = "Having problems with the command? Try using `commandinfo "..context.CommandName.."` to get more information about it!",
				timestamp = Discordia.Date():toISO('T', 'Z'),
				color = _G.MainColor.value
			},
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
			embed = {
				title = "You don't have the Manage Channels permission!",
				description = "Having problems with the command? Try using `commandinfo "..context.CommandName.."` to get more information about it!",
				timestamp = Discordia.Date():toISO('T', 'Z'),
				color = _G.MainColor.value
			},
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
				embed = {
					title = "Disabled current channel's slowmode",
					timestamp = Discordia.Date():toISO('T', 'Z'),
					color = _G.MainColor.value
				},
				reference = {
					message = message,
					mention = false
				}
			}
		else
			message:reply{
				embed = {
					title = "Changed current channel's slowmode to **"..convertedSeconds.."**",
					timestamp = Discordia.Date():toISO('T', 'Z'),
					color = _G.MainColor.value
				},
				reference = {
					message = message,
					mention = false
				}
			}
		end
	end
end

return slowmode