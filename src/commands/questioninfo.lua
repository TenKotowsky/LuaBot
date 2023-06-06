require("discordia-expanded")
local Functions = require("../dependencies/Functions.lua")
local sqlite3 = require("sqlite3")
local conn = sqlite3.open("DataBase.sqlite")

local questioninfo = {}

function questioninfo:run(context)
    local message = context.Message
	local guildId = message.guild.id
	local success, res = pcall(function()
		local author = message.guild:getMember(message.author.id)
		if Functions.basicChecks(message, "manageChannels", author, true) == false then
			return
		end

            local period = "Not set"
            local channel = "Not set"
			local time = "Not set"

             -- configIds - guildIds

            local success, res = pcall(function()
			local periodData = conn:exec("SELECT period FROM periodicquestionsconfig WHERE guildId = '"..guildId.."'")
			local channelIdData = conn:exec("SELECT channelId FROM periodicquestionsconfig WHERE guildId = '"..guildId.."'")
			local timeData = conn:exec("SELECT time FROM periodicquestionsconfig WHERE guildId = '"..guildId.."'")
              if periodData and periodData[1] then
				local periodName = ""
				if periodData[1][1] == "day" then
					periodName = " (QOTD)"
				else
					periodName = " (QOTW)"
				end
				period = periodData[1][1]:gsub("^%l", string.upper)..periodName
			end 
			if channelIdData and channelIdData[1] ~= nil then
				channel = "<#"..channelIdData[1][1]..">"
			end
			if timeData and timeData[1] ~= nil then
				time = tostring(timeData[1][1]):sub(1, 2)
			end                   
         end)
        if not success then print(res) end

        message:reply{
			embed = {
				title = "Periodic questions configuration",
                description = "Here's the current configuration of periodic questions on this server.\nYou can always modify it using periodic questions related commands!",
				fields = {
					{name = "Question period:", value = period, inline = false},
                     {name = "Question time:", value = time, inline = false},
					{name = "Question channel: ", value = channel, inline = false},
                    {name = "Question list: ", value = "Use the `questionlist` command to get this server's question poll.", inline = false}
				},
				color = _G.MainColor.value
			}
		}
	end)
	if not success then
		print(res)
	end
end

return questioninfo