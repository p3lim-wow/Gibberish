local _, ns = ...

local FONT = [=[Interface\AddOns\Gibberish\semplice.ttf]=]

local function Scroll(self, direction)
	if(direction > 0) then
		if(IsShiftKeyDown()) then
			self:ScrollToTop()
		elseif(IsControlKeyDown()) then
			self:PageUp()
		end
	elseif(direction < 0) then
		if(IsShiftKeyDown()) then
			self:ScrollToBottom()
		elseif(IsControlKeyDown()) then
			self:PageDown()
		end
	end
end

function ns.Skin(index)
	local frame = _G['ChatFrame'..index]
	frame:SetFont(FONT, 8, 'OUTLINEMONOCHROME')
	frame:SetShadowOffset(0, 0)
	frame:SetClampRectInsets(0, 0, 0, 0)
	frame:SetSpacing(1.4)
	frame:HookScript('OnMouseWheel', Scroll)

	local editbox = _G['ChatFrame'..index..'EditBox']
	editbox:ClearAllPoints()
	editbox:SetPoint('TOPRIGHT', frame, 'BOTTOMRIGHT', 0, 5)
	editbox:SetPoint('TOPLEFT', frame, 'BOTTOMLEFT', 0, 5)
	editbox:SetFont(FONT, 8, 'OUTLINEMONOCHROME')
	editbox:SetShadowOffset(0, 0)

	editbox.focusLeft:SetTexture(nil)
	editbox.focusMid:SetTexture(nil)
	editbox.focusRight:SetTexture(nil)

	editbox.header:ClearAllPoints()
	editbox.header:SetPoint('LEFT')
	editbox.header:SetFont(FONT, 8, 'OUTLINEMONOCHROME')
	editbox.header:SetShadowOffset(0, 0)

	local orig = editbox.SetTextInsets
	editbox.SetTextInsets = function(self)
		orig(self, self.header:GetWidth(), 0, 0, 0)
	end

	_G['ChatFrame'..index..'ButtonFrame']:Hide()
	_G['ChatFrame'..index..'EditBoxLeft']:SetTexture(nil)
	_G['ChatFrame'..index..'EditBoxMid']:SetTexture(nil)
	_G['ChatFrame'..index..'EditBoxRight']:SetTexture(nil)

	_G['ChatFrame'..index..'Tab']:SetScript('OnDragStart', nil)

	ns.History(editbox)
end

local function CreateChatFrame(index, name, ...)
	local frame
	if(index == 1) then
		frame = ChatFrame1
	else
		frame = FCF_OpenNewWindow(name)
	end

	ChatFrame_RemoveAllMessageGroups(frame)
	ChatFrame_RemoveAllChannels(frame)

	if(...) then
		for index = 1, select('#', ...) do
			ChatFrame_AddMessageGroup(frame, select(index, ...))
		end
	end

	return frame
end

local Handler = CreateFrame('Frame')
Handler:RegisterEvent('PLAYER_LOGIN')
Handler:RegisterEvent('CHAT_MSG_WHISPER')
Handler:RegisterEvent('CHAT_MSG_BN_WHISPER')
Handler:RegisterEvent('CHAT_MSG_BN_CONVERSATION')
Handler:RegisterEvent('UPDATE_CHAT_COLOR_NAME_BY_CLASS')
Handler:SetScript('OnEvent', function(self, event, ...)
	if(event == 'PLAYER_LOGIN') then
		for index = 1, 4 do
			ns.Skin(index)

			_G['ChatFrame'..index..'Tab']:RegisterForClicks('LeftButtonUp', 'RightButtonUp')
		end

		DEFAULT_CHATFRAME_ALPHA = 0
		ChatFrameMenuButton:SetAlpha(0)
		ChatFrameMenuButton:EnableMouse(false)
		FriendsMicroButton:Hide()

		ChatTypeInfo.CHANNEL.sticky = 0
		ChatTypeInfo.WHISPER.sticky = 0
		ChatTypeInfo.BN_WHISPER.sticky = 0
		ChatTypeInfo.BN_CONVERSATION.sticky = 0
		ChatTypeInfo.GUILD.flashTabOnGeneral = true
		ChatTypeInfo.OFFICER.flashTabOnGeneral = true

		if(not GibberishDB) then
			GibberishDB = true

			SetCVar('profanityFilter', 0)
			SetCVar('spamFilter', 0)
			SetCVar('removeChatDelay', 1)
			SetCVar('guildMemberNotify', 1)
			SetCVar('chatMouseScroll', 1)
			SetCVar('chatStyle', 'classic')
			SetCVar('showTimestamps', 'none')
			SetCVar('whisperMode', 'inline')
			SetCVar('bnWhisperMode', 'inline')
			SetCVar('conversationMode', 'inline')

			for index = 2, NUM_CHAT_WINDOWS do
				FCF_Close(_G['ChatFrame' .. index])
			end

			CreateChatFrame(1, 'General', 'SAY', 'EMOTE', 'GUILD', 'OFFICER', 'PARTY', 'PARTY_LEADER', 'RAID', 'RAID_LEADER', 'RAID_WARNING', 'BATTLEGROUND', 'BATTLEGROUND_LEADER', 'SYSTEM', 'MONSTER_WHISPER', 'MONSTER_BOSS_WHISPER', 'ACHIEVEMENT', 'GUILD_ACHIEVEMENT', 'INSTANCE_CHAT', 'INSTANCE_CHAT_LEADER')
			CreateChatFrame(2, 'Whisper', 'BN_WHISPER', 'BN_CONVERSATION', 'WHISPER', 'IGNORED')
			CreateChatFrame(3, 'Loot', 'LOOT', 'COMBAT_FACTION_CHANGE')

			local frame = CreateChatFrame(4, 'Channels')
			ChatFrame_AddChannel(frame, 'General')
			ChatFrame_AddChannel(frame, 'Trade')

			ChatFrame1:SetUserPlaced(true)
			ChatFrame1:ClearAllPoints()
			ChatFrame1:SetPoint('BOTTOMLEFT', UIParent, 35, 50)
			ChatFrame1:SetSize(400, 100)
			FCF_SavePositionAndDimensions(ChatFrame1)
			FCF_SetWindowAlpha(ChatFrame1, 0)

			ChangeChatColor('OFFICER', 3/4, 1/2, 1/2)
			ChangeChatColor('RAID', 0, 1, 4/5)
			ChangeChatColor('RAID_LEADER', 0, 1, 4/5)
			ChangeChatColor('RAID_WARNING', 1, 1/4, 1/4)
			ChangeChatColor('BATTLEGROUND_LEADER', 1, 1/2, 0)
			ChangeChatColor('PARTY_LEADER', 2/3, 2/3, 1)
			ChangeChatColor('BN_WHISPER', 1, 1/2, 1)
			ChangeChatColor('BN_WHISPER_INFORM', 1, 1/2, 1)
			ChangeChatColor('INSTANCE_CHAT_LEADER', 1, 1/2, 0)

			FCF_SelectDockFrame(ChatFrame1)
		end
	elseif(event == 'UPDATE_CHAT_COLOR_NAME_BY_CLASS') then
		local type, enabled = ...
		if(not enabled) then
			SetChatColorNameByClass(type, true)
		end
	else
		PlaySound('TellMessage', 'master')
	end
end)

function CombatLog_LoadUI() end
