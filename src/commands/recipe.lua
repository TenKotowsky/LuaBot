local corohttp = require("coro-http")
local json = require("json")

local recipe = {}

function recipe:run(context)
    local message = context.Message
	local channel = message.channel
	local header = {
		{"X-Api-Key", "HHRHB6I+UTHeeZJx1ZWNBA==17idOV9lboycNcUD"},
	}

	if #context.Args == 0 then
		message:reply("Specify what you want to see a recipe for!")
		return
	end
	local searchTerm = ""
	for i, v in pairs(context.Args) do
		if i == 1 then
			searchTerm = v
		else
			searchTerm = searchTerm.."%20"..v
		end
	end

	local res, recipeData = corohttp.request("GET", "https://api.api-ninjas.com/v1/recipe?query="..searchTerm, header)
	local finalRecipeData

	pcall(function()
		finalRecipeData = json.decode(recipeData)[1]
	end)

	if finalRecipeData then
		channel:send {
			embed = {
				title = finalRecipeData.title,
				fields = {
					{name = "Servings:", value = finalRecipeData.servings, inline = false},
					{name = "Ingredients:", value = finalRecipeData.ingredients:gsub("%|", "\n"), inline = false},
					{name = "Instructions:", value = finalRecipeData.instructions, inline = false}
				},
				color = _G.MainColor.value
			}
		}
	else
		message:reply("Couldn't find a recipe for that!")
	end
end

return recipe