_G.Discordia = require("Discordia")
_G.Client = Discordia.Client()
local sqlite3 = require("sqlite3")
local conn = sqlite3.open("DataBase.sqlite")
local BotData = require("../dependencies/BotData.lua")
local Commands = require("../dependencies/Commands.lua")
local CommandClass = require("../classes/Command.lua")
local CommandHandler = require("../dependencies/CommandHandler.lua")
local CommandDescriptions = require("../dependencies/CommandDescriptions.lua")
local TempbansInit = require("../initialize/InitializeTempbans.lua")
local RemindersInit = require("../initialize/InitializeReminders.lua")

_G.MainColor = Discordia.Color.fromHex("#000080")

--conn:exec("CREATE TABLE reminders(userId TEXT, time TEXT, reminder TEXT);")
--CREATE TABLE tempban(guildId TEXT, userId TEXT, time TEXT);
--CREATE TABLE periodicquestionsconfig(guildId TEXT, period VARCHAR(5), channelId TEXT, time INTEGER, lastTimeSent INTEGER);
--CREATE TABLE periodicquestions(guildId TEXT, question TEXT);

local function initializeCommands()
    for key, callback in pairs(Commands) do
        CommandHandler.AddCommand(CommandClass.new(key, CommandDescriptions.Descriptions[key:lower()], function(message, ...)
            callback({
                CommandHandler = CommandHandler,
                Message = message,
                Args = {...},
            })
        end))
    end
end

Client:on("ready", function()
	Client:setActivity("Mention me for help! | "..#Client.guilds.." servers!")
	print("Bot is ready! :)")
	initializeCommands()
	print("Commands initialized!")
	TempbansInit:init()
	print("Tempbans initialized")
	RemindersInit:init()
	print("Reminders initialized")
end)

Client:on("messageCreate", function(message)
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
end)

Client:run(BotData.Token)