local randomnumber = {}

function randomnumber.RandomNumber(message, argument1, argument2)
	local number1
	if tonumber(argument1) then
		number1 = tonumber(argument1)
		if number1 > 1000000000000 then
			number1 = 1000000000000
		end
	else
		message:reply("Enter a valid minimum number!")
		return
	end

	local number2
	if tonumber(argument2) then
		number2 = tonumber(argument2)
		if number2 > 1000000000000 then
			number2 = 1000000000000
		end
	else
		message:reply("Enter a valid maximum number!")
		return
	end

	message:reply(math.random(number1, number2))
end

return randomnumber