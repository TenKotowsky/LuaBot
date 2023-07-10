local wyr = {}

local questions = {
    {
        "Have a personal chef",
        "Have a personal masseuse"
    },
    {
        "Have unlimited pizza for life",
        "Have unlimited ice cream for life"
    },
    {
        "Be hot",
        "Be cute"
    },
    {
        "Be able to rewind time",
        "Be able to fast forward time"
    },
    {
        "Have a personal theme song that plays around you all the time",
        "Have a personal soundtrack that has a different song for every place you visit"
    },
    {
        "Live in a world without music",
        "Live in a world without movies"
    },
    {
        "Have a pet lion",
        "Have a pet tiger"
    },
    {
        "Live in a city forever",
        "Live in a village forever"
    },
    {
        "Play video games on a PC forever",
        "Play video games on consoles forever"
    },
    {
        "Dress entirely in black for life",
        "Dress entirely in pink for life"
    },
    {
        "Be featured on your music idol's song",
        "Star in your favorite director's movie"
    },
    {
        "Be able to send only emojis for the rest of your life",
        "Be able to send only GIFs for the rest of your life"
    },
    {
        "Have a TikTok account with a million followers",
        "Have a YouTube channel with a million subscribers"
    },
    {
        "Have a lifetime supply of free coffee from Starbucks",
        "Have a lifetime supply of free food from your favorite fast-food restaurant"
    },
    {
        "Have the ability to have real-life achievements and earn rewards for completing tasks",
        "Have a video game HUD (heads-up display) in real life which would show you imporatnt information about you and your surroundings"
    },
    {
        "Have a gaming session with your favorite celebrity",
        "Win a gaming tournament with the best player in the world"
    },
    {
        "Live on Mars",
        "Keep living on Earth"
    },
    {
        "Listen to Rap for the rest of your life",
        "Listen to Pop for the rest of your life"
    },
    {
        "Learn a language that's easy but hardly anyone speaks it",
        "Learn a language that's almost impossible to learn, but a lot of people speak it"
    },
    {
        "Live in the Middle Ages",
        "Live in the Antique"
    },
    {
        "Eat sand",
        "Eat dirt"
    },
    {
        "Be forced to sing along to every single song you hear",
        "Be forced to dance to every single song you hear"
    },
    {
        "Die in 10 years with no regrets",
        "Live to 100 with a lot of regrets"
    },
    {
        "Be in a zombie apocalypse",
        "Be in a robot/AI apocalypse"
    },
    {
        "Lose the ability to read",
        "Lose the ability to speak"
    },
    {
        "Live in Antarctica",
        "Live in the Sahara Dessert"
    },
    {
        "Be a character in an action-packed thriller",
        "Be a character in an high school romance"
    }
}

function wyr:run(context)
    local message = context.Message

    local randomQuestion = questions[math.random(1, #questions)]

    local sentMessage, err =  message:reply{
        embed = {
            title = "Would you rather...",
            fields = {
                {name = ":regional_indicator_a: "..randomQuestion[1], value = ""},
                {name = ":regional_indicator_b: "..randomQuestion[2], value = ""}
            },
            timestamp = Discordia.Date():toISO('T', 'Z'),
            color = _G.MainColor.value
        },
        reference = {
            message = message,
            mention = false
        }
    }
    if sentMessage then
        sentMessage:addReaction("🇦")
        sentMessage:addReaction("🇧")
    end
end

return wyr