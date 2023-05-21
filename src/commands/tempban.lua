local Functions = require("../dependencies/Functions.lua")

local tempban = {}

function tempban:run(context)
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

		if #args <= 1 then
			reason = "Reason not provided"
		end
		for i, v in pairs(args) do
            if i ~= 1 then
                reason = reason.." "..v
            end
		end
        local days
        if tonumber(args[1]) then
            days = tonumber(args[1])
        else
            message:reply("Specify a proper amount of days the user should get banned for!")
            return
        end
		member:ban(reason, days)
		message:reply("Successfully banned **"..user.username.."** for **"..days.." days**")
	else
		message:reply("You can't ban someone whose highest role is higher than your highest role!")
	end
end

return tempban