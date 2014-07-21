local string_gsub = string.gsub
local string_find = string.find
local string_split = string.split
local string_format = string.format

local hooks = {}
local abbrev = {
	INSTANCE_CHAT = 'i',
	OFFICER = 'o',
	GUILD = 'g',
	PARTY = 'p',
	RAID = 'r',
}

local classes = {}
do
	local maleClasses = {}
	local femaleClasses = {}
	FillLocalizedClassList(maleClasses)
	FillLocalizedClassList(femaleClasses, true)

	for token, localized in next, maleClasses do
		classes[localized] = token
	end

	for token, localized in next, femaleClasses do
		classes[localized] = token
	end
end

local function Strip(info, name)
	return string_format('|Hplayer:%s|h%s|h', info, string_gsub(name, '%-[^|]+', ''))
end

local function Abbreviate(channel, name)
	local leader = ''
	if(string_find(name, LEADER)) then
		leader = '|cffffff00!|r'
	end

	return string_format('|Hchannel:%s|h%s|h %s', channel, abbrev[channel] or string_gsub(channel, 'channel:', ''), leader)
end

local function AbbreviateConversation(id, name)
	return string_format('|Hchannel:BN_CONVERSATION:%s|h1%s|h ', id, id)
end

local function BattleNet(info, name)
	local _, presence = string_split(':', info)
	local friendIndex = BNGetFriendIndex(presence)

	if(friendIndex and friendIndex ~= 0) then
		local _, toon, client, _, _, _, _, class = BNGetFriendToonInfo(friendIndex, 1)
		if(client == BNET_CLIENT_WOW) then
			local colors = RAID_CLASS_COLORS[classes[class]]
			return string_format('|HBNplayer:%s|h|c%s%s|r|h', info, colors.colorStr, toon)
		elseif(client == BNET_CLIENT_D3) then
			return string_format('|HBNplayer:%s|h|TInterface\\ChatFrame\\UI-ChatIcon-D3:15:15:-2:-1:72:72:16:58:16:58|t|cffB71709%s|r|h', info, toon)
		elseif(client == BNET_CLIENT_SC2) then
			return string_format('|HBNplayer:%s|h|TInterface\\ChatFrame\\UI-ChatIcon-SC2:15:15:-1:-1:72:72:16:58:16:58|t|cff00B6FF%s|r|h', info, toon)
		end
	end

	return string_format('|HBNplayer:%s|h%s|h', info, name)
end

local function AddMessage(self, message, ...)
	message = string_gsub(message, '|Hplayer:(.-)|h%[(.-)%]|h', Strip)
	message = string_gsub(message, '|HBNplayer:(.-)|h%[(.-)%]|h', BattleNet)
	message = string_gsub(message, '|Hchannel:(.-)|h%[(.-)%]|h ', Abbreviate) -- add $?
	message = string_gsub(message, '|Hchannel:BN_CONVERSATION:(.-)|h%[(.-)%]|h', AbbreviateConversation) -- add $?

	message = string_gsub(message, '^To (.-|h)', '|cffA1A1A1@|r%1')
	message = string_gsub(message, '^(.-|h) whispers', '%1')
	message = string_gsub(message, '^(.-|h) says', '%1')
	message = string_gsub(message, '^(.-|h) yells', '%1')
	message = string_gsub(message, '^%['..RAID_WARNING..'%]', 'w')

	return hooks[self](self, message, ...)
end

for index = 1, 4 do
	local frame = _G['ChatFrame'..index]
	hooks[frame] = frame.AddMessage
	frame.AddMessage = AddMessage
end
