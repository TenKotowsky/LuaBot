require("discordia-expanded")
local embed = {}

function embed:run(context)
    local message = context.Message
    local args = context.Args
    if #args > 0 then
        message:reply{
            embed = {
                description = table.concat(args),
                color = _G.MainColor.value
            }
        }
    else
        message:reply("You haven't typed any text!")
    end
end

return embed