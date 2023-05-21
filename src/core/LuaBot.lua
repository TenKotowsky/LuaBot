local Discordia = require("Discordia")
_G.Client = Discordia.Client()
local sqlite3 = require("sqlite3")
local conn = sqlite3.open("DataBase.sqlite")
local BotData = require("../dependencies/BotData.lua")
local Commands = require("../dependencies/Commands.lua")
local CommandClass = require("../classes/Command.lua")
local CommandHandler = require("../dependencies/CommandHandler.lua")
local Functions = require("../dependencies/Functions.lua")

_G.MainColor = Discordia.Color.fromHex("#000080")

--conn:exec[[
--CREATE TABLE periodicquestionsconfig(guildId TEXT, period VARCHAR(5), channelId TEXT, time INTEGER, lastTimeSent INTEGER);
--CREATE TABLE periodicquestions(guildId TEXT, question TEXT);
--]]

local function initializeCommands()
    for key, callback in pairs(Commands) do
        CommandHandler.AddCommand(CommandClass.new(key, "Placeholder description", function(message, ...)
            callback({
                CommandHandler = CommandHandler,
                Message = message,
                Args = {...},
            })
        end))
    end
end
initializeCommands()

Client:on("ready", function()
    print("Bot is ready! :)")
    Client:setActivity("Mention me for help! | "..#Client.guilds.." servers!")
end)

Client:on("messageCreate", function(message)
    local prefix
	local prefixData = conn:exec("SELECT prefix FROM serverconfig WHERE guildId = '"..message.guild.id.."';")
	if prefixData == nil then
		prefix = BotData.Prefix
	else
		prefix = prefixData.prefix[1]
	end

    local t = {}
	for str in string.gmatch(message.content, "([^%s]+)") do
		table.insert(t, str)
	end

    if message.author.bot then
        return
    elseif message.mentionedUsers.first == Client.user and #t == 1 then
        CommandHandler.Commands.help:Run(message, {})
    else
        CommandHandler.Parse(message, prefix)
    end
end)

Client:on("heartbeat", function(shardId, latency)
	Client:setActivity("Mention me for help! | "..#Client.guilds.." servers!")
    local hour = os.date("*t").hour
	local allData = conn:exec("SELECT guildId FROM periodicquestionsconfig")
	if allData ~= nil then
		for i, v in ipairs(allData) do
			local success, result = pcall(function()

				local time = conn:exec("SELECT time FROM periodicquestionsconfig WHERE guildId = '"..v[1].."'")
				if time and hour == time[1][1] then

					local guild = (Client:getGuild(v[1]))
					local channelId = conn:exec("SELECT channelId FROM periodicquestionsconfig WHERE guildId = '"..v[1].."'")
					local rowQuestionData = conn:exec("SELECT rowid, question FROM periodicquestions WHERE guildid = '"..v[1].."'")
					if channelId and rowQuestionData then

						local channel = guild:getChannel(channelId[1][1])
						local lastTimeSent = conn:exec("SELECT lastTimeSent FROM periodicquestionsconfig WHERE guildId = '"..v[1].."'")
						local periodData = conn:exec("SELECT period FROM periodicquestionsconfig WHERE guildId = '"..v[1].."'")
						if lastTimeSent and lastTimeSent[1][1] and periodData and periodData[1][1] then
							-- Convert the Unix timestamp to a Lua os.date object
							local datetime_obj = os.date("*t", tonumber(lastTimeSent[1][1]))

							if periodData[1][1] == "day" then
								
								local newDate = os.date("*t", os.time({year=datetime_obj.year, month=datetime_obj.month, day=datetime_obj.day+1}))

								if os.date("*t", os.time()).day == newDate.day then
									Functions.sendQuestion(channel, rowQuestionData, v[1])
								end
							elseif periodData[1][1] == "week" then

								local newDate = os.date("*t", os.time({year=datetime_obj.year, month=datetime_obj.month, day=datetime_obj.day+7}))

								if os.date("*t", os.time()).day == newDate.day then
									Functions.sendQuestion(channel, rowQuestionData, v[1])
								end
							end
						else
							Functions.sendQuestion(channel, rowQuestionData, v[1])
						end
					end
				end
			end)
			if not success then print(result) end
		end
	end
end)

Client:run(BotData.Token)