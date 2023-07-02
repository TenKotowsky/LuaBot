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
			context = "Enter a valid minimum number!",
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
			content = "Enter a valid maximum number!",
			reference = {
				message = message,
				mention = false
			}
		}
		return
	end

	message:reply{
		content = math.random(number1, number2),
		reference = {
			message = message,
			mention = false
		}
	}
end

return randomnumber