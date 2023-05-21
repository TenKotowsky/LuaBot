local Functions = require("../dependencies/Functions.lua")
local sqlite3 = require("sqlite3")
local conn = sqlite3.open("DataBase.sqlite")

local questionremove = {}

function questionremove:run(context)
    local message = context.Message
	local guildId = message.guild.id
	local index
	if context.Args and context.Args[1] then
		index = context.Args[1]
	else
		return
	end
	local success, res = pcall(function()
		local author = message.guild:getMember(message.author.id)
		if Functions.basicChecks(message, "manageChannels", author, true) == false then
			return
		end
		local index = tonumber(index)
		if index then
			local row = conn:exec("SELECT * FROM periodicquestions WHERE rowid = '"..index.."'")
			if row then
				if guildId == row[1][1] then
					conn:exec("DELETE FROM periodicquestions WHERE rowid = '"..index.."';")
					message:reply("Removed the question from the pool!")
				else
					message:reply("Couldn't find a question with such id in this guild!")
				end
			end
		else
			message:reply("Provide a proper question index!")
		end
	end)
	if not success then
		print(res)
	end
end

return questionremove