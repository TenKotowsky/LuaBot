local avatar = {}

function avatar:run(context)
    local message = context.Message
	local user
	if message.mentionedUsers.first then
		user = message.mentionedUsers.first
	elseif tonumber(context.Args[1]) and _G.Client:getUser(context.Args[1]) then
		user = _G.Client:getUser(context.Args[1])
	else
		message:reply("You need to specify a user!")
		return
	end
	message:reply {
		embed = {
			title = user.name.."'s avatar",
			image = {url = user.avatarURL},
			timestamp = Discordia.Date():toISO('T', 'Z'),
			color = _G.MainColor.value
		},
		reference = {
			message = message,
			mention = false
		}
	}
end

return avatar