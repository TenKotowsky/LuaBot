local BotData = require("../dependencies/BotData.lua")
local corohttp = require("coro-http")
local json = require("json")

local quote = {}

local quotes = {
	"In three words I can sum up everything I've learned about life: it goes on.\n- Robert Frost.",
	"When something is important enough, you do it even if the odds are not in your favor.\n- Elon Musk",
	"Life is really simple, but we insist on making it complicated.\n- Confucius",
	"Learn from yesterday, live for today, hope for tomorrow. The important thing is not to stop questioning.\n- Albert Einstein",
	"For what shall it profit a man, if he gain the whole world, and suffer the loss of his soul?\n- Jesus Christ",
	"'Tis better to have loved and lost than never to have loved at all.\n- Alfred Tennyson",
	"The most hateful human misfortune is for a wise man to have no influence.\n- Herodotus",
	"Be yourself; everyone else is already taken.\n- Oscar Wilde"
}

function quote:run(context)
    local message = context.Message
	local header = {
		{"X-Api-Key", BotData.ApiNinjasKey}
	}

	local res, quoteData = corohttp.request("GET", "https://api.api-ninjas.com/v1/quotes", header)
	local finalQuoteData

	pcall(function()
		finalQuoteData = json.decode(quoteData)[1]
	end)

	if finalQuoteData and finalQuoteData.quote then
		message:reply{
			content = finalQuoteData.quote.."\n- "..finalQuoteData.author,
			reference = {
				message = message,
				mention = false
			}
		}
	else
		print(res)
		message:reply{
			content = quotes[math.random(1,#quotes)],
			reference = {
				message = message,
				mention = false
			}
		}
	end
end

return quote