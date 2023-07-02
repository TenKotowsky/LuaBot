local Functions = require("../dependencies/Functions.lua")

local emoji = {}

function emoji:run(context)
    local message = context.Message
    local typedEmoji = context.Args[1]

    local emojiId = nil
    local emojiname = nil
    local url = nil
    local splitString = Functions.splitString(typedEmoji, ":")
    
    if #splitString >= 3 then
        emojiname = splitString[2]
        emojiId = splitString[3]:sub(1, -2)
        url = "https://cdn.discordapp.com/emojis/"..emojiId..".gif"
    end

    if url == nil or emojiId == nil then
        message:reply{
            content = "This is not a proper emoji",
			reference = {
				message = message,
				mention = false
			}
        }
        return
    elseif not Functions.is_url_image(url) then
        if Functions.is_url_image("https://cdn.discordapp.com/emojis/"..emojiId..".png") then
            url = "https://cdn.discordapp.com/emojis/"..emojiId..".png"
        else
            message:reply{
                content = "This is not a proper emoji",
                reference = {
                    message = message,
                    mention = false
                }
            }
            return
        end
    end

    if emojiname == nil then
        message:reply{
            content = "This is not a proper emoji",
			reference = {
				message = message,
				mention = false
			}
        }
        return
    end

    local description = ""
    if emojiId then
        description = " ("..emojiId..")"
    end

    local embed = {
		title = "Enlarged emoji",
        description = emojiname..description,
		image = {url = url},
        timestamp = Discordia.Date():toISO('T', 'Z'),
		color = _G.MainColor.value
	}
    message:reply{
        embed = embed,
        reference = {
            message = message,
            mention = false
        }
    }
end

return emoji