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

					local deleteStmt = conn:prepare("DELETE FROM reminders WHERE rowid = ?;")
					deleteStmt:reset()
					deleteStmt:bind(index):step()
					deleteStmt:close()

					message:reply{
						embed = {
							title = "Removed the reminder!",
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
							title = "Couldn't find a reminder with such id!",
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
		else
			message:reply{
				embed = {
					title = "Provide a proper reminder index!",
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
	end)
	if not success then
		print(res)
	end
end

return removereminder