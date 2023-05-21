local ping = {}

function ping:run(context)
    context.Message:reply("Pong!")
end

return ping