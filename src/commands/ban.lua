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
			content = "Mention a user to be banned!",
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

	if Functions.basicChecks(message, "banMembers", author, member) == false then
		message:reply{
			content = "You don't have the Ban Members permission!",
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
			content = "Successfully banned **"..user.username.."**",
			reference = {
				message = message,
				mention = false
			}
		}
	else
		message:reply{
			content = "You can't ban someone whose highest role is higher than your highest role!",
			reference = {
				message = message,
				mention = false
			}
		}
	end
end

return ban