local quote = {}

local quotes = {
	"In three words I can sum up everything I've learned about life: it goes on.\n- Robert Frost.",
	"When something is important enough, you do it even if the odds are not in your favor.\n- Elon Musk",
	"Life is really simple, but we insist on making it complicated.\n- Confucius",
	"Learn from yesterday, live for today, hope for tomorrow. The important thing is not to stop questioning.\n- Albert Einstein",
	"For what shall it profit a man, if he gain the whole world, and suffer the loss of his soul?\n- Jesus Christ",
	"'Tis better to have loved and lost than never to have loved at all.\n- Alfred Tennyson",
	"The most hateful human misfortune is for a wise man to have no influence.\n- Herodotus",
	"Be yourself; everyone else is already taken.\n- Oscar Wilde"
}

function quote.Quote(channel)
	channel:send(quotes[math.random(1,#quotes)])
end

return quote