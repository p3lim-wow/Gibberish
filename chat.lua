local addon = CreateFrame('Frame')
addon:RegisterEvent('ADDON_LOADED')
addon:RegisterEvent('PLAYER_LOGIN')
addon:SetScript('OnEvent', function(self, event, ...) self[event](self, ...) end)

local gsub = string.gsub
local format = string.format

-- No idea why blizzard havent added this
local CHAT_MSG_PARTY_GUIDE = gsub(CHAT_PARTY_GUIDE_GET, '|Hchannel:party|h%[(.-)%]|h .*', '%1')

local hooks = {}
local strings = {
	[CHAT_MSG_GUILD] = 'g',
	[CHAT_MSG_PARTY] = 'p',
	[CHAT_MSG_PARTY_GUIDE] = '|cffffff00p|r',
	[CHAT_MSG_PARTY_LEADER] = '|cffffff00p|r',
	[CHAT_MSG_RAID] = 'r',
	[CHAT_MSG_RAID_LEADER] = '|cffffff00r|r',
	[CHAT_MSG_BATTLEGROUND] = 'b',
	[CHAT_MSG_BATTLEGROUND_LEADER] = '|cffffff00b|r',
}

local function ReplaceStrings(channel, orig)
	return format('|Hchannel:%s|h%s|h', channel, strings[orig] or channel)
end

local function AddMessage(self, str, ...)
	if(not str) then return hooks[self](self, str, ...) end

	str = str:gsub('|Hplayer:(.-)|h%[(.-)%]|h', '|Hplayer:%1|h%2|h')
	str = str:gsub('|Hchannel:(.-)|h%[(.-)%]|h', ReplaceStrings)

	str = str:gsub('^To (.-|h)', '|cffA1A1A1'..date('%H%M.%S')..'|r |cffA1A1A1@|r%1')
	str = str:gsub('^(.-|h) whispers', '|cffA1A1A1'..date('%H%M.%S')..'|r %1')
	str = str:gsub('^%['..RAID_WARNING..'%]', 'w')
	str = str:gsub('^(.-|h) says', '%1')
	str = str:gsub('^(.-|h) yells', '%1')

	return hooks[self](self, str, ...)
end

SLASH_TellTarget1 = '/tt'
SlashCmdList.TellTarget = function(str)
	if(UnitIsPlayer('target') and UnitIsFriend('player', 'target')) then
		SendChatMessage(str, 'WHISPER', GetDefaultLanguage('player'), GetUnitName('target', true):gsub('%s', '', 2))
	end
end

hooksecurefunc('ChatEdit_OnSpacePressed', function(self)
	if(string.match(string.lower(self:GetText()), '^/tt $') and UnitIsPlayer('target') and UnitIsFriend('player', 'target')) then
		self:Hide()
		self:SetAttribute('chatType', 'WHISPER')
		self:SetAttribute('tellTarget', GetUnitName('target', true):gsub('%s', '', 2))
		ChatFrame_OpenChat('')
	end
end)

local function OnMouseWheel(self, direction)
	if(direction > 0) then
		if(IsShiftKeyDown()) then
			self:ScrollToTop()
		elseif(IsControlKeyDown()) then
			self:PageUp()
		else
			self:ScrollUp()
		end
	elseif(direction < 0) then
		if(IsShiftKeyDown()) then
			self:ScrollToBottom()
		elseif(IsControlKeyDown()) then
			self:PageDown()
		else
			self:ScrollDown()
		end
	end
end

