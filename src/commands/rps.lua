local Functions = require("../dependencies/Functions.lua")

local rps = {}

local choices = {
    ["1"] = "Paper",
    ["2"] = "Rock",
    ["3"] = "Scissors",
    ["paper"] = 1,
    ["rock"] = 2,
    ["scissors"] = 3
}

function rps:run(context)
    local message = context.Message
    if not context.Args[1] then
        message:reply{
            embed = {
                title = "You have to choose between rock, paper and scissors!",
                description = "Having problems with the command? Try using `commandinfo "..context.CommandName.."` to get more information about it!",
                timestamp = Discordia.Date():toISO('T', 'Z'),
                color = _G.MainColor.value
            },
			reference = {
				message = message,
				mention = false
			}
        }
        return
    else
        local choice = context.Args[1]:lower()
        if not choices[choice] then
            message:reply{
                embed = {
                    title = "You have to choose between rock, paper and scissors!",
                    description = "Having problems with the command? Try using `commandinfo "..context.CommandName.."` to get more information about it!",
                    timestamp = Discordia.Date():toISO('T', 'Z'),
                    color = _G.MainColor.value
                },
                reference = {
                    message = message,
                    mention = false
                }
            }
            return
        end
        local description = ""
        local random = math.random(1,3)
        local botChosen = choices[tostring(random)]

        if choices[choice] == random then
            description = ("Tie! We both picked same!")
        else
            if (choices[choice] == 1 and random == 2) or (choices[choice] == 2 and random == 3) or (choices[choice] == 3 and random == 1) then
                description = "Congratulations, you won!"
            else 
                description = "You lost, but don't worry! You'll win next time!"
            end
        end
       
        message:reply{
            embed = {
                title = "I choose... "..botChosen,
                description = description,
                timestamp = Discordia.Date():toISO('T', 'Z'),
                color = _G.MainColor.value
            },
			reference = {
				message = message,
				mention = false
			}
        }
    end
end

return rps