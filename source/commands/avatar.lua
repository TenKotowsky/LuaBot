local avatar = {}

function avatar.Avatar(channel, embedColor, member)
	channel:send {
		embed = {
			title = member.name.."'s avatar",
			image = {url = member.avatarURL},
			color = embedColor.value
		}
	}
end

return avatar
