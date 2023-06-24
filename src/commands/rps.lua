require("discordia-expanded")
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
        message:reply("You have to choose between rock, paper and scissors!")
        return
    else
        local choice = context.Args[1]:lower()
        if not choices[choice] then
            message:reply("You have to choose between rock, paper and scissors!")
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
                color = _G.MainColor.value
            }
        }
    end
end

return rps