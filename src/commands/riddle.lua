local riddle = {}

local riddles = {
    {
        "I can be cracked, made, told, and played. What am I?",
        "joke"
    },
    {
        "I fly without wings, I cry without eyes. Wherever I go, darkness follows me. What am I?",
        "cloud"
    },
    {
        "What can be swallowed but can also swallow you?",
        "pride"
    },
    {
        "I have cities but no houses, forests but no trees, and rivers but no water. What am I?",
        "map"
    },
    {
        "What has many keys but can't open any locks?",
        "piano"
    },
    {
        "I am a word of letters three. Add two, and fewer there will be. What am I?",
        "few"
    },
    {
        "What belongs to you but others use it more than you do?",
        "name"
    },
    {
        "What can you hold without ever touching or using your hands?",
        "breath"
    },
    {
        "As I walked along the path I saw something with four fingers and one thumb, but it was not flesh, fish, bone or fowl.",
        "glove"
    },
    {
        "What is always coming but never arrives?",
        "tomorrow"
    },
    {
        "What is so delicate that saying its name breaks it?",
        "silence"
    },
    {
        "What goes up the hill and down the hill, And spite of all, yet standeth still?",
        "road"
    },
    {
        "I am an instrument that you can hear, but you can't touch or see. What am I?",
        "voice"
    },
    {
        "What gets shorter as it grows older?",
        "candle"
    },
    {
        "What five-letter word becomes shorter when you add two letters to it?",
        "short"
    },
    {
        "What can fill a room but takes up no space?",
        "light"
    },
    {
        "What has ten letters and starts with gas?",
        "automobile"
    }
}

function riddle:run(context)
    local message = context.Message

    local randomRiddle = riddles[math.random(1, #riddles)]

    message:reply{
        embed = {
            title = "Here's a riddle for you...",
            description = randomRiddle[1],
            fields = {
                {name = "You have 25 seconds to answer me in this chat!", value = ""}
            },
            timestamp = Discordia.Date():toISO('T', 'Z'),
            color = _G.MainColor.value
        },
        reference = {
            message = message,
            mention = false
        }
    }

    local answered, userReplyMessage = Client:waitFor("messageCreate", 25000, function(userReplyMessage)
        return userReplyMessage.author == message.author and userReplyMessage.channel == message.channel
    end)

    if answered then
        if userReplyMessage.channel == message.channel then
            if userReplyMessage.content:lower() == randomRiddle[2] then
                userReplyMessage:reply{
                    embed = {
                        title = "Congratulations! You guessed it!",
                        description = "It was **"..randomRiddle[2].."**",
                        timestamp = Discordia.Date():toISO('T', 'Z'),
                        color = _G.MainColor.value
                    },
                    reference = {
                        message = userReplyMessage,
                        mention = false
                    }
                }
                return
            else
                userReplyMessage:reply{
                    embed = {
                        title = "Sadly, you failed to guess it :(",
                        description = "It was **"..randomRiddle[2].."**",
                        timestamp = Discordia.Date():toISO('T', 'Z'),
                        color = _G.MainColor.value
                    },
                    reference = {
                        message = userReplyMessage,
                        mention = false
                    }
                }
                return
            end
        end
    else
        message:reply{
            embed = {
                title = "Time's up! Sadly, you failed to guess it :(",
                description = "It was **"..randomRiddle[2].."**",
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

end

return riddle