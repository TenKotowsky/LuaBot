local BotData = require("../dependencies/BotData.lua")
local corohttp = require("coro-http")
local json = require("json")

local key = BotData.SteamKey


local steamuser = {}

function steamuser:run(context)
    local message = context.Message
    if context.Args and context.Args[1] then
		
        local vanityUsername = context.Args[1]

		local res, body = corohttp.request("GET", "https://api.steampowered.com/ISteamUser/ResolveVanityURL/v0001/?key="..key.."&vanityurl="..vanityUsername)
		local userId = json.decode(body)

		if userId and userId.response and userId.response.steamid then
            userId = userId.response.steamid
        else
            context.Message:reply{
                content = "Couldn't find such user!",
                reference = {
                    message = message,
                    mention = false
                }
            }
			return
        end
		
        local res, summaryBody = corohttp.request("GET", "https://api.steampowered.com/ISteamUser/GetPlayerSummaries/v2/?key="..key.."&format=json&steamids="..userId)
		local summary = json.decode(summaryBody)

        local res, levelBody = corohttp.request("GET", "https://api.steampowered.com/IPlayerService/GetSteamLevel/v1/?key="..key.."&format=json&steamid="..userId)
		local level = json.decode(levelBody)

        local res, recentlyPlayedBody = corohttp.request("GET", "https://api.steampowered.com/IPlayerService/GetRecentlyPlayedGames/v1/?key="..key.."&format=json&count=4&steamid="..userId)
		local recentlyPlayed = json.decode(recentlyPlayedBody)

		if summary.response.players and summary.response.players[1] then
			local data = summary.response.players[1]
            local level = level.response.player_level
            if not level then
                level = "Unknown"
            end
            local recentlyPlayedString
            for i, v in ipairs(recentlyPlayed.response.games) do
                if i == 1 then
                    if #recentlyPlayed.response.games == 1 then
                        recentlyPlayedString = v.name
                        break
                    else
                        recentlyPlayedString = v.name..","
                    end
                else
                    if i < #recentlyPlayed.response.games then
                        recentlyPlayedString = recentlyPlayedString.."\n"..v.name..","
                    else
                        recentlyPlayedString = recentlyPlayedString.."\n"..v.name
                    end
                end
            end
            if not recentlyPlayedString then
                recentlyPlayedString = "Unknown"
            end
            local lastlogoff
            if data.lastlogoff then
                lastlogoff = "<t:"..data.lastlogoff..":R>"
            else
                lastlogoff = "Unknown"
            end
            local country
            if data.loccountrycode then
                country = data.loccountrycode.." :flag_"..string.lower(data.loccountrycode)..":"
            else
                country = "Unknown"
            end

			context.Message:reply {
				embed = {
					title = data.personaname,
					thumbnail = {url = data.avatarfull},
                    url = data.profileurl,
					fields = {
						{name = "Account created:", value = "<t:"..data.timecreated..":R>", inline = true},
                        {name = "Last log off:", value = lastlogoff, inline = true},
                        {name = "Steam level:", value = level, inline = false},
                        {name = "Country:", value = country, inline = false},
                        {name = "Recently played games:", value = recentlyPlayedString, inline = false}
                    },
                    timestamp = Discordia.Date():toISO('T', 'Z'),
					color = _G.MainColor.value
				},
                reference = {
                    message = message,
                    mention = false
                }
			}
		else
            context.Message:reply{
                content = "Couldn't find such user!",
                reference = {
                    message = message,
                    mention = false
                }
            }
			return
        end
	end
end

return steamuser