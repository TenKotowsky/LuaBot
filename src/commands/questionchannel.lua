require("discordia-expanded")
local Functions = require("../dependencies/Functions.lua")
local sqlite3 = require("sqlite3")
local conn = sqlite3.open("DataBase.sqlite")

local questionchannel = {}

function questionchannel:run(context)
    local message = context.Message
	local guildId = message.guild.id
	local channelId
	if context.Args and context.Args[1] then
		channelId = context.Args[1]
	else
		return
	end
	local success, res = pcall(function()
		local author = message.guild:getMember(message.author.id)
		if Functions.basicChecks(message, "manageChannels", author, true) == false then
			return
		end
		if not tonumber(channelId) then
			message:reply("Add a proper channel ID!")
		else
			local t = conn:exec("SELECT * FROM periodicquestionsconfig WHERE guildId = '"..guildId.."';")
			if not t then
				-- No rows returned, so insert a new record
				conn:exec("INSERT INTO periodicquestionsconfig VALUES("..guildId..", '".."day".."', "..channelId..", NULL, NULL);")
				message:reply("Periodic question channel has been changed to <#"..channelId..">")
			else
				-- Rows returned, so update the existing record
				conn:exec("UPDATE periodicquestionsconfig SET channelId = "..channelId.." WHERE guildId = "..guildId..";")
				message:reply("Periodic question channel has been changed to <#"..channelId..">")
			end
		end
	end)
	if not success then
		print(res)
	end
end

return questionchannel