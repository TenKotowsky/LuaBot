require("discordia-expanded")
local Functions = require("../dependencies/Functions.lua")
local sqlite3 = require("sqlite3")
local conn = sqlite3.open("DataBase.sqlite")

local questionlist = {}

function questionlist:run(context)
    local message = context.Message
	local guildId = message.guild.id
	local success, res = pcall(function()
		local author = message.guild:getMember(message.author.id)
		if Functions.basicChecks(message, "manageChannels", author, true) == false then
			return
		end

		local rowIds = conn:exec("SELECT rowid FROM periodicquestions WHERE guildid = '"..guildId.."'")

		if rowIds and rowIds[1] then

			local finalString = ""
			local questionsAmount = 0
			for i, v in ipairs(rowIds[1]) do
				local numb = tonumber(v)
				local questionData = conn:exec("SELECT question FROM periodicquestions WHERE rowid = '"..numb.."'")
				if questionData then
					questionsAmount = questionsAmount + 1
					if i == 1 then
						finalString = i..".\nID: "..numb.."\n"..questionData[1][1]
					else
						finalString = finalString.."\n"..i..".\nID: "..numb.."\n"..questionData[1][1]
					end
				end
			end

			local fields = {
				{name = "Amount of questions:", value = questionsAmount, inline = false},
			}

			if #finalString <= 1024 then
				table.insert(fields, {name = "Questions: ", value = finalString, inline = false})
			else
				table.insert(fields, {name = "Questions: ", value = finalString:sub(1, 1024), inline = false})
				table.insert(fields, {name = "Questions: ", value = finalString:sub(1025, #finalString), inline = false})
			end

			message:reply{
				embed = {
					title = "Question pool",
					fields = fields,
					color = _G.MainColor.value
				}
			}

		else
			message:reply("The question pool is empty!")
		end
	end)
	if not success then
		print(res)
	end
end

return questionlist