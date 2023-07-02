local CommandDescriptions = require("../dependencies/CommandDescriptions.lua")
local descriptions = CommandDescriptions.Descriptions

local commandinfo = {}

function commandinfo:run(context)
    local message = context.Message
    local commandName
    if context.Args[1] then
        commandName = string.lower(context.Args[1])
    else
        message:reply {
            content = "Specify a proper command name!",
            reference = {
                message = message,
                mention = false
            }
        }
        return
    end
    local commandInfo
    if descriptions[commandName] then
        commandInfo = descriptions[commandName]
    else
        message:reply {
            content = "Couldn't find information about this command!",
            reference = {
                message = message,
                mention = false
            }
        }
        return
    end
	message:reply {
		embed = {
			title = commandName.." command info",
            description = commandInfo.Description,
            fields = {
                {name = "Arguments:", value = commandInfo.Arguments},
                {name = "Category:", value = commandInfo.Category}
            },
            timestamp = Discordia.Date():toISO('T', 'Z'),
            color = _G.MainColor.value
		},
		reference = {
			message = message,
			mention = false
		}
	}
end

return commandinfo