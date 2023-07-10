local corohtpp = require("coro-http")
local json = require("json")

local slap = {}

function slap:run(context)
    local message = context.Message
    local author = message.author
    local mentionedUser = message.mentionedUsers.first

    if not mentionedUser then
        message:reply {
            embed = {
				title = "You need someone to "..context.CommandName.."!",
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
    local gifInfo
    local success, res = pcall(function()
        local data, body = corohtpp.request("GET", "https://api.otakugifs.xyz/gif?reaction=slap")
        gifInfo = json.decode(body)
    end)
    if success == false then
        print(res)
    else
        message:reply{
            embed = {
                title = "**"..author.name.." slaps "..mentionedUser.name.."!**",
                image = {url = gifInfo.url},
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

return slap