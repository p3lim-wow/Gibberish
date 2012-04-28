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

local function AddMessage(self, message, ...)
	message = message:gsub('|Hplayer:(.-)|h%[(.-)%]|h', Strip)
	message = message:gsub('|HBNplayer:(.-)|h%[(.-)%]|h', '|HBNplayer:%1|h%2|h')

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
