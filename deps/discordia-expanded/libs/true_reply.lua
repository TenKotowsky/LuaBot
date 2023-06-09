-- from incredible-gmod.ru with <3

local pathjoin = require("pathjoin")
local fs = require("fs")

local readFileSync = fs.readFileSync
local splitPath = pathjoin.splitPath
local classes = Discordia.class.classes
local Message = classes.Message
local TextChannel = classes.TextChannel
local GuildTextChannel = classes.GuildTextChannel

local insert, remove, concat = table.insert, table.remove, table.concat
local format = string.format

local is_string = getmetatable("")
local function isstring(var)
	return getmetatable(var) == is_string
end

local is_table = {table = true}
local function istable(var)
	return is_table[type(var)] or false
end

local function parseMentions(content, pattern)
	if not content:find('%b<>') then return {} end
	local mentions, seen = {}, {}
	for id in content:gmatch(pattern) do
		if not seen[id] then
			insert(mentions, id)
			seen[id] = true
		end
	end
	return mentions
end

Message._OldReply = Message.__OldReply or Message.reply

function Message:reply(content, noreply)
	if noreply then
		return self._parent:send(content)
	else
		content = istable(content) and content or {content = content}
		content.message_reference = {
			guild_id = self._parent.guild and self._parent.guild.id or nil,
			channel_id = self._parent.id,
			message_id = self.id,
		}

		return self._parent:send(content)
	end
end

Message._Old__init = Message._Old__init or Message.__init
function Message:__init(data, parent)
	if data.message_reference then
		local id = data.message_reference.message_id
		self._reference = parent:getMessage(id)
	end

	return self:_Old__init(data, parent)
end

local function parseFile(obj, files)
	if isstring(obj) then
		local data, err = readFileSync(obj)
		if not data then
			return nil, err
		end
		files = files or {}
		insert(files, {remove(splitPath(obj)), data})
	elseif istable(obj) and isstring(obj[1]) and isstring(obj[2]) then
		files = files or {}
		insert(files, obj)
	else
		return nil, "Invalid file object: " .. tostring(obj)
	end
	return files
end

TextChannel._OldSend = TextChannel._OldSend or TextChannel.send

function TextChannel:send(content)
	local data, err

	if istable(content) then
		local tbl = content
		content = tbl.content

		if isstring(tbl.code) then
			content = format("```%s\n%s\n```", tbl.code, content)
		elseif tbl.code == true then
			content = format("```\n%s\n```", content)
		end

		local mentions
		if tbl.mention then
			mentions, err = parseMentions(tbl.mention)
			if err then
				return nil, err
			end
		end
		if istable(tbl.mentions) then
			for _, mention in ipairs(tbl.mentions) do
				mentions, err = parseMentions(mention, mentions)
				if err then
					return nil, err
				end
			end
		end
		if mentions then
			insert(mentions, content)
			content = concat(mentions, " ")
		end

		local files
		if tbl.file then
			files, err = parseFile(tbl.file)
			if err then
				return nil, err
			end
		end
		if istable(tbl.files) then
			for _, file in ipairs(tbl.files) do
				files, err = parseFile(file, files)
				if err then
					return nil, err
				end
			end
		end

		data, err = self.client._api:createMessage(self._id, {
			content = content,
			tts = tbl.tts,
			nonce = tbl.nonce,
			embed = tbl.embed,
			message_reference = tbl.message_reference and tbl.message_reference or nil,
			components = tbl.components
		}, files)

	else
		data, err = self.client._api:createMessage(self._id, {content = content})
	end

	if data then
		return self._messages:_insert(data)
	else
		return nil, err
	end

end

GuildTextChannel._OldSend = GuildTextChannel._OldSend or GuildTextChannel.send
GuildTextChannel.send = TextChannel.send -- discordia class lib sucks when base classes come into play