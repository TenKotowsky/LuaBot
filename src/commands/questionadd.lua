require("discordia-expanded")
local Functions = require("../dependencies/Functions.lua")
local BotData = require("../dependencies/BotData.lua")
local sqlite3 = require("sqlite3")
local conn = sqlite3.open("DataBase.sqlite")

local questionadd = {}

function questionadd:run(context)
    local message = context.Message
	local guildId = message.guild.id

	local prefix
	local prefixData = conn:exec("SELECT prefix FROM serverconfig WHERE guildId = '"..message.guild.id.."';")
	if prefixData == nil then
		prefix = BotData.Prefix
	else
		prefix = prefixData.prefix[1]
	end

	--questionadd has 12 chars and we also count the space
	local question = message.content:sub(13+#prefix,#message.content)
	if not question then return end
--	if context.Args and context.Args[1] then
--		for i, v in pairs(context.Args) do
--			if i == 1 then
--				question = v
--			else
--				question = question.." "..v
--			end
--		end
--	else
--		return
--	end
	local success, res = pcall(function()
		local author = message.guild:getMember(message.author.id)
		if Functions.basicChecks(message, "manageChannels", author, true) == false then
			return
		end
		if not question or #question < 0 then
			message:reply("Add a proper question!")
		else
			-- No rows returned, so insert a new record
			conn:exec("INSERT INTO periodicquestions VALUES("..guildId..", '"..question.."');")
			message:reply("Added question to the pool!")
		end
	end)
	if not success then
		message:reply("An error occured while trying to add this question!\n"..res)
		print(res)
	end
end
return questionadd