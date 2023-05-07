local spotifyAlbum = {}

local function milliToHuman(milliseconds)
    local totalseconds = math.floor(milliseconds / 1000)
    milliseconds = milliseconds % 1000
    local seconds = totalseconds % 60
    local minutes = math.floor(totalseconds / 60)
    local hours = math.floor(minutes / 60)
    minutes = minutes % 60
    if hours > 0 then
        return string.format("%02d:%02d:%02d", hours, minutes, seconds)
    else
        return string.format("%02d:%02d", minutes, seconds)
    end
end

function spotifyAlbum.SpotifyAlbum(channel, embedColor, albumData, albumTracks)
	if albumData then
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
           table.insert(fieldsT, #fieldsT + 1, {name = i..". "..v.name.." ("..milliToHuman(v.duration_ms)..")", value = artists, inline = false})
        end
        if #fieldsT <= 25 then
            channel:send {
                embed = {
                    title = albumData.name,
                    thumbnail = {url = albumData.images[1].url},
                    fields = fieldsT,
                    color = embedColor.value
                }
            }
        else
            channel:send {
                embed = {
                    title = albumData.name,
                    thumbnail = {url = albumData.images[1].url},
                    fields = fieldsT,
                    color = embedColor.value
                }
            }
            local secondFieldsT = {}
            for i, v in ipairs(fieldsT) do
                if i > 25 then
                    table.insert(secondFieldsT, v)
                end
            end
            channel:send {
                embed = {
                    title = albumData.name,
                    thumbnail = {url = albumData.images[1].url},
                    fields = secondFieldsT,
                    color = embedColor.value
                }
            }
        end
	end
end

return spotifyAlbum