local eightball = {}

local responses = {
    "It is certain.",
    "It is decidedly so.",
    "Without a doubt.",
    "Yes definitely.",
    "You may rely on it.",
    "As I see it, yes.",
    "Most likely.",
    "Outlook good.",
    "Yes.",
    "Signs point to yes.",
    "Reply hazy, try again.",
    "Ask again later.",
    "Better not tell you now.",
    "Cannot predict now.",
    "Concentrate and ask again.",
    "Don't count on it.",
    "My reply is no.",
    "My sources say no.",
    "Outlook not so good.",
    "Very doubtful."
}

function eightball:run(context)
    local msg, err = context.Message:reply{
        embed = {
            title = "The magic 8ball says...",
            description = responses[math.random(1, #responses)],
            timestamp = Discordia.Date():toISO('T', 'Z'),
            color = _G.MainColor.value
        },
        reference = {
            message = context.Message,
            mention = false
        }
    }
    if not msg then
        print(err)
    end
end

return eightball