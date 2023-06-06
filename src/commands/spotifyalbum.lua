require("discordia-expanded")
local Functions = require("../dependencies/Functions.lua")
local BotData = require("../dependencies/BotData.lua")
local corohttp = require("coro-http")
local json = require("json")

local spotifyalbum = {}

function spotifyalbum:run(context)
    local message = context.Message
	local args = context.Args
	local albumName = ""
	for _, v in pairs(args) do
		albumName = albumName.."%20"..v
	end
	local token
	local decodedData
	local success, res = pcall(function()
		token = Functions.getSpotifyToken(BotData.SpotifyClientId, BotData.SpotifySecret)
		local url = "https://api.spotify.com/v1/search"
		local headers = Functions.getSpotifyAuthHeader(token)
		local query = "?q="..albumName.."&type=album&limit=1"
		local queryUrl = url..query

		local res, body = corohttp.request("GET", queryUrl, headers)
		decodedData = json.decode(body).albums.items
	end)

	if success then
		if decodedData[1] then
			local albumTracks = Functions.getAlbumTracks(token, decodedData[1].id).items
			if decodedData[1] then
				local albumData = decodedData[1]
				local fieldsT = {
					{name = "Type:", value = albumData.album_type:gsub("^%l", string.upper), inline = false}
				}
				for i, v in pairs(albumTracks) do
					local artists = ""
					for ii, vv in pairs(v.artists) do
						if ii == 1 then
							artists = vv.name
						else
							artists = artists..", "..vv.name
						end
					end
				   table.insert(fieldsT, #fieldsT + 1, {name = i..". "..v.name.." ("..Functions.milliToHuman(v.duration_ms)..")", value = artists, inline = false})
				end
				if #fieldsT <= 25 then
					message:reply {
						embed = {
							title = albumData.name,
							url = albumData.external_urls.spotify,
							thumbnail = {url = albumData.images[1].url},
							fields = fieldsT,
							color = _G.MainColor.value
						}
					}
				else
					message:reply {
						embed = {
							title = albumData.name,
							url = albumData.external_urls.spotify,
							thumbnail = {url = albumData.images[1].url},
							fields = fieldsT,
							color = _G.MainColor.value
						}
					}
					local secondFieldsT = {}
					for i, v in ipairs(fieldsT) do
						if i > 25 then
							table.insert(secondFieldsT, v)
						end
					end
					message:reply {
						embed = {
							title = albumData.name,
							url = albumData.external_urls.spotify,
							thumbnail = {url = albumData.images[1].url},
							fields = secondFieldsT,
							color = _G.MainColor.value
						}
					}
				end
			end
		else
			message:reply("No album with this name was found!")
		end
	else
		message:reply("An error occured while trying to get album info!")
	end
end

return spotifyalbum