require("discordia-expanded")
local Functions = require("../dependencies/Functions.lua")
local sqlite3 = require("sqlite3")
local conn = sqlite3.open("DataBase.sqlite")

local prefix = {}

function prefix:run(context)
    local message = context.Message
	local guildId = context.Message.guild.id
	local author = message.guild:getMember(message.author.id)
	if Functions.basicChecks(message, "manageGuild", author, true) == false then
		return
	end
	local prefix
	if context.Args and context.Args[1] then
		prefix = context.Args[1]
	end
	if prefix then
		if #prefix > 10 then
			message:reply("The prefix can't have more than 10 characters!")
		else
			local t = conn:exec("SELECT * FROM serverconfig WHERE guildId = '"..guildId.."';")
			if not t then
				-- No rows returned, so insert a new record
				conn:exec("INSERT INTO serverconfig VALUES("..guildId..", '"..prefix.."');")
				message:reply("This server's prefix has been changed to "..prefix)
			else
				-- Rows returned, so update the existing record
				conn:exec("UPDATE serverconfig SET prefix = '"..prefix.."' WHERE guildId = "..guildId..";")
				message:reply("This server's prefix has been changed to "..prefix)
			end
		end
	end
end

return prefix