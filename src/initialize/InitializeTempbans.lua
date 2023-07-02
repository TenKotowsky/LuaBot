local sqlite3 = require("sqlite3")
local conn = sqlite3.open("DataBase.sqlite")
local timer = require("timer")

local InitializeTempbans = {}

function InitializeTempbans:init()
    local tempbans = conn:exec("SELECT rowid FROM tempban")
	if tempbans ~= nil then
		for i, v in ipairs(tempbans[1]) do
			-- v[1] - rowid
			local row = tonumber(v)

			local success, res = pcall(function()
				local timeToBan = conn:exec("SELECT time FROM tempban WHERE rowid = '"..row.."'")
				if tonumber(timeToBan[1][1]) and os.time() >= tonumber(timeToBan[1][1]) then
					local userIdData = conn:exec("SELECT userId FROM tempban WHERE rowid = '"..row.."'")
					local userId = userIdData[1][1]

                    local guildIdData = conn:exec("SELECT guildId FROM tempban WHERE rowid = '"..row.."'")

                    local deleteStmt = conn:prepare("DELETE FROM tempban WHERE rowid = ?;")
                    deleteStmt:reset()
                    deleteStmt:bind(row):step()
                    deleteStmt:close()

					local guild = Client:getGuild(guildIdData[1][1])
					guild:unbanUser(userId)
                else
                    timer.setTimeout((tonumber(timeToBan[1][1]) - os.time()) * 1000, coroutine.wrap(function()
                        local userIdData = conn:exec("SELECT userId FROM tempban WHERE rowid = '"..row.."'")
                        local userId = userIdData[1][1]

                        local guildIdData = conn:exec("SELECT guildId FROM tempban WHERE rowid = '"..row.."'")

                        local deleteStmt = conn:prepare("DELETE FROM tempban WHERE rowid = ?;")
                        deleteStmt:reset()
                        deleteStmt:bind(row):step()
                        deleteStmt:close()

                        local guild = Client:getGuild(guildIdData[1][1])
                        guild:unbanUser(userId)
                    end))
                end
			end)
			if not success then print(res) end
		end
	end
end

return InitializeTempbans