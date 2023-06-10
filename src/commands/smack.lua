require("discordia-expanded")
local corohtpp = require("coro-http")
local json = require("json")

local smack = {}

function smack:run(context)
    local message = context.Message
    local author = message.author
    local mentionedUser = message.mentionedUsers.first

    local gifInfo
    local success, res = pcall(function()
        local data, body = corohtpp.request("GET", "https://api.otakugifs.xyz/gif?reaction=smack")
        gifInfo = json.decode(body)
    end)
    if success == false then
        print(res)
    else
        message.channel:send{
            embed = {
                title = "**"..author.name.." smacks "..mentionedUser.name.."!**",
                image = {url = gifInfo.url},
                color = _G.MainColor.value
            }
        }
    end
end

return smack