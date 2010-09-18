local addon = CreateFrame('Frame')
addon:RegisterEvent('ADDON_LOADED')
addon:SetScript('OnEvent', function(self, event, name)
	if(name ~= 'Blizzard_CombatLog') then return end

	for index = 1, 5 do
		local frame = _G['ChatFrame'..index]
		frame:SetFont([=[Interface\AddOns\Gibberish\semplice.ttf]=], 8, 'OUTLINEMONOCHROME')
		frame:SetShadowOffset(0, 0)
		frame:SetClampRectInsets(0, 0, 0, 0)

		local buttons = _G['ChatFrame'..index..'ButtonFrame']
		buttons.Show = buttons.Hide
		buttons:Hide()

		local editbox = _G['ChatFrame'..index..'EditBox']
		editbox:ClearAllPoints()
		editbox:SetPoint('BOTTOMLEFT', frame, 'TOPLEFT', -5, 20)
		editbox:SetPoint('BOTTOMRIGHT', frame, 'TOPRIGHT', 5, 20)
		editbox:SetFont([=[Interface\AddOns\Gibberish\semplice.ttf]=], 8, 'OUTLINEMONOCHROME')
		editbox:SetShadowOffset(0, 0)
		editbox:SetAltArrowKeyMode(false)

		_G['ChatFrame'..index..'EditBoxLeft']:SetTexture(nil)
		_G['ChatFrame'..index..'EditBoxMid']:SetTexture(nil)
		_G['ChatFrame'..index..'EditBoxRight']:SetTexture(nil)
		_G['ChatFrame'..index..'EditBoxFocusLeft']:SetTexture(nil)
		_G['ChatFrame'..index..'EditBoxFocusMid']:SetTexture(nil)
		_G['ChatFrame'..index..'EditBoxFocusRight']:SetTexture(nil)
	end

	DEFAULT_CHATFRAME_ALPHA = 0
	ChatFrameMenuButton:Hide()
	ChatFrameMenuButton.Show = ChatFrameMenuButton.Hide
	FriendsMicroButton:Hide()

	ChatTypeInfo.CHANNEL.sticky = 0
	ChatTypeInfo.WHISPER.sticky = 0
	ChatTypeInfo.BN_WHISPER.sticky = 0
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
