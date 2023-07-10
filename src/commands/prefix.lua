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
		if #prefix > 5 then
			message:reply{
				embed = {
					title = "The prefix can't have more than 5 characters!",
					description = "Having problems with the command? Try using `commandinfo "..context.CommandName.."` to get more information about it!",
					timestamp = Discordia.Date():toISO('T', 'Z'),
					color = _G.MainColor.value
				},
				reference = {
					message = message,
					mention = false
				}
			}
		else
			local t = conn:exec("SELECT * FROM serverconfig WHERE guildId = '"..guildId.."';")
			if not t then
				-- No rows returned, so insert a new record
				local stmt = conn:prepare("INSERT INTO serverconfig VALUES(?, ?);")
				stmt:reset()
				stmt:bind(guildId, prefix):step()
				stmt:close()

				message:reply{
					embed = {
						title = "This server's prefix has been changed to "..prefix,
						timestamp = Discordia.Date():toISO('T', 'Z'),
						color = _G.MainColor.value
					},
					reference = {
						message = message,
						mention = false
					}
				}
			else
				-- Rows returned, so update the existing record
				local stmt = conn:prepare("UPDATE serverconfig SET VALUES(?) WHERE guildId = "..guildId..";")
				stmt:reset()
				stmt:bind(prefix):step()
				stmt:close()

				message:reply{
					embed = {
						title = "This server's prefix has been changed to "..prefix,
						timestamp = Discordia.Date():toISO('T', 'Z'),
						color = _G.MainColor.value
					},
					reference = {
						message = message,
						mention = false
					}
				}
			end
		end
	end
end

return prefix