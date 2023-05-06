local userinfo = {}

function userinfo.UserInfo(guild, channel, embedColor, user)
	local member = guild:getMember(user.id)
	local dateCreated = math.floor(tonumber(user.createdAt))
	if member then
		if member.nickname ~= nil then
			channel:send {
				embed = {
					title = user.name,
					thumbnail = {url = user.avatarURL},
					fields = {
						{name = "**Nickname:**", value = member.nickname, inline = false},
						{name = "**ID:**", value = user.id, inline = false},
						{name = "**Joined Discord:**", value = "<t:"..dateCreated..":R>", inline = false},
						{name = "**Joined this server:**", value = "<t:"..dateCreated..":R>", inline = false}
					},
					color = embedColor.value
				}
			}
		else
			channel:send {
				embed = {
					title = user.name,
					thumbnail = {url = user.avatarURL},
					fields = {
						{name = "**ID:**", value = user.id, inline = false},
						{name = "**Joined Discord:**", value = "<t:"..dateCreated..":R>", inline = false},
						{name = "**Joined this server:**", value = "<t:"..dateCreated..":R>", inline = false}
					},
					color = embedColor.value
				}
			}
		end	
	end
end

return userinfo
