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

	local Tab = self.fontString
	if(Tab) then
		if(self:IsMouseOver()) then
			Tab:SetTextColor(0, 0.6, 1)
		elseif(self.alerting) then
			Tab:SetTextColor(1, 0, 0)
		elseif(self:GetID() == SELECTED_CHAT_FRAME:GetID()) then
			Tab:SetTextColor(1, 1, 1)
		else
			Tab:SetTextColor(0.5, 0.5, 0.5)
		end
	end
end

function ns.Skin(index)
	local Frame = _G['ChatFrame' .. index]
	Frame:SetFont(FONT, 8, 'OUTLINEMONOCHROME')
	Frame:SetShadowOffset(0, 0)
	Frame:SetClampRectInsets(0, 0, 0, 0)
	Frame:SetSpacing(1.4)
	Frame:HookScript('OnMouseWheel', Scroll)
	Frame.buttonFrame:Hide()

	local EditBox = _G['ChatFrame' .. index .. 'EditBox']
	EditBox:ClearAllPoints()
	EditBox:SetPoint('TOPRIGHT', Frame, 'BOTTOMRIGHT', 0, 5)
	EditBox:SetPoint('TOPLEFT', Frame, 'BOTTOMLEFT', 0, 5)
	EditBox:SetFont(FONT, 8, 'OUTLINEMONOCHROME')
	EditBox:SetShadowOffset(0, 0)

	EditBox.focusLeft:SetTexture(nil)
	EditBox.focusMid:SetTexture(nil)
	EditBox.focusRight:SetTexture(nil)

	EditBox.header:ClearAllPoints()
	EditBox.header:SetPoint('LEFT')
	EditBox.header:SetFont(FONT, 8, 'OUTLINEMONOCHROME')
	EditBox.header:SetShadowOffset(0, 0)

	local orig = EditBox.SetTextInsets
	EditBox.SetTextInsets = function(self)
		orig(self, self.header:GetWidth(), 0, 0, 0)
	end

	_G['ChatFrame' .. index .. 'EditBoxLeft']:SetTexture(nil)
	_G['ChatFrame' .. index .. 'EditBoxMid']:SetTexture(nil)
	_G['ChatFrame' .. index .. 'EditBoxRight']:SetTexture(nil)

	local Tab = _G['ChatFrame' .. index .. 'Tab']
	Tab.fontString = Tab:GetFontString()
	Tab.fontString:SetFont(FONT, 8, 'OUTLINEMONOCHROME')
	Tab.fontString:SetShadowOffset(0, 0)

	Tab.leftTexture:SetTexture(nil)
	Tab.middleTexture:SetTexture(nil)
	Tab.rightTexture:SetTexture(nil)

	Tab.leftHighlightTexture:SetTexture(nil)
	Tab.middleHighlightTexture:SetTexture(nil)
	Tab.rightHighlightTexture:SetTexture(nil)

	Tab.leftSelectedTexture:SetTexture(nil)
	Tab.middleSelectedTexture:SetTexture(nil)
	Tab.rightSelectedTexture:SetTexture(nil)

	if(Tab.conversationIcon) then
		Tab.conversationIcon:SetTexture(nil)
	end

	Tab.glow:SetTexture(nil)
	Tab:SetAlpha(0)

	Tab:HookScript('OnEnter', UpdateTab)
	Tab:HookScript('OnLeave', UpdateTab)
	Tab:SetScript('OnDragStart', nil)

	UpdateTab(Tab)

	ns.History(EditBox)
end

local function CreateChatFrame(name, ...)
	local Frame = name and FCF_OpenNewWindow(name) or ChatFrame1
	ChatFrame_RemoveAllMessageGroups(Frame)
	ChatFrame_RemoveAllChannels(Frame)

	if(...) then
		for index = 1, select('#', ...) do
			ChatFrame_AddMessageGroup(Frame, select(index, ...))
		end
	end

	return Frame
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
			CreateChatFrame('Whisper', 'BN_WHISPER', 'WHISPER', 'IGNORED')
			CreateChatFrame('Loot', 'LOOT', 'COMBAT_FACTION_CHANGE', 'CURRENCY', 'MONEY')

			local Frame = CreateChatFrame('Channels')
			ChatFrame_AddChannel(Frame, 'General')
			ChatFrame_AddChannel(Frame, 'Trade')

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
