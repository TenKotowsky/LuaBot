local corohttp = require("coro-http")
local json = require("json")

local rhyme = {}

function rhyme:run(context)
    local message = context.Message
	local channel = message.channel
	local header = {
		{"X-Api-Key", "HHRHB6I+UTHeeZJx1ZWNBA==17idOV9lboycNcUD"},
	}

	if #context.Args == 0 then
		message:reply("Specify the word for which you want to see rhymes!")
		return
	end

	local res, rhymesData = corohttp.request("GET", "https://api.api-ninjas.com/v1/rhyme?word="..context.Args[1], header)
	local finalRhymesData

	pcall(function()
		finalRhymesData = json.decode(rhymesData)
	end)

	if finalRhymesData then
		local rhymes = ""
		for i, v in pairs(finalRhymesData) do
			if i == 1 then
				rhymes = v
			else
				rhymes = rhymes..", "..v
			end
		end
		if #rhymes < 2048 then
			channel:send {
				embed = {
					title = "Words that rhyme with "..context.Args[1],
					description = rhymes,
					color = _G.MainColor.value
				}
			}
		else
			channel:send {
				embed = {
					title = "Words that rhyme with "..context.Args[1],
					description = rhymes:sub(1, 2048),
					color = _G.MainColor.value
				}
			}
			channel:send {
				embed = {
					description = rhymes:sub(2049, #rhymes),
					color = _G.MainColor.value
				}
			}
		end
	else
		message:reply("Couldn't find a recipe for that!")
	end
end

return rhyme