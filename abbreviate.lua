local hooks = {}
local abbrev = {
	BATTLEGROUND = 'b',
	OFFICER = 'o',
	GUILD = 'g',
	PARTY = 'p',
	RAID = 'r',
}

local function Strip(info, name)
	return string.format('|Hplayer:%s|h%s|h', info, name:gsub('%-[^|]+', ''))
end

local function Abbreviate(channel)
	return string.format('|Hchannel:%s|h%s|h', channel, abbrev[channel] or channel:gsub('channel:', ''))
end

local function BattleNet(info, name)
	local _, presence = string.split(':', info)
	local _, toon, client, _, _, _, _, class = BNGetFriendToonInfo(BNGetFriendIndex(presence), 1)

	if(client == BNET_CLIENT_WOW) then
		local colors = RAID_CLASS_COLORS[string.upper(class)]
		return string.format('|HBNplayer:%s|h|cff%2x%2x%2x%s|r|h', info, colors.r * 255, colors.g * 255, colors.b * 255, toon)
	elseif(client == BNET_CLIENT_D3) then
		return string.format('|HBNplayer:%s|h|TInterface\\ChatFrame\\UI-ChatIcon-D3:15:15:-2:-1:72:72:16:58:16:58|t|cffB71709%s|r|h', info, toon)
	elseif(client == BNET_CLIENT_S2) then
		return string.format('|HBNplayer:%s|h|TInterface\\ChatFrame\\UI-ChatIcon-SC2:15:15:-1:-1:72:72:16:58:16:58|t|cff00B6FF%s|r|h', info, toon)
	else
		return string.format('|HBNplayer:%s|h%s|h', info, name)
	end
end

local function AddMessage(self, message, ...)
	message = message:gsub('|Hplayer:(.-)|h%[(.-)%]|h', Strip)
	message = message:gsub('|HBNplayer:(.-)|h%[(.-)%]|h', BattleNet)

	message = message:gsub('|Hchannel:(.-)|h%[(.-)%]|h', Abbreviate)

	message = message:gsub('^To (.-|h)', '|cffA1A1A1@|r%1')
	message = message:gsub('^(.-|h) whispers', '%1')
	message = message:gsub('^(.-|h) says', '%1')
	message = message:gsub('^(.-|h) yells', '%1')
	message = message:gsub('^%['..RAID_WARNING..'%]', 'w')

	return hooks[self](self, message, ...)
end

for index = 1, 5 do
	local frame = _G['ChatFrame'..index]
	hooks[frame] = frame.AddMessage
	frame.AddMessage = AddMessage
end
