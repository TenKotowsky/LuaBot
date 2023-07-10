local BotData = require("../dependencies/BotData.lua")
local corohttp = require("coro-http")
local json = require("json")

local facts = {
	"Cows have best friends. They form strong bonds with other cows and often become stressed or anxious when separated from their buddies.",
	"The average person will spend about six months of their life waiting for red traffic lights.",
	"Honey never spoils. Archaeologists have found pots of honey in ancient Egyptian tombs that are over 3,000 years old and still perfectly edible.",
	"The shortest war in history lasted only 38 to 45 minutes. It occurred between Britain and Zanzibar on August 27, 1896.",
	"The world's oldest known joke is a Sumerian joke from 1900 BC. The joke is about a father giving his son advice on how to be a successful scribe.",
	"The Hawaiian alphabet only has 12 letters: A, E, I, O, U, H, K, L, M, N, P, and W. This makes it one of the shortest alphabets in the world.",
	"The world's largest snowflake was recorded in 1887 and measured 15 inches in diameter.",
	"The world's oldest known recipe is a Sumerian beer recipe from around 1800 BC. It includes instructions on how to brew beer using barley.",
    "Astronauts cannot cry in space due to the absence of gravity. Tears cannot flow in zero gravity, so they accumulate around the eyes and form a liquid ball.",
    "The average person walks the equivalent of three times around the world in their lifetime.",
    "The original name of the search engine \"Google\" was \"Backrub\" before it was changed to the now-familiar name we know today.",
    "The fingerprints of a koala are so indistinguishable from humans that they have been mistaken at crime scenes.",
    "The Great Wall of China is not visible from space with the naked eye, contrary to popular belief. It's too narrow to be seen from such a distance."
}

local fact = {}

function fact:run(context)
    local message = context.Message
	local header = {
		{"X-Api-Key", BotData.ApiNinjasKey}
	}

	local res, factData = corohttp.request("GET", "https://api.api-ninjas.com/v1/facts?limit=1", header)
	local finalFactData

	pcall(function()
		finalFactData = json.decode(factData)[1]
	end)

	if finalFactData and finalFactData.fact then
		message:reply{
			content = finalFactData.fact,
			reference = {
				message = message,
				mention = false
			}
		}
	else
		print(factData)
		message:reply{
			content = facts[math.random(1,#facts)],
			reference = {
				message = message,
				mention = false
			}
		}
	end
end
return fact