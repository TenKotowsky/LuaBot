require("discordia-expanded")
local Functions = require("../dependencies/Functions.lua")
local sqlite3 = require("sqlite3")
local conn = sqlite3.open("DataBase.sqlite")

local removereminder = {}

function removereminder:run(context)
    local message = context.Message
    local authorId = message.author.id
	local index
	if context.Args and context.Args[1] then
		index = context.Args[1]
	else
		return
	end
	local success, res = pcall(function()
		local index = tonumber(index)
		if index then
			local data = conn:exec("SELECT * FROM reminders WHERE rowid = '"..index.."'")
			if data then
				if authorId == data[1][1] then
					conn:exec("DELETE FROM reminders WHERE rowid = '"..index.."';")
					message:reply("Removed the reminder!")
				else
					message:reply("Couldn't find a reminder with such id!")
				end
			end
		else
			message:reply("Provide a proper reminder index!")
		end
	end)
	if not success then
		print(res)
	end
end

return removereminder