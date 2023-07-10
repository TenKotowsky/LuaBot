local Functions = require("../dependencies/Functions.lua")
local sqlite3 = require("sqlite3")
local conn = sqlite3.open("DataBase.sqlite")

local reminders = {}

function reminders:run(context)
    local message = context.Message
	local success, res = pcall(function()
		local authorId = message.author.id

		local rowIds = conn:exec("SELECT rowid FROM reminders WHERE userId = '"..authorId.."'")

		if rowIds and rowIds[1] then

			local finalString = ""
			local remindersAmount = 0
			for i, v in ipairs(rowIds[1]) do
				local numb = tonumber(v)
				local reminderData = conn:exec("SELECT reminder FROM reminders WHERE rowid = '"..numb.."'")
                local timeData = conn:exec("SELECT time FROM reminders WHERE rowid = '"..numb.."'")
				if reminderData then
					remindersAmount = remindersAmount + 1
					if i == 1 then
						finalString = i..".\nID: "..numb.."\nTime: ".."<t:"..tonumber(timeData[1][1])..":R>".."\n"..reminderData[1][1]
					else
						finalString = finalString.."\n"..i..".\nID: "..numb.."\nTime: ".."<t:"..tonumber(timeData[1][1])..":R>".."\n"..reminderData[1][1]
					end
				end
			end

			local fields = {
				{name = "Amount of reminders:", value = remindersAmount, inline = false},
			}

			if #finalString <= 1024 then
				table.insert(fields, {name = "Reminders:", value = finalString, inline = false})
			else
				table.insert(fields, {name = "Reminders:", value = finalString:sub(1, 1024), inline = false})
				table.insert(fields, {name = "Reminders:", value = finalString:sub(1025, #finalString), inline = false})
			end

			message:reply{
				embed = {
					title = "Reminders",
					fields = fields,
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
					title = "You don't have any reminders set!",
					timestamp = Discordia.Date():toISO('T', 'Z'),
					color = _G.MainColor.value
				},
				reference = {
					message = message,
					mention = false
				}
			}
		end
	end)
	if not success then
		print(res)
	end
end

return reminders