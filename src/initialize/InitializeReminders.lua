local sqlite3 = require("sqlite3")
local conn = sqlite3.open("DataBase.sqlite")
local timer = require("timer")

local InitializeReminders = {}

function InitializeReminders:init()
    local reminders = conn:exec("SELECT rowid FROM reminders")
	if reminders ~= nil then
		for i, v in pairs(reminders[1]) do
			-- v[1] - rowid
			local row = tonumber(v)

			local success, res = pcall(function()
				local timeToRemind = conn:exec("SELECT time FROM reminders WHERE rowid = '"..row.."'")
				local userIdData = conn:exec("SELECT userId FROM reminders WHERE rowid = '"..row.."'")
				local userId = userIdData[1][1]
				if tonumber(timeToRemind[1][1]) and os.time() >= tonumber(timeToRemind[1][1]) then
					local user
					pcall(function()
						user = Client:getUser(userId)
					end)
					if not user then
						--retry
						pcall(function()
							user = Client:getUser(userId)
						end)
						if not user then
							return
						end
					end
					local reminderContent = conn:exec("SELECT reminder FROM reminders WHERE rowid = '"..row.."'")[1][1]

					local deleteStmt = conn:prepare("DELETE FROM reminders WHERE rowid = ?;")
					deleteStmt:reset()
					deleteStmt:bind(row):step()
					deleteStmt:close()

					user:send{
						embed = {
							title = "Reminder",
							description = reminderContent,
							color = _G.MainColor.value
						}
					}
				else
					timer.setTimeout((tonumber(timeToRemind[1][1]) - os.time()) * 1000, coroutine.wrap(function()
						local user
						pcall(function()
							user = Client:getUser(userId)
						end)
						if not user then
							--retry
							pcall(function()
								user = Client:getUser(userId)
							end)
							if not user then
								return
							end
						end
						local reminderContent = conn:exec("SELECT reminder FROM reminders WHERE rowid = '"..row.."'")[1][1]

						local deleteStmt = conn:prepare("DELETE FROM reminders WHERE rowid = ?;")
						deleteStmt:reset()
						deleteStmt:bind(row):step()
						deleteStmt:close()

						user:send{
							embed = {
								title = "Reminder",
								description = reminderContent,
								color = _G.MainColor.value
							}
						}
					end))
				end
			end)
			if not success then print(res) end
		end
	end
end

return InitializeReminders