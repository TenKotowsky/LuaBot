local spotifyArtist = {}

function spotifyArtist.SpotifyArtist(channel, embedColor, artistData, tracksData)
	if tracksData then
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
                color = embedColor.value
            }
        }
	end
end

return spotifyArtist