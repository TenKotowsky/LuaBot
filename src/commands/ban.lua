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
		return
	end
	local member
	if not message.guild:getMember(user.id) then
		message:reply("Couldn't find such user!")
		return
	else
		member = message.guild:getMember(user.id)
	end

	if Functions.basicChecks(message, "banMembers", author, member) == false then
		return
	end

	if author.highestRole.position > member.highestRole.position then
		local reason = ""
		table.remove(args, 1)

		if #args == 0 then
			reason = "Reason not provided"
		end
		for i, v in pairs(args) do
			reason = reason.." "..v
		end
		member:ban(reason)
		message:reply("Successfully banned **"..user.username.."**")
	else
		message:reply("You can't ban someone whose highest role is higher than your highest role!")
	end
end

return ban