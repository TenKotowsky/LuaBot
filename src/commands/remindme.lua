require("discordia-expanded")
local Functions = require("../dependencies/Functions.lua")
local sqlite3 = require("sqlite3")
local conn = sqlite3.open("DataBase.sqlite")

local remindme = {}

function remindme:run(context)
    local message = context.Message
	local reminder
    local duration
	if context.Args then
        if context.Args[1] then
            duration = context.Args[1]
        else
            message:reply("You need to specify a time for the reminder!")
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
            message:reply("You need to specify a reminder!")
            return
        end
	else
        message:reply("You need to specify a time for the reminder!")
		return
	end
    local time
    local success, res = pcall(function()
        time = os.time() + Functions.convertToMinutes(duration) * 60
    end)
    if not time then
        message:reply("You need to specify proper time for the reminder!")
        return
    end
	local success, res = pcall(function()
		local authorId = message.author.id
        conn:exec("INSERT INTO reminders VALUES("..authorId..", "..time..", '"..reminder.."');")
        message:reply("A reminder will be sent to you on <t:"..time..":R>\n*Accuracy exactly to the minute is not guaranteed*")
	end)
	if not success then
		print(res)
	end
end

return remindme