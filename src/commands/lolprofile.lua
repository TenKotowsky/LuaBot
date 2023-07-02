local corohttp = require("coro-http")
local json = require("json")
local BotData = require("../dependencies/BotData.lua")
local Functions = require("../dependencies/Functions.lua")

local routingValues = {
    ["br"] = "br1",
    ["eune"] = "eun1",
    ["euw"] = "euw1",
    ["jp"] = "jp1",
    ["kr"] = "kr",
    ["lan"] = "la1",
    ["las"] = "la2",
    ["na"] = "na1",
    ["oce"] = "oc1",
    ["tr"] = "tr1",
    ["ru"] = "ru"
}

local lolprofile = {}

function lolprofile:run(context)
    local message = context.Message
    local region
    local summonerName
    if context.Args[1] and routingValues[context.Args[1]:lower()] then
        region = routingValues[context.Args[1]:lower()]
    else
        message:reply{
            content = "Specify a region!",
			reference = {
				message = message,
				mention = false
			}
        }
        return
    end
    if context.Args[2] then
        summonerName = context.Args[2]
    else
        message:reply{
            content = "Specify summoner's name!",
			reference = {
				message = message,
				mention = false
			}
        }
        return
    end

    local res, versions = corohttp.request("GET", "https://ddragon.leagueoflegends.com/api/versions.json")
	local finalVersion = ""
	local res, lolData = corohttp.request("GET", "https://"..region..".api.riotgames.com/lol/summoner/v4/summoners/by-name/"..summonerName.."?api_key="..BotData.RiotKey)
	local finalLolData
    local finalLastUsedChampions

    local names = {
        [1] = "",
        [2] = "",
        [3] = ""
    }

	pcall(function()
		finalLolData = json.decode(lolData)
        finalVersion = json.decode(versions)[1]
        local res, allChampions = corohttp.request("GET", "https://ddragon.leagueoflegends.com/cdn/"..finalVersion.."/data/en_US/champion.json")
        allChampions = json.decode(allChampions)
        local res, lastUsedChampions = corohttp.request("GET", "https://"..region..".api.riotgames.com/lol/champion-mastery/v4/champion-masteries/by-puuid/"..finalLolData.puuid.."/top?count=3&api_key="..BotData.RiotKey)
        finalLastUsedChampions = json.decode(lastUsedChampions)
        for i, v in pairs(allChampions.data) do
            if v.key == tostring(finalLastUsedChampions[1].championId) then
                names[1] = v.name
            elseif v.key == tostring(finalLastUsedChampions[2].championId) then
                names[2] = v.name
            elseif v.key == tostring(finalLastUsedChampions[3].championId) then
                names[3] = v.name
            end
        end
    end)

    if finalLolData and not finalLolData.status then
        local fields = {
            {name = "Region", value = context.Args[1]:upper(), inline = true},
            {name = "Summoner level", value = finalLolData.summonerLevel, inline = true},
            {name = "Last match", value = "<t:"..(math.floor(finalLolData.revisionDate/1000))..":R>", inline = true}
        }
        for i, v in pairs(names) do
            if v ~= "" then
                table.insert(fields, {name = "Top "..i.." champion", value = "**"..v.."**\nChampion points: **"..finalLastUsedChampions[i].championPoints.."**", inline = true})
            end
        end
        message:reply{
            embed = {
                title = finalLolData.name,
                fields = fields,
                thumbnail = {url = "https://ddragon.leagueoflegends.com/cdn/"..finalVersion.."/img/profileicon/"..finalLolData.profileIconId..".png"},
                timestamp = Discordia.Date():toISO('T', 'Z'),
                color = _G.MainColor.value
            },
			reference = {
				message = message,
				mention = false
			}
        }
    else
        message:reply{
            content = finalLolData.status.message,
			reference = {
				message = message,
				mention = false
			}
        }
    end
end

return lolprofile