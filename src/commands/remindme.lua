local Functions = require("../dependencies/Functions.lua")
local sqlite3 = require("sqlite3")
local conn = sqlite3.open("DataBase.sqlite")
local timer = require("timer")

local remindme = {}

function remindme:run(context)
    local message = context.Message
	local reminder
    local duration
	if context.Args then
        if context.Args[1] then
            duration = context.Args[1]
        else
            message:reply{
                content = "You need to specify a time for the reminder!",
                reference = {
                    message = message,
                    mention = false
                }
            }
            return
        end
        if context.Args[2] then
            table.remove(context.Args, 1)
            for i, v in pairs(context.Args) do
                if i == 1 then
                    reminder = v
                else
                    reminder = reminder.." "..v
                end
            end
        else
            message:reply{
                content = "You need to specify a reminder!",
                reference = {
                    message = message,
                    mention = false
                }
            }
            return
        end
	else
        message:reply{
            content = "You need to specify a time for the reminder!",
			reference = {
				message = message,
				mention = false
			}
        }
		return
	end
    local seconds
    local time
    local success, res = pcall(function()
        seconds = Functions.convertToMinutes(duration) * 60
        time = os.time() + seconds
    end)
    if not time then
        message:reply{
            content = "You need to specify proper time for the reminder!",
			reference = {
				message = message,
				mention = false
			}
        }
        return
    end
	local success, res = pcall(function()
		local authorId = message.author.id
        
        local stmt = conn:prepare("INSERT INTO reminders VALUES(?, ?, ?);")
        stmt:reset()
        stmt:bind(authorId, time, reminder):step()
        stmt:close()

        message:reply{
            content = "A reminder will be sent to you on <t:"..time..":R>",
			reference = {
				message = message,
				mention = false
			}
        }

        timer.setTimeout(seconds * 1000, coroutine.wrap(function()

            local deleteStmt = conn:prepare("DELETE FROM reminders WHERE userId = ? AND time = ?;")
            deleteStmt:reset()
            deleteStmt:bind(authorId, time):step()
            deleteStmt:close()

            message.author:send{
                embed = {
                    title = "Reminder",
                    description = reminder,
                    timestamp = Discordia.Date():toISO('T', 'Z'),
                    color = _G.MainColor.value
                }
            }

        end))
        
	end)
	if not success then
		print(res)
	end
end

return remindme