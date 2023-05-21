local Functions = require("../dependencies/Functions.lua")
local BotData = require("../dependencies/BotData.lua")
local corohttp = require("coro-http")
local json = require("json")

local spotifyartist = {}

function spotifyartist:run(context)
    local message = context.Message
	local channel = message.channel
	local args = context.Args
	local artistName = ""
	for _, v in pairs(args) do
		artistName = artistName.."%20"..v
	end
	local token
	local decodedData
	local success, res = pcall(function()
		token = Functions.getSpotifyToken(BotData.SpotifyClientId, BotData.SpotifySecret)
		local url = "https://api.spotify.com/v1/search"
		local headers = Functions.getSpotifyAuthHeader(token)
		local query = "?q="..artistName.."&type=artist&limit=1"
		local queryUrl = url..query

		local res, body = corohttp.request("GET", queryUrl, headers)
		decodedData = json.decode(body).artists.items
	end)
	if success then
		if decodedData[1] then
			local tracksData = Functions.getSpotifySongsByArtist(token, decodedData[1].id)
			if tracksData then
				local artistData = decodedData[1]
				local fieldsT = {
					{name = "Followers:", value = artistData.followers.total, inline = false}
				}
				for i, v in pairs(tracksData.tracks) do
					table.insert(fieldsT, #fieldsT + 1, {name = "Top "..tostring(i).." track: ", value = v.name, inline = false})
				end
				channel:send {
					embed = {
						title = artistData.name,
						url = artistData.external_urls.spotify,
						thumbnail = {url = artistData.images[1].url},
						fields = fieldsT,
						color = _G.MainColor.value
					}
				}
			end
		else
			message:reply("No artist with this name was found!")
		end
	else
		message:reply("An error occured while trying to get artist info!")
	end
end

return spotifyartist