local Functions = require("../dependencies/Functions.lua")
local userinfo = {}

function userinfo:run(context)
    local message = context.Message
	local user
	if message.mentionedUsers.first then
		user = message.mentionedUsers.first
	elseif tonumber(context.Args[1]) and _G.Client:getUser(context.Args[1]) then
		user = _G.Client:getUser(context.Args[1])
	else
		message:reply{
			content = "You need to specify a user!",
			reference = {
				message = message,
				mention = false
			}
		}
		return
	end
	local dateCreated = math.floor(tonumber(user.createdAt))
	if message.guild:getMember(user.id) then
		local member = message.guild:getMember(user.id)
		local dateJoined = math.floor(_G.Discordia.Date.fromISO(member.joinedAt):toSeconds())
		if member.nickname ~= nil then
			message:reply {
				embed = {
					title = user.name,
					thumbnail = {url = user.avatarURL},
					fields = {
						{name = "**Nickname:**", value = member.nickname, inline = false},
						{name = "**ID:**", value = user.id, inline = false},
						{name = "**Joined Discord:**", value = "<t:"..dateCreated..":R>", inline = false},
						{name = "**Joined this server:**", value = "<t:"..dateJoined..":R>", inline = false}
					},
					timestamp = Discordia.Date():toISO('T', 'Z'),
					color = _G.MainColor.value
				},
				reference = {
					message = message,
					mention = false
				}
			}
		else
			message:reply {
				embed = {
					title = user.name,
					thumbnail = {url = user.avatarURL},
					fields = {
						{name = "**ID:**", value = user.id, inline = false},
						{name = "**Joined Discord:**", value = "<t:"..dateCreated..":R>", inline = false},
						{name = "**Joined this server:**", value = "<t:"..dateJoined..":R>", inline = false}
					},
					timestamp = Discordia.Date():toISO('T', 'Z'),
					color = _G.MainColor.value
				},
				reference = {
					message = message,
					mention = false
				}
			}
		end
	else
		message:reply {
			embed = {
				title = user.name,
				thumbnail = {url = user.avatarURL},
				fields = {
					{name = "**ID:**", value = user.id, inline = false},
					{name = "**Joined Discord:**", value = "<t:"..dateCreated..":R>", inline = false}
				},
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

return userinfo