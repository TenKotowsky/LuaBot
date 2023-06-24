_G.Discordia = require("Discordia")
_G.Client = Discordia.Client()
local sqlite3 = require("sqlite3")
local conn = sqlite3.open("DataBase.sqlite")
local BotData = require("../dependencies/BotData.lua")
local Commands = require("../dependencies/Commands.lua")
local CommandClass = require("../classes/Command.lua")
local CommandHandler = require("../dependencies/CommandHandler.lua")
local Functions = require("../dependencies/Functions.lua")

_G.MainColor = Discordia.Color.fromHex("#000080")

--conn:exec("CREATE TABLE reminders(userId TEXT, time TEXT, reminder TEXT);")
--CREATE TABLE tempban(guildId TEXT, userId TEXT, time TEXT);
--CREATE TABLE periodicquestionsconfig(guildId TEXT, period VARCHAR(5), channelId TEXT, time INTEGER, lastTimeSent INTEGER);
--CREATE TABLE periodicquestions(guildId TEXT, question TEXT);

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

Client:on("ready", function()
    print("Bot is ready! :)")
	initializeCommands()
	print("Commands initialized!")
    Client:setActivity("Mention me for help! | "..#Client.guilds.." servers!")
end)

Client:on("messageCreate", function(message)
	if message.channel.type > 4 then
		print(message.channel.type)
	end
	if not message.guild then
		return
	end
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
    elseif message.mentionedUsers.first == Client.user and #t == 1 and not message.referencedMessage then
        CommandHandler.Commands.help:Run(message, {})
    else
        CommandHandler.Parse(message, prefix)
    end
end)

Client:on("heartbeat", function(shardId, latency)
	Client:setActivity("Mention me for help! | "..#Client.guilds.." servers!")
    local hour = os.date("*t").hour
	local questionsAllData = conn:exec("SELECT guildId FROM periodicquestionsconfig")
	if questionsAllData ~= nil then
		for i, v in ipairs(questionsAllData) do
			local success, res = pcall(function()

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
			if not success then print(res) end
		end
	end
	local tempbans = conn:exec("SELECT rowid FROM tempban")
	if tempbans ~= nil then
		for i, v in ipairs(tempbans) do
			-- v[1] - rowid
			local row = tonumber(v[1])

			local success, res = pcall(function()
				local timeToBan = conn:exec("SELECT time FROM tempban WHERE rowid = '"..row.."'")
				if tonumber(timeToBan[1][1]) and os.time() >= tonumber(timeToBan[1][1]) then
					local userIdData = conn:exec("SELECT userId FROM tempban WHERE rowid = '"..row.."'")
					local userId = userIdData[1][1]
					conn:exec("DELETE FROM tempban WHERE rowid = " .. row .. ";")
					local guildIdData = conn:exec("SELECT guildId FROM tempban WHERE rowid = '"..row.."'")
					local guild = Client:getGuild(guildIdData[1][1])
					guild:unbanUser(userId)
				end
			end)
			if not success then print(res) end
		end
	end
	local reminders = conn:exec("SELECT rowid FROM reminders")
	if reminders ~= nil then
		for i, v in ipairs(reminders) do
			-- v[1] - rowid
			local row = tonumber(v[1])

			local success, res = pcall(function()
				local timeToRemind = conn:exec("SELECT time FROM reminders WHERE rowid = '"..row.."'")
				if tonumber(timeToRemind[1][1]) and os.time() >= tonumber(timeToRemind[1][1]) then
					local userIdData = conn:exec("SELECT userId FROM reminders WHERE rowid = '"..row.."'")
					local userId = userIdData[1][1]
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
					conn:exec("DELETE FROM reminders WHERE rowid = "..row..";")
					user:send{
						embed = {
							title = "Reminder",
							description = reminderContent,
							color = _G.MainColor.value
						}
					}
				end
			end)
			if not success then print(res) end
		end
	end
end)

Client:run(BotData.Token)
