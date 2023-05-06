local robloxuser = {}

function robloxuser.RobloxUser(channel, embedColor, data, finalThumbnailData)
	if data and finalThumbnailData then
		local verifiedMsg = "Not verified"
		if data.hasVerifiedBadge then
			verifiedMsg = "Verified"
		end
		channel:send {
			embed = {
				title = "Roblox user info",
				description = data.displayName.." ("..data.name..")",
				thumbnail = {url = finalThumbnailData.imageUrl},
				fields = {
					{name = "Verification status:", value = verifiedMsg, inline = false},
					{name = "User ID:", value = data.id, inline = false}
				},
				color = embedColor.value
			}
		}
	end
end

return robloxuser