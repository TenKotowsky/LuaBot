local Functions = require("../dependencies/Functions.lua")
local sqlite3 = require("sqlite3")
local conn = sqlite3.open("DataBase.sqlite")

local questiontime = {}

function questiontime:run(context)
    local message = context.Message
	local guildId = message.guild.id
	local hour
	if context.Args and context.Args[1] then
		hour = context.Args[1]
	else
		return
	end
	local success, res = pcall(function()
		local author = message.guild:getMember(message.author.id)
		if Functions.basicChecks(message, "manageChannels", author, true) == false then
			return
		end
		if tonumber(hour) and tonumber(hour) <= 24 then
			local hour = tonumber(hour)
			if hour == 24 then
				hour = 0
			end
			local t = conn:exec("SELECT * FROM periodicquestionsconfig WHERE guildId = '"..guildId.."';")
			if not t then
				-- No rows returned, so insert a new record
				local lastTimeSent = nil
				conn:exec("INSERT INTO periodicquestionsconfig VALUES ("..guildId..", 'day', NULL, "..hour..", NULL);")
				message:reply("The time of sending period questions set to **"..hour..":00**.")
			else
				-- Rows returned, so update the existing record
				conn:exec("UPDATE periodicquestionsconfig SET time = '"..hour.."' WHERE guildId = "..guildId..";")
				message:reply("The time of sending period questions set to **"..hour..":00**.")
			end
		else
			message:reply("Add a valid hour! *(Remember to use 24-hour clock)*")
		end
	end)
	if not success then
		print(res)
	end
end

return questiontime