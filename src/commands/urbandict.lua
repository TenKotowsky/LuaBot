local corohttp = require("coro-http")
local json = require("json")

local urbandict = {}

function urbandict:run(context)
    local message = context.Message
	local channel = message.channel
    local args = context.Args

    local term = ""
    for _, v in pairs(args) do
		term = term.."%20"..v
	end

	local res, termData = corohttp.request("GET", "https://api.urbandictionary.com/v0/define?term="..term)
	local finalTermData

	pcall(function()
		finalTermData = json.decode(termData)
	end)

	if finalTermData and finalTermData.list then
        term = ""
        for i, v in pairs(args) do
            if i == 1 then
                term = v
            else
                term = term.." "..v
            end
        end
        local patterns = {"%[", "%]"}
        local definition = finalTermData.list[1].definition
        local example = finalTermData.list[1].example
        for i,v in ipairs(patterns) do
            definition = string.gsub(definition, v, "")
            example = string.gsub(example, v, "")
        end
		message:reply{
            embed = {
                title = term.." definition:",
                description = definition,
                fields = {
                    {name = "Example:", value = example, inline = false}
                },
                url = finalTermData.list[1].permalink,
                timestamp = Discordia.Date():toISO('T', 'Z'),
                color = _G.MainColor.value
            },
			reference = {
				message = message,
				mention = false
			}
        }
	else
		message:reply{
            content = "An error occured when trying to get this term's definition!",
			reference = {
				message = message,
				mention = false
			}
        }
	end
end

return urbandict