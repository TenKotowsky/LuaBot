local Functions = require("../dependencies/Functions.lua")
require("discordia-expanded")

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
        message:reply("this is not a proper emoji")
        return
    elseif not Functions.is_url_image(url) then
        if Functions.is_url_image("https://cdn.discordapp.com/emojis/"..emojiId..".png") then
            url = "https://cdn.discordapp.com/emojis/"..emojiId..".png"
        else
            message:reply("this is not a proper emoji")
            return
        end
    end

    if emojiname == nil then
        message:reply("This is not a proper emoji")
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
		color = _G.MainColor.value
	}
    message:reply{
        embed = embed
    }
end

return emoji