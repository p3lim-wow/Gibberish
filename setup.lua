local _, ns = ...

local FONT = [[Interface\AddOns\Gibberish\semplice.ttf]]

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

local function UpdateTab(self)
	if(self:GetObjectType() ~= 'Button') then
		self = _G[self:GetName() .. 'Tab']
	end

	local tab = self.fontString
	if(tab) then
		if(self:IsMouseOver()) then
			tab:SetTextColor(0, 0.6, 1)
		elseif(self.alerting) then
			tab:SetTextColor(1, 0, 0)
		elseif(self:GetID() == SELECTED_CHAT_FRAME:GetID()) then
			tab:SetTextColor(1, 1, 1)
		else
			tab:SetTextColor(0.5, 0.5, 0.5)
		end
	end
end

function ns.Skin(index)
	local frame = _G['ChatFrame' .. index]
	frame:SetFont(FONT, 8, 'OUTLINEMONOCHROME')
	frame:SetShadowOffset(0, 0)
	frame:SetClampRectInsets(0, 0, 0, 0)
	frame:SetSpacing(1.4)
	frame:HookScript('OnMouseWheel', Scroll)
	frame.buttonFrame:Hide()

	local editbox = _G['ChatFrame' .. index .. 'EditBox']
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

	_G['ChatFrame' .. index .. 'EditBoxLeft']:SetTexture(nil)
	_G['ChatFrame' .. index .. 'EditBoxMid']:SetTexture(nil)
	_G['ChatFrame' .. index .. 'EditBoxRight']:SetTexture(nil)

	local tab = _G['ChatFrame' .. index .. 'Tab']
	tab.fontString = tab:GetFontString()
	tab.fontString:SetFont(FONT, 8, 'OUTLINEMONOCHROME')
	tab.fontString:SetShadowOffset(0, 0)

	tab.leftTexture:SetTexture(nil)
	tab.middleTexture:SetTexture(nil)
	tab.rightTexture:SetTexture(nil)

	tab.leftHighlightTexture:SetTexture(nil)
	tab.middleHighlightTexture:SetTexture(nil)
	tab.rightHighlightTexture:SetTexture(nil)

	tab.leftSelectedTexture:SetTexture(nil)
	tab.middleSelectedTexture:SetTexture(nil)
	tab.rightSelectedTexture:SetTexture(nil)

	if(tab.conversationIcon) then
		tab.conversationIcon:SetTexture(nil)
	end

	tab.glow:SetTexture(nil)
	tab:SetAlpha(0)

	tab:HookScript('OnEnter', UpdateTab)
	tab:HookScript('OnLeave', UpdateTab)
	tab:SetScript('OnDragStart', nil)

	UpdateTab(tab)

	ns.History(editbox)
end

local function CreateChatFrame(name, ...)
	local frame = name and FCF_OpenNewWindow(name) or ChatFrame1
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
		DEFAULT_CHATFRAME_ALPHA = 0
		CHAT_FRAME_TAB_SELECTED_NOMOUSE_ALPHA = 0
		CHAT_FRAME_TAB_NORMAL_NOMOUSE_ALPHA = 0
		CHAT_FRAME_TAB_NORMAL_MOUSEOVER_ALPHA = 0.7

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

			local parent = CreateChatFrame(nil, 'SAY', 'EMOTE', 'GUILD', 'OFFICER', 'PARTY', 'PARTY_LEADER', 'RAID', 'RAID_LEADER', 'RAID_WARNING', 'BATTLEGROUND', 'BATTLEGROUND_LEADER', 'SYSTEM', 'MONSTER_WHISPER', 'MONSTER_BOSS_WHISPER', 'ACHIEVEMENT', 'GUILD_ACHIEVEMENT', 'INSTANCE_CHAT', 'INSTANCE_CHAT_LEADER')
			CreateChatFrame('Combat')
			CreateChatFrame('Whisper', 'BN_WHISPER', 'BN_CONVERSATION', 'WHISPER', 'IGNORED')
			CreateChatFrame('Loot', 'LOOT', 'COMBAT_FACTION_CHANGE', 'CURRENCY', 'MONEY')

			local frame = CreateChatFrame('Channels')
			ChatFrame_AddChannel(frame, 'General')
			ChatFrame_AddChannel(frame, 'Trade')

			parent:SetUserPlaced(true)
			parent:ClearAllPoints()
			parent:SetPoint('BOTTOMLEFT', UIParent, 35, 50)
			parent:SetSize(400, 100)

			FCF_SavePositionAndDimensions(parent)
			FCF_SetWindowAlpha(parent, 0)

			ChangeChatColor('OFFICER', 3/4, 1/2, 1/2)
			ChangeChatColor('RAID', 0, 1, 4/5)
			ChangeChatColor('RAID_LEADER', 0, 1, 4/5)
			ChangeChatColor('RAID_WARNING', 1, 1/4, 1/4)
			ChangeChatColor('BATTLEGROUND_LEADER', 1, 1/2, 0)
			ChangeChatColor('PARTY_LEADER', 2/3, 2/3, 1)
			ChangeChatColor('BN_WHISPER', 1, 1/2, 1)
			ChangeChatColor('BN_WHISPER_INFORM', 1, 1/2, 1)
			ChangeChatColor('INSTANCE_CHAT_LEADER', 1, 1/2, 0)

			FCF_SelectDockFrame(parent)
			FCF_Close(ChatFrame2)
		end

		for index = 1, 5 do
			if(index ~= 2) then
				ns.Skin(index)

				_G['ChatFrame' .. index .. 'Tab']:RegisterForClicks('LeftButtonUp', 'RightButtonUp')
			end
		end

		ChatFrame2:SetClampedToScreen(false)
		ChatFrameMenuButton:SetAlpha(0)
		ChatFrameMenuButton:EnableMouse(false)
		FriendsMicroButton:Hide()

		ChatTypeInfo.CHANNEL.sticky = 0
		ChatTypeInfo.WHISPER.sticky = 0
		ChatTypeInfo.BN_WHISPER.sticky = 0
		ChatTypeInfo.BN_CONVERSATION.sticky = 0
		ChatTypeInfo.GUILD.flashTabOnGeneral = true
		ChatTypeInfo.OFFICER.flashTabOnGeneral = true

		hooksecurefunc('FCFTab_UpdateColors', UpdateTab)
		hooksecurefunc('FCF_StartAlertFlash', UpdateTab)
		hooksecurefunc('FCF_FadeOutChatFrame', UpdateTab)
	elseif(event == 'UPDATE_CHAT_COLOR_NAME_BY_CLASS') then
		local type, enabled = ...
		if(not enabled) then
			SetChatColorNameByClass(type, true)
		end
	else
		PlaySound('TellMessage', 'master')
	end
end)
