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
            embed = {
				title = "Specify a proper command name!",
				description = "You can get a list of bot's commands using the `help` command",
				timestamp = Discordia.Date():toISO('T', 'Z'),
				color = _G.MainColor.value
			},
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
            embed = {
				title = "Couldn't find information about this command!",
				description = "You can get a list of bot's commands using the `help` command",
				timestamp = Discordia.Date():toISO('T', 'Z'),
				color = _G.MainColor.value
			},
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