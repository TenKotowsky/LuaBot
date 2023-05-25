local embed = {}

function embed:run(context)
    local message = context.Message
    local channel = message.channel
    local args = context.Args
    if #args > 0 then
        local finalString = ""
        for i, v in pairs(context.Args) do
            if i == 1 then
                finalString = v
            else
                finalString = finalString.." "..v
            end
        end
        channel:send{
            embed = {
                description = finalString,
                color = _G.MainColor.value
            }
        }
    else
        message:reply("You haven't typed any text!")
    end
end

return embed