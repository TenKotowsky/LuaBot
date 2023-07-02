local Functions = require("../dependencies/Functions.lua")

local mute = {}

function mute:run(context)
    local message = context.Message
	local author = message.guild:getMember(message.author.id)
	local user
	if message.mentionedUsers.first then
		user = message.mentionedUsers.first
	elseif tonumber(context.Args[1]) and _G.Client:getUser(context.Args[1]) then
		user = _G.Client:getUser(context.Args[1])
	else
        message:reply{
			content = "Mention a user to be muted!",
			reference = {
				message = message,
				mention = false
			}
		}
		return
	end
    local duration
    if context.Args[2] then
		duration = Functions.convertToSeconds(context.Args[2])
		if not duration then
			message:reply{
				content = "Specify mute duration properly!",
				reference = {
					message = message,
					mention = false
				}
			}
			return
		end
    else
        message:reply{
			content = "Specify mute duration!",
			reference = {
				message = message,
				mention = false
			}
		}
		return
    end
	local member
	if not message.guild:getMember(user.id) then
		message:reply{
			content = "Couldn't find such user!",
			reference = {
				message = message,
				mention = false
			}
		}
		return
	else
		member = message.guild:getMember(user.id)
	end

	if Functions.basicChecks(message, "moderateMembers", author, member) == false then
		message:reply{
			content = "You don't have the Timeout Members permission!",
			reference = {
				message = message,
				mention = false
			}
		}
		return
	end
	local additional
	if tonumber(context.Args[2]) then
		additional = ""
	else
		additional = "("..context.Args[2]..")"
	end

	member:timeoutFor(duration)
	message:reply{
		content = "Successfully muted **"..user.username.."** for **"..duration.." seconds "..additional.."**",
		reference = {
			message = message,
			mention = false
		}
	}
end

return mute