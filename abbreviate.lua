local gsub = string.gsub
local match = string.match
local format = string.format

local shorthands = {
	INSTANCE_CHAT = 'i',
	OFFICER = 'o',
	GUILD = 'g',
	PARTY = 'p',
	RAID = 'r'
}

local classes = {}
do
	local male = {}
	local female = {}
	FillLocalizedClassList(male)
	FillLocalizedClassList(female, true)

	for token, localized in next, male do
		classes[localized] = token
	end

	for token, localized in next, female do
		classes[localized] = token
	end
end

local function AbbreviateChannel(channel, name)
	local flag = ''
	if(match(name, LEADER)) then
		flag = '|cffffff00!|r'
	end

	return format('|Hchannel:%s|h%s|h %s', channel, shorthands[channel] or gsub(channel, 'channel:', ''), flag)
end

local function FormatPlayer(info, name)
	return format('|Hplayer:%s|h%s|h', info, gsub(name, '%-[^|]+', ''))
end

local clientColors = {
	[BNET_CLIENT_D3] = 'b71709',
	[BNET_CLIENT_SC2] = '00b6ff',
	[BNET_CLIENT_WTCG] = 'd37000',
	[BNET_CLIENT_HEROES] = '6800c4',
}

local function FormatBNPlayer(info, name)
	local friendIndex = BNGetFriendIndex(match(info, '(%d+):'))
	if(friendIndex and friendIndex ~= 0) then
		local _, toon, client, _, _, _, _, localizedClass = BNGetFriendGameAccountInfo(friendIndex, 1)
		if(client == BNET_CLIENT_WOW) then
			local colors = RAID_CLASS_COLORS[classes[localizedClass]]
			return format('|HBNplayer:%s|h|c%s%s|r|h', info, colors.colorStr, toon)
		else
			local color = clientColors[client]
			if(color) then
				return format('|HBNplayer:%s|h#|cff%s%s|r|h', info, color, toon)
			end
		end
	end

	return format('|HBNplayer:%s|h%s|h', info, name)
end

local hooks = {}
local function AddMessage(self, message, ...)
	message = gsub(message, '|Hplayer:(.-)|h%[(.-)%]|h', FormatPlayer)
	message = gsub(message, '|HBNplayer:(.-)|h%[(.-)%]|h', FormatBNPlayer)
	message = gsub(message, '|Hchannel:(.-)|h%[(.-)%]|h ', AbbreviateChannel)

	message = gsub(message, '^%w- (|H)', '|cffa1a1a1@|r%1')
	message = gsub(message, '^(.-|h) %w-:', '%1:')
	message = gsub(message, '^%[' .. RAID_WARNING .. '%]', 'w')

	return hooks[self](self, message, ...)
end

for index = 1, 5 do
	if(index ~= 2) then
		local ChatFrame = _G['ChatFrame' .. index]
		hooks[ChatFrame] = ChatFrame.AddMessage
		ChatFrame.AddMessage = AddMessage
	end
end
