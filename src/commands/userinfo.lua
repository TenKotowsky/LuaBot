require("discordia-expanded")
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
		message:reply("You need to specify a user!")
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
					color = _G.MainColor.value
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
					color = _G.MainColor.value
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
				color = _G.MainColor.value
			}
		}
	end
end

return userinfo