function addon:ADDON_LOADED(name)
	if(name ~= 'Blizzard_CombatLog') then return end

	for index = 1, 5 do
		local frame = _G['ChatFrame'..index]
		frame:EnableMouseWheel()
		frame:SetScript('OnMouseWheel', OnMouseWheel)
		frame:SetFont([=[Interface\AddOns\Gibberish\vera.ttf]=], 12)

		_G['ChatFrame'..index..'UpButton']:SetScript('OnShow', frame.Hide)
		_G['ChatFrame'..index..'DownButton']:SetScript('OnShow', frame.Hide)
		_G['ChatFrame'..index..'BottomButton']:SetScript('OnShow', frame.Hide)

		SetChatWindowLocked(index)
		SetChatWindowAlpha(index, 0)
		ChatFrame_RemoveAllMessageGroups(frame)

		if(index == 1) then
			ChatFrame_RemoveAllChannels(frame)
			ChatFrame_AddMessageGroup(frame, 'SAY')
			ChatFrame_AddMessageGroup(frame, 'EMOTE')
			ChatFrame_AddMessageGroup(frame, 'GUILD')
			ChatFrame_AddMessageGroup(frame, 'PARTY')
			ChatFrame_AddMessageGroup(frame, 'PARTY_LEADER')
			ChatFrame_AddMessageGroup(frame, 'RAID')
			ChatFrame_AddMessageGroup(frame, 'RAID_LEADER')
			ChatFrame_AddMessageGroup(frame, 'RAID_WARNING')
			ChatFrame_AddMessageGroup(frame, 'BATTLEGROUND')
			ChatFrame_AddMessageGroup(frame, 'BATTLEGROUND_LEADER')
			ChatFrame_AddMessageGroup(frame, 'SYSTEM')
			ChatFrame_AddMessageGroup(frame, 'MONSTER_WHISPER')
			ChatFrame_AddMessageGroup(frame, 'MONSTER_BOSS_WHISPER')
		elseif(index == 2) then
			FCF_UnDockFrame(frame)
			FCF_Close(frame)
		elseif(index == 3) then
			FCF_DockFrame(frame, 2)
			ChatFrame_AddMessageGroup(frame, 'WHISPER')
			ChatFrame_AddMessageGroup(frame, 'IGNORED')
			SetChatWindowName(index, 'Whisper')
			SetChatWindowShown(index, true)
		elseif(index == 4) then
			FCF_DockFrame(frame, 3)
			ChatFrame_AddMessageGroup(frame, 'LOOT')
			SetChatWindowName(index, 'Loot')
			SetChatWindowShown(index, true)
		elseif(index == 5) then
			FCF_DockFrame(frame, 4)
			LeaveChannelByName('LocalDefense')
			ChatFrame_AddChannel(frame, 'General')
			ChatFrame_AddChannel(frame, 'Trade')
			ChatFrame_AddChannel(frame, 'LookingForGroup')
			SetChatWindowName(index, 'Channel')
			SetChatWindowShown(index, true)
		end

		if(frame.isDocked) then
			hooks[frame] = frame.AddMessage
			frame.AddMessage = AddMessage
		end
	end
end

function addon:PLAYER_LOGIN()
	local editbox = ChatFrameEditBox
	editbox:ClearAllPoints()
	editbox:SetPoint('BOTTOMLEFT', ChatFrame1, 'TOPLEFT', -5, 20)
	editbox:SetPoint('BOTTOMRIGHT', ChatFrame1, 'TOPRIGHT', 5, 20)
	editbox:SetFont([=[Interface\AddOns\Gibberish\vera.ttf]=], 14)
	editbox:SetAltArrowKeyMode(false)

	local regions = {editbox:GetRegions()}
	regions[6]:Hide()
	regions[7]:Hide()
	regions[8]:Hide()

	ChatFrameMenuButton:Hide()

	ToggleChatColorNamesByClassGroup(true, 'SAY')
	ToggleChatColorNamesByClassGroup(true, 'EMOTE')
	ToggleChatColorNamesByClassGroup(true, 'GUILD')
	ToggleChatColorNamesByClassGroup(true, 'WHISPER')
	ToggleChatColorNamesByClassGroup(true, 'PARTY')
	ToggleChatColorNamesByClassGroup(true, 'PARTY_LEADER')
	ToggleChatColorNamesByClassGroup(true, 'RAID')
	ToggleChatColorNamesByClassGroup(true, 'RAID_LEADER')
	ToggleChatColorNamesByClassGroup(true, 'RAID_WARNING')
	ToggleChatColorNamesByClassGroup(true, 'BATTLEGROUND')
	ToggleChatColorNamesByClassGroup(true, 'BATTLEGROUND_LEADER')
	ToggleChatColorNamesByClassGroup(true, 'CHANNEL1')
	ToggleChatColorNamesByClassGroup(true, 'CHANNEL2')
	ToggleChatColorNamesByClassGroup(true, 'CHANNEL3')

	ChangeChatColor('RAID_LEADER', 1, 127/255, 0)
	ChangeChatColor('RAID_WARNING', 1, 1/4, 1/4)
	ChangeChatColor('BATTLEGROUND_LEADER', 1, 127/255, 0)
	ChangeChatColor('PARTY_LEADER', 2/3, 2/3, 1)		
end


