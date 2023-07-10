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
			embed = {
				title = "Mention a user to be kicked!",
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
	local member
	if not message.guild:getMember(user.id) then
		message:reply{
			embed = {
				title = "Couldn't find such user!",
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
	else
		member = message.guild:getMember(user.id)
	end

	if Functions.basicChecks(message, "kickMembers", author, member) == false then
		message:reply{
			embed = {
				title = "You don't have the Kick Members permission!",
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

	member:kick()
	message:reply{
		embed = {
			title = "Successfully kicked **"..user.username.."**",
			timestamp = Discordia.Date():toISO('T', 'Z'),
			color = _G.MainColor.value
		},
		reference = {
			message = message,
			mention = false
		}
	}
end

return kick