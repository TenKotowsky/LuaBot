local Functions = require("../dependencies/Functions.lua")
local sqlite3 = require("sqlite3")
local conn = sqlite3.open("DataBase.sqlite")
local timer = require("timer")

local tempban = {}

function tempban:run(context)
    local message = context.Message
	local author = message.guild:getMember(message.author.id)
	local args = context.Args
	local user
	if message.mentionedUsers.first then
		user = message.mentionedUsers.first
	elseif tonumber(args[1]) and _G.Client:getUser(args[1]) then
		user = _G.Client:getUser(args[1])
	else
		return
	end
	local member
	if not message.guild:getMember(user.id) then
		message:reply{
			content = "Couldn't find such user!",
			reference = {
				message = message,
				mention = false
			}
		}
		return
	else
		member = message.guild:getMember(user.id)
	end

	if Functions.basicChecks(message, "banMembers", author, member) == false then
		return
	end

	if author.highestRole.position > member.highestRole.position then
		table.remove(args, 1)

        local hours = Functions.convertToHours(args[1])
        if not hours then
            message:reply{
				content = "Specify a proper amount of hours the user should get banned for!",
				reference = {
					message = message,
					mention = false
				}
			}
            return
		end
		table.remove(args, 1)

		local reason = ""
		if #args == 0 then
			reason = "Reason not provided"
		else
			for i, v in pairs(args) do
				if i == 1 then
					reason = v
				else
					reason = reason.." "..v
				end
			end
		end

		local stmt = conn:prepare("INSERT INTO tempban VALUES(?, ?, ?);")
        stmt:reset()
        stmt:bind(message.guild.id, user.id, (os.time() + hours*3600)):step()
        stmt:close()

		member:ban(reason)
		message:reply{
			content = "Successfully banned **"..user.username.."** for **"..hours.." hours**",
			reference = {
				message = message,
				mention = false
			}
		}

		timer.setTimeout((hours*3600) * 1000, coroutine.wrap(function()

            local deleteStmt = conn:prepare("DELETE FROM tempbans WHERE guildId = ? AND userId = ? AND time = ?;")
            deleteStmt:reset()
            deleteStmt:bind(message.guild, user.id, (os.time() + hours*3600)):step()
            deleteStmt:close()

			message.guild:unbanUser(user.id)

        end))

	else
		message:reply{
			content = "You can't ban someone whose highest role is higher than your highest role!",
			reference = {
				message = message,
				mention = false
			}
		}
	end
end

return tempban