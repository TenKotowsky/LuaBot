local echo = {}

function echo:run(context)
    local args = context.Args

    context.Message:reply(table.concat(args, " "))
end

return echo