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
		return
	end
	local member
	if not message.guild:getMember(user.id) then
		message:reply("Couldn't find such user!")
		return
	else
		member = message.guild:getMember(user.id)
	end

	if Functions.basicChecks(message, "kickMembers", author, member) == false then
		return
	end

	member:kick()
	message:reply("Successfully kicked **"..user.username.."**")
end

return kick