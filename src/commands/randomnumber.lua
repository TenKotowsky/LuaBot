local randomnumber = {}

function randomnumber:run(context)
    local message = context.Message
	local argument1 = context.Args[1]
	local argument2 = context.Args[2]
	local number1
	if tonumber(argument1) then
		number1 = tonumber(argument1)
		if number1 > 1000000000000 then
			number1 = 1000000000000
		end
	else
		message:reply{
			embed = {
				title = "Enter a valid minimum number!",
				description = "Having problems with the command? Try using `commandinfo "..context.CommandName.."` to get more information about it!",
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

	local number2
	if tonumber(argument2) then
		number2 = tonumber(argument2)
		if number2 > 1000000000000 then
			number2 = 1000000000000
		end
	else
		message:reply{
			embed = {
				title = "Enter a valid maximum number!",
				description = "Having problems with the command? Try using `commandinfo "..context.CommandName.."` to get more information about it!",
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

	message:reply{
		embed = {
			title = math.random(number1, number2),
			timestamp = Discordia.Date():toISO('T', 'Z'),
			color = _G.MainColor.value
		},
		reference = {
			message = message,
			mention = false
		}
	}
end

return randomnumber