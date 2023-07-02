local Functions = require("../dependencies/Functions.lua")

local kick = {}

function kick:run(context)
    local message = context.Message
	local author = message.guild:getMember(message.author.id)
	local user
	if message.mentionedUsers.first then
		user = message.mentionedUsers.first
	elseif tonumber(context.Args[1]) and _G.Client:getUser(context.Args[1]) then
		user = _G.Client:getUser(context.Args[1])
	else
		message:reply{
			content = "Mention a user to be kicked!",
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

	if Functions.basicChecks(message, "kickMembers", author, member) == false then
		message:reply{
			content = "You don't have the Kick Members permission!",
			reference = {
				message = message,
				mention = false
			}
		}
		return
	end

	member:kick()
	message:reply{
		content = "Successfully kicked **"..user.username.."**",
		reference = {
			message = message,
			mention = false
		}
	}
end

return kick