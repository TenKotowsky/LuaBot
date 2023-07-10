local Functions = require("../dependencies/Functions.lua")

local ban = {}

function ban:run(context)
    local message = context.Message
	local author = message.guild:getMember(message.author.id)
	local args = context.Args
	local user
	if message.mentionedUsers.first then
		user = message.mentionedUsers.first
	elseif tonumber(args[1]) and _G.Client:getUser(args[1]) then
		user = _G.Client:getUser(args[1])
	else
		message:reply{
			embed = {
				title = "Mention a user to be banned!",
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

	if Functions.basicChecks(message, "banMembers", author, member) == false then
		message:reply{
			embed = {
				title = "You don't have the Ban Members permission!",
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

	if author.highestRole.position > member.highestRole.position then
		local reason = ""
		table.remove(args, 1)

		if #args == 0 then
			reason = "Reason not provided"
		else
			for i, v in pairs(args) do
				reason = reason.." "..v
			end
		end
		member:ban(reason)
		message:reply{
			embed = {
				title = "Successfully banned **"..user.username.."**",
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
				title = "You can't ban someone whose highest role is higher than your highest role!",
				description = "Having problems with the command? Try using `commandinfo "..context.CommandName.."` to get more information about it!",
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

return ban