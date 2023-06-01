require("discordia-expanded")
local echo = {}

function echo:run(context)
    local message = context.Message
    local args = context.Args

    if #args > 0 then
        local finalString = ""
        for i, v in pairs(context.Args) do
            if string.find(v, "@") then
                v = v:gsub("@", "@​")
            end
            if i == 1 then
                finalString = v
            else
                finalString = finalString.." "..v
            end
        end
        message:reply(finalString)
    else
        message:reply("You haven't typed any text!")
    end
end

return echo
