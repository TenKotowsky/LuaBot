local Functions = require("../dependencies/Functions.lua")
local sqlite3 = require("sqlite3")
local conn = sqlite3.open("DataBase.sqlite")

local quesitonperiod = {}

function quesitonperiod:run(context)
    local message = context.Message
	local guildId = message.guild.id
	local period
	if context.Args and context.Args[1] then
		period = context.Args[1]
	else
		return
	end
	local success, res = pcall(function()
		local author = message.guild:getMember(message.author.id)
		if Functions.basicChecks(message, "manageChannels", author, true) == false then
			return
		end
		if period ~= "day" and period ~= "week" then
			message:reply("Add a proper period (day/week)!")
		else
			local t = conn:exec("SELECT * FROM periodicquestionsconfig WHERE guildId = '"..guildId.."';")
			if not t then
				-- No rows returned, so insert a new record
				conn:exec("INSERT INTO periodicquestionsconfig VALUES("..guildId..", '"..period.."', NULL, NULL, NULL);")
				local modeName
				if period == "day" then
					modeName = "QOTD"
				else
					modeName = "QOTW"
				end
				message:reply("Period has been changed to "..period.." **("..modeName..")**.")
			else
				-- Rows returned, so update the existing record
				conn:exec("UPDATE periodicquestionsconfig SET period = '"..period.."' WHERE guildId = "..guildId..";")
				local modeName
				if period == "day" then
					modeName = "QOTD"
				else
					modeName = "QOTW"
				end
				message:reply("Period has been changed to "..period.." **("..modeName..")**.")
			end
		end
	end)
	if not success then
		print(res)
	end
end

return quesitonperiod