local corohttp = require("coro-http")
local base64 = require("base64")
local json = require("json")
local sqlite3 = require("sqlite3")
local conn = sqlite3.open("DataBase.sqlite")

local Functions = {}

function Functions.sendQuestion(channel, rowQuestionData, guildId)
	local row = rowQuestionData[1][1]
	local question = rowQuestionData[2][1]
	if channel then
		channel:send{
			content = question
		}
		conn:exec("UPDATE periodicquestionsconfig SET lastTimeSent = '"..os.time().."' WHERE guildId = "..guildId..";")
		conn:exec("DELETE FROM periodicquestions WHERE rowid = "..tonumber(row)..";")
	end
end

function Functions.basicChecks(message, permission, author, member)
	if author.bot then return false end
	if not member then
		-- The user have not mentioned any member to be banned/kicked
		if permission == "banMembers" then
			message:reply("Please mention someone to ban!")
		elseif permission == "kickMembers" then
			message:reply("Please mention someone to kick!")
		end
		return false
	elseif not author:hasPermission(permission) then
		-- The user does not have enough permissions
		if permission == "banMembers" then
			message:reply("You don't have permission to ban members!")
		elseif permission == "kickMembers" then
			message:reply("You don't have permission to kick members!")
		elseif permission == "manageChannels" then
			message:reply("You don't have permission to manage channels!")
		elseif permission == "manageGuild" then
			message:reply("You don't have permission to manage server!")
		end
		return false
	end
end

function Functions.secondsToHMS(seconds)
	local seconds = tonumber(seconds)
  
	if seconds <= 0 then
	  return "0 seconds";
	else
	  local hours = string.format("%02.f", math.floor(seconds/3600));
	  local mins = string.format("%02.f", math.floor(seconds/60 - (hours*60)));
	  local secs = string.format("%02.f", math.floor(seconds - hours*3600 - mins *60));
	  if tonumber(hours) > 0 then
		return hours.." hours "..mins.." minutes "..secs.." seconds"
	  elseif tonumber(mins) > 0 then
		return mins.." minutes "..secs.." seconds"
	  else
		return secs.." seconds"
	  end
	end
end

function Functions.milliToHuman(milliseconds)
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

function Functions.getSpotifyToken(clientId, clientSecret)
	local headers = {
		{"Authorization", "Basic "..base64.encode(clientId..":"..clientSecret)},
		{"Content-Type", "application/x-www-form-urlencoded"},
	}

	local res, body = corohttp.request("POST", "https://accounts.spotify.com/api/token", headers, "grant_type=client_credentials")
	return json.decode(body).access_token
end

function Functions.getSpotifyAuthHeader(token)
	return {{"Authorization", "Bearer "..token}}
end

function Functions.getSpotifySongsByArtist(token, artistId)
	local url = "https://api.spotify.com/v1/artists/"..artistId.."/top-tracks?country=US"
	local headers = Functions.getSpotifyAuthHeader(token)

	local res, body = corohttp.request("GET", url, headers)
	return json.decode(body)
end

function Functions.getAlbumTracks(token, albumId)
	local url = "https://api.spotify.com/v1/albums/"..albumId.."/tracks?q=&limit=49"
	local headers = Functions.getSpotifyAuthHeader(token)

	local res, body = corohttp.request("GET", url, headers)
	return json.decode(body)
end

function Functions.printTable(tbl, indent)
	if not indent then indent = 0 end
	local toprint = string.rep(" ", indent) .. "{\r\n"
	indent = indent + 2
	for k, v in pairs(tbl) do
	 	toprint = toprint .. string.rep(" ", indent)
		if (type(k) == "number") then
			toprint = toprint .. "[" .. k .. "] = "
		elseif (type(k) == "string") then
			toprint = toprint  .. k ..  "= "   
		end
		if (type(v) == "number") then
			toprint = toprint .. v .. ",\r\n"
		elseif (type(v) == "string") then
			toprint = toprint .. "\"" .. v .. "\",\r\n"
		elseif (type(v) == "table") then
			toprint = toprint .. Functions.printTable(v, indent + 2) .. ",\r\n"
		else
			toprint = toprint .. "\"" .. tostring(v) .. "\",\r\n"
		end
	end
	toprint = toprint .. string.rep(" ", indent-2) .. "}"
	print(toprint)
	return toprint
end

function Functions.convertToHours(time)
	local hours = nil
	if time then
		pcall(function()
			if tonumber(time) then
				hours = time
			elseif time:sub(#time, #time) == "h" then
				hours = tonumber(time:sub(1, #time - 1))
			elseif time:sub(#time, #time) == "d" then
				hours = tonumber(time:sub(1, #time - 1)) * 24
			elseif time:sub(#time, #time) == "w" then
				hours = tonumber(time:sub(1, #time - 1)) * 168
			elseif time:sub(#time, #time) == "m" then
				hours = tonumber(time:sub(1, #time - 1)) * 720
			end
		end)
	end
	return hours
end

function Functions.convertToMinutes(time)
	local minutes = nil
	if time then
		pcall(function()
			if tonumber(time) then
				minutes = time
			elseif time:sub(#time, #time) == "m" then
				minutes = tonumber(time:sub(1, #time - 1))
			elseif time:sub(#time, #time) == "h" then
				minutes = tonumber(time:sub(1, #time - 1)) * 60
			elseif time:sub(#time, #time) == "d" then
				minutes = tonumber(time:sub(1, #time - 1)) * 1440
			elseif time:sub(#time, #time) == "w" then
				minutes = tonumber(time:sub(1, #time - 1)) * 10080
			end
		end)
	end
	return minutes
end

function Functions.convertToSeconds(time)
	local seconds = nil
	if time then
		pcall(function()
			if tonumber(time) then
				seconds = tonumber(time)
			elseif time:sub(#time, #time) == "s" then
				seconds = tonumber(time:sub(1, #time - 1))
			elseif time:sub(#time, #time) == "m" then
				seconds = tonumber(time:sub(1, #time - 1)) * 60
			elseif time:sub(#time, #time) == "h" then
				seconds = tonumber(time:sub(1, #time - 1)) * 3600
			elseif time:sub(#time, #time) == "d" then
				seconds = tonumber(time:sub(1, #time - 1)) * 86400
			end
		end)
	end
	return seconds
end


function Functions.splitString(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t = {}
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		table.insert(t, str)
	end
	return t
end

function Functions.is_url_image(image_url)
	local image_formats = {"image/png", "image/gif", "image/jpeg", "image/jpg", "image/webp"}
	local r
	local success, res = pcall(function()
        r = corohttp.request("GET", image_url)
	end)
    if not success then
		print(res)
		return false
	end
	for i, x in ipairs(image_formats) do
		if x == r[2][2] then
			return true
		end
	end
	return false
end

function Functions.set(list)
	local set = {}
	for _, l in ipairs(list) do set[l] = true end
	return set
  end

return Functions