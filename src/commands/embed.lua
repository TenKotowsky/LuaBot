local embed = {}

function embed:run(context)
    local message = context.Message
    local args = context.Args
    if #args > 0 then
        message:reply{
            embed = {
                description = table.concat(args),
                timestamp = Discordia.Date():toISO('T', 'Z'),
                color = _G.MainColor.value
            },
			reference = {
				message = message,
				mention = false
			}
        }
    else
        message:reply{
            embed = {
				title = "You haven't typed any text!",
				description = "Having problems with the command? Try using `commandinfo "..context.CommandName.."` to get more information about it!",
				timestamp = Discordia.Date():toISO('T', 'Z'),
				color = _G.MainColor.value
			},
			reference = {
				message = message,
				mention = false
			}
        }
    end
end

return embed