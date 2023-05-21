local corohttp = require("coro-http")
local json = require("json")

local robloxuser = {}

function robloxuser:run(context)
    if context.Args and context.Args[1] then
		--general info
		local infobody = {
			usernames = {
				context.Args[1]
			},
			excludeBannedUsers = true
		}
		local url = "https://users.roblox.com/v1/usernames/users"
		local encodedBody = json.encode(infobody)
		
		local headers = {
			{"Content-Length", tostring(#encodedBody)},
			{"Content-Type", "application/json"},
		}
			
		local res, body = corohttp.request("POST", url, headers, encodedBody, 5000)
		local finalData = json.decode(body).data

		if not finalData[1] then
			context.Message:reply("Couldn't find such user!")
			return
		end
		
		--thumbnail
		local res, thumbnailBody = corohttp.request("GET", "https://thumbnails.roblox.com/v1/users/avatar-bust?userIds="..finalData[1].id.."&size=180x180&format=Png&isCircular=false")
		local finalThumbnailData = json.decode(thumbnailBody)
		if finalThumbnailData then
			finalThumbnailData = finalThumbnailData.data
		else
			finalThumbnailData = nil
		end
		
		if finalData[1] then
			if finalThumbnailData and finalThumbnailData[1] then
				local data = finalData[1]
				local verifiedMsg = "Not verified"
				if data.hasVerifiedBadge then
					verifiedMsg = "Verified"
				end
				context.Message.channel:send {
					embed = {
						title = "Roblox user info",
						description = data.displayName.." ("..data.name..")",
						thumbnail = {url = finalThumbnailData[1].imageUrl},
						fields = {
							{name = "Verification status:", value = verifiedMsg, inline = false},
							{name = "User ID:", value = data.id, inline = false}
						},
						color = _G.MainColor.value
					}
				}
			else
				local data = finalData[1]
				local verifiedMsg = "Not verified"
				if data.hasVerifiedBadge then
					verifiedMsg = "Verified"
				end
				context.Message.channel:send {
					embed = {
						title = "Roblox user info",
						description = data.displayName.." ("..data.name..")",
						fields = {
							{name = "Verification status:", value = verifiedMsg, inline = false},
							{name = "User ID:", value = data.id, inline = false}
						},
						color = _G.MainColor.value
					}
				}
			end
		end
	end
end

return robloxuser