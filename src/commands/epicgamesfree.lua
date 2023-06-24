require("discordia-expanded")
local corohttp = require("coro-http")
local json = require("json")

local epicgamesfree = {}

function epicgamesfree:run(context)
    local message = context.Message

	local headers = {
        {"X-RapidAPI-Key", "6fa0aca9c6msh3039fbfebd58c14p1d7f0ejsn66b1abfbdcf9"},
        {"X-RapidAPI-Host", "free-epic-games.p.rapidapi.com"}
    }

	local res, freeGamesData = corohttp.request("GET", "https://free-epic-games.p.rapidapi.com/free", headers)
	local finalFreeGamesData

	pcall(function()
		finalFreeGamesData = json.decode(freeGamesData).freeGames
	end)

	if finalFreeGamesData and finalFreeGamesData.current then
        local fields = {}
        for i, v in pairs(finalFreeGamesData.current) do
            if v.productSlug then
                table.insert(fields, {name = v.title, value = v.description.."\nhttps://store.epicgames.com/en-US/p/"..v.productSlug, inline = false})
            else
                table.insert(fields, {name = v.title, value = v.description, inline = false})
            end
        end
        local offerImageWideUrl = "https://cdn1.epicgames.com/offer/d5241c76f178492ea1540fce45616757/egs-vault-tease-generic-promo-1920x1080_1920x1080-f7742c265e217510835ed14e04c48b4b"
        for i, v in pairs(finalFreeGamesData.current[1].keyImages) do
            if v.type == "VaultOpened" or v.type == "OfferImageWide" then
                offerImageWideUrl = v.url
                break
            end
        end

		message:reply{embed = {
            title = "Current free games on Epic Games Store:",
            fields = fields,
            image = {url = offerImageWideUrl},
            color = _G.MainColor.value
        }}

        if finalFreeGamesData.upcoming[1] ~= nil then
        local upcomingFields = {}
        for i, v in pairs(finalFreeGamesData.upcoming) do
            local url
            if v.productSlug ~= "[]" then
                url = "\n".."https://store.epicgames.com/en-US/p/"..v.productSlug
            else
                url = ""
            end
            table.insert(upcomingFields, {name = v.title, value = v.description..url, inline = false})
        end
        local upcomingOfferImageWideUrl = "https://cdn1.epicgames.com/offer/d5241c76f178492ea1540fce45616757/egs-vault-tease-generic-promo-1920x1080_1920x1080-f7742c265e217510835ed14e04c48b4b"
        for i, v in pairs(finalFreeGamesData.upcoming[1].keyImages) do
            if v.type == "VaultOpened" or v.type == "OfferImageWide" then
                upcomingOfferImageWideUrl = v.url
                break
            end
        end

        message:reply{embed = {
            title = "Upcoming free games on Epic Games Store:",
            fields = upcomingFields,
            image = {url = upcomingOfferImageWideUrl},
            color = _G.MainColor.value
        }}
        end
	else
		message:reply("An error occured!")
	end
end

return epicgamesfree