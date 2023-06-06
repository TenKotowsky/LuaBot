require("discordia-expanded")

local patreon = {}

function patreon:run(context)
	local embed = {
		title = "Patreon",
		description = "LuaBot 100% free and open-source. It features no premium plans or anything like that, so we don't really earn money from it. However, we have to pay for the bot's hosting somehow. Please consider supporting us on Patreon!",
		fields = {
			{name = "**Patreon:**", value = "https://www.patreon.com/LuaBot", inline = false},
		},
		color = _G.MainColor.value
	}

    context.Message:reply{embed = embed}
end

return patreon