local hooks = {}
local abbrev = {
	BATTLEGROUND = 'b',
	GUILD = 'g',
	PARTY = 'p',
	RAID = 'r',
}

local function Abbreviate(channel)
	return string.format('|Hchannel:%s|h%s|h', channel, abbrev[channel] or channel:gsub('channel:', ''))
end

local function AddMessage(frame, str, ...)
	str = str:gsub('|Hplayer:(.-)|h%[(.-)%]|h', '|Hplayer:%1|h%2|h')
	str = str:gsub('|HBNplayer:(.-)|h%[(.-)%]|h', '|HBNplayer:%1|h%2|h')
	str = str:gsub('|Hchannel:(.-)|h%[(.-)%]|h', Abbreviate)

	str = str:gsub('^To (.-|h)', '|cffA1A1A1@|r%1')
	str = str:gsub('^(.-|h) whispers', '%1')
	str = str:gsub('^(.-|h) says', '%1')
	str = str:gsub('^(.-|h) yells', '%1')
	str = str:gsub('^%['..RAID_WARNING..'%]', 'w')

	return hooks[frame](frame, str, ...)
end

for index = 1, 5 do
	local frame = _G['ChatFrame'..index]
	hooks[frame] = frame.AddMessage
	frame.AddMessage = AddMessage
end
