local userinfo = {}

function userinfo:run(context)
    local message = context.Message
	local user
	if message.mentionedUsers.first then
		user = message.mentionedUsers.first
	elseif tonumber(context.Args[1]) and _G.Client:getUser(context.Args[1]) then
		user = _G.Client:getUser(context.Args[1])
	else
		return
	end
	local dateCreated = math.floor(tonumber(user.createdAt))
	if message.guild:getMember(user.id) then
		local member = message.guild:getMember(user.id)
		if member.nickname ~= nil then
			message.channel:send {
				embed = {
					title = user.name,
					thumbnail = {url = user.avatarURL},
					fields = {
						{name = "**Nickname:**", value = member.nickname, inline = false},
						{name = "**ID:**", value = user.id, inline = false},
						{name = "**Joined Discord:**", value = "<t:"..dateCreated..":R>", inline = false},
						{name = "**Joined this server:**", value = "<t:"..dateCreated..":R>", inline = false}
					},
					color = _G.MainColor.value
				}
			}
		else
			message.channel:send {
				embed = {
					title = user.name,
					thumbnail = {url = user.avatarURL},
					fields = {
						{name = "**ID:**", value = user.id, inline = false},
						{name = "**Joined Discord:**", value = "<t:"..dateCreated..":R>", inline = false},
						{name = "**Joined this server:**", value = "<t:"..dateCreated..":R>", inline = false}
					},
					color = _G.MainColor.value
				}
			}
		end
	else
		message.channel:send {
			embed = {
				title = user.name,
				thumbnail = {url = user.avatarURL},
				fields = {
					{name = "**ID:**", value = user.id, inline = false},
					{name = "**Joined Discord:**", value = "<t:"..dateCreated..":R>", inline = false}
				},
				color = _G.MainColor.value
			}
		}
	end
end

return userinfo