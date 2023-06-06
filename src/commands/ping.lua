require("discordia-expanded")
local time = Discordia.Stopwatch()

local ping = {}

function ping:run(context)
    local message = context.Message
    time:reset()
    time:start()
    local pingMessage = message:reply("Pong! :ping_pong:")
    time:stop()
    if pingMessage then
        pingMessage:setContent("Pong! :ping_pong:\n"..tostring(time:getTime():toMilliseconds() .. "ms"))
    end
end

return ping