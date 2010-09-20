local FONT = [=[Interface\AddOns\Gibberish\semplice.ttf]=]

for index = 1, 5 do
	local frame = _G['ChatFrame'..index]
	frame:SetFont(FONT, 8, 'OUTLINEMONOCHROME')
	frame:SetShadowOffset(0, 0)
	frame:SetClampRectInsets(0, 0, 0, 0)

	local editbox = _G['ChatFrame'..index..'EditBox']
	editbox:ClearAllPoints()
	editbox:SetPoint('BOTTOMRIGHT', 0, -20)
	editbox:SetPoint('TOPLEFT', frame, 'BOTTOMLEFT', 0, -6)
	editbox:SetFont(FONT, 8, 'OUTLINEMONOCHROME')
	editbox:SetShadowOffset(0, 0)
	editbox:SetAltArrowKeyMode(false)

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
end

DEFAULT_CHATFRAME_ALPHA = 0
ChatFrameMenuButton:SetAlpha(0)
ChatFrameMenuButton:EnableMouse(false)
FriendsMicroButton:Hide()

ChatTypeInfo.CHANNEL.sticky = 0
ChatTypeInfo.WHISPER.sticky = 0
ChatTypeInfo.BN_WHISPER.sticky = 0

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
