local corohtpp = require("coro-http")
local json = require("json")

local pat = {}

function pat:run(context)
    local message = context.Message
    local author = message.author
    local mentionedUser = message.mentionedUsers.first

    local gifInfo
    local success, res = pcall(function()
        local data, body = corohtpp.request("GET", "https://api.otakugifs.xyz/gif?reaction=pat")
        gifInfo = json.decode(body)
    end)
    if success == false then
        print(res)
    else
        message:reply{
            embed = {
                title = "**"..author.name.." pats "..mentionedUser.name.."!**",
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

return pat