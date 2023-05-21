local Command = {}
Command.__index = Command

function Command.new(Name, Description, Callback)
    local self = {
        Name = Name,
        Desciption = Description,
        Callback = Callback,
    }

    setmetatable(self, Command)

    return self
end


function Command:Run(message, args)
    return self.Callback(message, table.unpack(args))
end

return Command