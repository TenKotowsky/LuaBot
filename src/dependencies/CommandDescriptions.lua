local CommandDescriptions = {}

CommandDescriptions.Descriptions = {
    help = {
        Description = "Displays some information about the bot and a list of commands.",
        Category = "General",
        Arguments = "None"
    },
    patreon = {
        Description = "Gives you a link to LuaBot's Patreon <3",
        Category = "General",
        Arguments = "None"
    },
    ping = {
        Description = "Responds with \"Pong!\" and the bot's ping (latency) in milliseconds.",
        Category = "General",
        Arguments = "None"
    },
    prefix = {
        Description = "Changes current server's LuaBot prefix. The prefix can't be longer than 10 characters. \"Manage server\" permission required.",
        Category = "General",
        Arguments = "New prefix"
    },
    serverinfo = {
        Description = "Shows basic information about the server user: description (if any), id, server creation date, boost level, amount of members and amount of text and voice channels. The info embed also has a preview of server's icon.",
        Category = "General",
        Arguments = "None"
    },
    userinfo = {
        Description = "Shows basic information about mentioned user: nickname (if any), id, Discord join date and server join date. The info embed also has a preview of user's avatar.",
        Category = "General",
        Arguments = "User (mention/id)"
    },
    avatar = {
        Description = "Sends user's avatar.",
        Category = "General",
        Arguments = "User (mention/id)"
    },
    embed = {
        Description = "Sends the specified text as an embed.",
        Category = "General",
        Arguments = "Message"
    },
    emoji = {
        Description = "Enlarges a custom emoji, so you can easily download it. Doesn't work with Discord's default emojis.",
        Category = "General",
        Arguments = "Emoji"
    },
    reminders = {
        Description = "Shows a list of currently set reminders.",
        Category = "General",
        Arguments = "None"
    },
    remindme = {
        Description = "Sets a new reminder. Reminder time can be specified by just sending a number (this will be treated as amount of minutes). You can also use 1h for 1 hour, 1d for 1 day or 1w for 1 week, etc. However something like 1w 2d (1 week 2 days) will NOT work.",
        Category = "General",
        Arguments = "Minutes/Time, Reminder"
    },
    removereminder = {
        Description = "Removes a reminder which has the matching id, if it's this user's reminder. You can see a reminder's id by using the reminders command.",
        Category = "General",
        Arguments = "Reminder id"
    },
    ban = {
        Description = "Bans mentioned user.",
        Category = "Moderation",
        Arguments = "User (mention/id), Reason"
    },
    tempban = {
        Description = "Bans mentioned user for the specified amount of time. Tempban duration can be specified by just sending a number (this will be treated as amount of hours). If you want to ban someone a longer period of time you can use 1w for 1 week tempban, 1m for 1 month tempban or 1y for 1 year tempban, etc. However something like 1y 2m (1 year 2 months) will NOT work.",
        Category = "Moderation",
        Arguments = "User (mention/id), Hours/Time, Reason"
    },
    kick = {
        Description = "Kicks mentioned user.",
        Category = "Moderation",
        Arguments = "User (mention/id)"
    },
    mute = {
        Description = "Mutes given user for a specified amount of time. Mute duration can be specified by just sending a number (this will be treated as amount of seconds). If you want the duration to be longer, you can use 1m for 1 minute mute or 1h for 1 hour mute etc. However something like 1m 2s (1 miunte 2 seconds) will NOT work. Muting someone for 0 seconds basically unmutes this person. \"Timeout members\" permission required.",
        Category = "Moderation",
        Arguments = "User (mention/id), Duration"
    },
    slowmode = {
        Description = "Sets current channel's slowmode. Slowmode duration can be specified by just sending a number (this will be treated as amount of seconds). If you want the duration to be longer, you can use 1m for 1 minute slowmode or 1h for 1 hour slowmode etc. However something like 1m 2s (1 miunte 2 seconds) will NOT work. Setting the slowmode to 0 seconds disables it completely. \"Manage channels\" permission required.",
        Category = "Moderation",
        Arguments = "Duration"
    },
    tickle = {
        Description = "Makes you tickle given user.",
        Category = "Actions",
        Arguments = "User (mention)"
    },
    pat = {
        Description = "Makes you pat given user.",
        Category = "Actions",
        Arguments = "User (mention)"
    },
    hug = {
        Description = "Makes you hug given user.",
        Category = "Actions",
        Arguments = "User (mention)"
    },
    cuddle = {
        Description = "Makes you cuddle given user.",
        Category = "Actions",
        Arguments = "User (mention)"
    },
    kiss = {
        Description = "Makes you kiss given user.",
        Category = "Actions",
        Arguments = "User (mention)"
    },
    slap = {
        Description = "Makes you slap given user.",
        Category = "Actions",
        Arguments = "User (mention)"
    },
    smack = {
        Description = "Makes you smack given user.",
        Category = "Actions",
        Arguments = "User (mention)"
    },
    epicgamesfree = {
        Description = "Shows current free games on Epic Games Store.",
        Category = "Gaming",
        Arguments = "None"
    },
    steamuser = {
        Description = "Shows basic information about given Steam user's profile. You can find the vanity name in a profile's url, for example in \"https://steamcommunity.com/id/gabelogannewell\" the vanity name is gabelogannewell.",
        Category = "Gaming",
        Arguments = "Steam Vanity Name"
    },
    lolprofile = {
        Description = "Shows basic information about given League of Legends profile in the given region. Valid regions are: BR, EUNE, EUW, JP, KR, LAN, LAS, NA, OCE, TR and RU.",
        Category = "Gaming",
        Arguments = "Region, Summoner name"
    },
    robloxuser = {
        Description = "Shows basic information about given Roblox user's profile.",
        Category = "Gaming",
        Arguments = "Roblox username"
    },
    echo = {
        Description = "Echoes what you say.",
        Category = "4Fun",
        Arguments = "Message"
    },
    eightball = {
        Description = "The magic 8ball shall respond to your question.",
        Category = "4Fun",
        Arguments = "Message"
    },
    quote = {
        Description = "Sends a random quote using API Ninjas. If the API doesn't respond, sends a random quote from a premade quotes list.",
        Category = "4Fun",
        Arguments = "None"
    },
    recipe = {
        Description = "Sends a recipe for the specified dish using API Ninjas.",
        Category = "4Fun",
        Arguments = "Dish"
    },
    rhymes = {
        Description = "Sends a list of rhymes for the specified word using API Ninjas.",
        Category = "4Fun",
        Arguments = "Word"
    },
    urbandict = {
        Description = "Sends a definition from the Urban Dictionary using Urban Dictionary API.",
        Category = "4Fun",
        Arguments = "Word"
    },
    rps = {
        Description = "You can play a simple game of rock paper scissors with LuaBot.",
        Category = "4Fun",
        Arguments = "Rock/Paper/Scissors"
    },
    randomnumber = {
        Description = "Sends a random number between given min and max numbers. If the max number is bigger than 1000000000000, it will be changed to 1000000000000.",
        Category = "4Fun",
        Arguments = "Minimum number, Maximum number"
    },
    spotifyartist = {
        Description = "Shows basic information taken from Spotify about given artist.",
        Category = "4Fun",
        Arguments = "Artist name"
    },
    spotifyalbum = {
        Description = "Shows basic information taken from Spotify about given album and its tracklist. The tracklist contains the track's name, length and list of all artists appearing on it.",
        Category = "4Fun",
        Arguments = "Album name"
    },
}

return CommandDescriptions