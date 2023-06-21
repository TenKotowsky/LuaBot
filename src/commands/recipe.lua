require("discordia-expanded")
local corohttp = require("coro-http")
local json = require("json")

local recipe = {}

function recipe:run(context)
    local message = context.Message
	local header = {
		{"X-Api-Key", "..."},
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
		local fields
		if #finalRecipeData.instructions <= 1024 then
			fields = {
				{name = "Servings:", value = finalRecipeData.servings, inline = false},
				{name = "Ingredients:", value = finalRecipeData.ingredients:gsub("%|", "\n"), inline = false},
				{name = "Instructions:", value = finalRecipeData.instructions, inline = false}
			}
		else
			fields = {
				{name = "Servings:", value = finalRecipeData.servings, inline = false},
				{name = "Ingredients:", value = finalRecipeData.ingredients:gsub("%|", "\n"), inline = false},
				{name = "Instructions:", value = finalRecipeData.instructions:sub(1, 1024), inline = false},
				{name = "", value = finalRecipeData.instructions:sub(1025, #finalRecipeData.instructions), inline = false}
			}
		end
		message:reply {
			embed = {
				title = finalRecipeData.title,
				fields = fields,
				color = _G.MainColor.value
			}
		}
	else
		message:reply("Couldn't find a recipe for that!")
	end
end

return recipe
