local ship = {}

function ship:run(context)
    local message = context.Message
    local user1
    local user2
    for i, v in pairs(message.mentionedUsers:toArray()) do
        if i == 1 then
            user1 = v
        elseif i == 2 then
            user2 = v
            break
        end
    end
    if not user1 then
        message:reply{
            embed = {
                title = "Specify the first user properly!",
                description = "Having problems with the command? Try using `commandinfo "..context.CommandName.."` to get more information about it!",
                timestamp = Discordia.Date():toISO('T', 'Z'),
                color = _G.MainColor.value
            },
			reference = {
				message = message,
				mention = false
			}
		}
    end
    if not user2 then
        user2 = message.author
    end

    local nameTogether = user1.name:sub(1,math.floor(#user1.name/2))..user2.name:sub(math.floor(#user2.name/2), #user2.name)
    local description
    local percentage = math.random(1, 100)

    if percentage < 25 then
        description = "Your love might not be that strong... but it {percentage}% is still better than 0%, right?\nYou two could still be called "..nameTogether.." for sure!"
    elseif percentage < 50 then
        description = "Your love is not that weak actually!\nYou two should be called "..nameTogether.." for sure!"
    elseif percentage < 75 then
        description = "Woah, your love is quite strong!\nYou two should be called "..nameTogether.." for sure!"
    elseif percentage < 100 then
        description = "You two are litereally made for each other!\nYou two should be called "..nameTogether.." for sure!"
    else
        description = "100%?! I've never seen such strong love!\nYou two should be called "..nameTogether.." for sure!"
    end

    message:reply{
        embed = {
            title = "Percentage of love between you is... "..percentage.."%",
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

return ship