local addon = CreateFrame('Frame')
addon:RegisterEvent('ADDON_LOADED')
addon:SetScript('OnEvent', function(self, event, name)
	if(name ~= 'Blizzard_CombatLog') then return end

	for index = 1, 5 do
		local frame = _G['ChatFrame'..index]
		frame:SetFont([=[Interface\AddOns\Gibberish\vera.ttf]=], 12)
		frame:SetClampRectInsets(0, 0, 0, 0)

		local buttons = _G['ChatFrame'..index..'ButtonFrame']
		buttons.Show = buttons.Hide
		buttons:Hide()

		local editbox = _G['ChatFrame'..index..'EditBox']
		editbox:ClearAllPoints()
		editbox:SetPoint('BOTTOMLEFT', frame, 'TOPLEFT', -5, 20)
		editbox:SetPoint('BOTTOMRIGHT', frame, 'TOPRIGHT', 5, 20)
		editbox:SetFont([=[Interface\AddOns\Gibberish\vera.ttf]=], 12)
		editbox:SetAltArrowKeyMode(false)

		_G['ChatFrame'..index..'EditBoxLeft']:SetTexture(nil)
		_G['ChatFrame'..index..'EditBoxMid']:SetTexture(nil)
		_G['ChatFrame'..index..'EditBoxRight']:SetTexture(nil)
		_G['ChatFrame'..index..'EditBoxFocusLeft']:SetTexture(nil)
		_G['ChatFrame'..index..'EditBoxFocusMid']:SetTexture(nil)
		_G['ChatFrame'..index..'EditBoxFocusRight']:SetTexture(nil)

		SetChatWindowLocked(index)
		SetChatWindowAlpha(index, 0)
		ChatFrame_RemoveAllMessageGroups(frame)
		ChatFrame_RemoveAllChannels(frame)

		if(index == 1) then
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
			ChatFrame_AddMessageGroup(frame, 'ACHIEVEMENT')
			ChatFrame_AddMessageGroup(frame, 'GUILD_ACHIEVEMENT')
		elseif(index == 2) then
			FCF_UnDockFrame(frame)
			FCF_Close(frame)
		elseif(index == 3) then
			FCF_DockFrame(frame, 2)
			FCF_SetWindowName(frame, 'Whisper')
			ChatFrame_AddMessageGroup(frame, 'BN_WHISPER')
			ChatFrame_AddMessageGroup(frame, 'WHISPER')
			ChatFrame_AddMessageGroup(frame, 'IGNORED')
			SetChatWindowShown(index, true)
		elseif(index == 4) then
			FCF_DockFrame(frame, 3)
			FCF_SetWindowName(frame, 'Loot')
			ChatFrame_AddMessageGroup(frame, 'LOOT')
			SetChatWindowShown(index, true)
		elseif(index == 5) then
			FCF_DockFrame(frame, 4)
			FCF_SetWindowName(frame, 'Channel')
			ChatFrame_AddChannel(frame, 'General')
			ChatFrame_AddChannel(frame, 'Trade')
			ChatFrame_AddChannel(frame, 'LookingForGroup')
			SetChatWindowShown(index, true)
		end

		SetChatWindowLocked(index, 1)
	end

	CHAT_FRAME_TAB_NORMAL_NOMOUSE_ALPHA = 0
	CHAT_FRAME_TAB_SELECTED_NOMOUSE_ALPHA = 0
	DEFAULT_CHATFRAME_ALPHA = 0

	ChatFrameMenuButton:Hide()
	ChatFrameMenuButton.Show = ChatFrameMenuButton.Hide
	FriendsMicroButton:Hide()

	ChatTypeInfo.WHISPER.sticky = 0
	ChatTypeInfo.BN_WHISPER.sticky = 0

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
end)

function FloatingChatFrame_OnMouseScroll(self, direction)
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
