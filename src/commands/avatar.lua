local avatar = {}

function avatar:run(context)
    local message = context.Message
	local user
	if message.mentionedUsers.first then
		user = message.mentionedUsers.first
	elseif tonumber(context.Args[1]) and _G.Client:getUser(context.Args[1]) then
		user = _G.Client:getUser(context.Args[1])
	else
		message:reply{
			embed = {
				title = "You need to specify a user!",
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