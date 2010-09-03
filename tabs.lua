--[[
	Copyright (c) 2007-2010 Trond A Ekseth
	Copyright (c) 2010-2010 Adrian L Lange

	Permission is hereby granted, free of charge, to any person
	obtaining a copy of this software and associated documentation
	files (the "Software"), to deal in the Software without
	restriction, including without limitation the rights to use,
	copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the
	Software is furnished to do so, subject to the following
	conditions:

	The above copyright notice and this permission notice shall be
	included in all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
	EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
	OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
	NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
	HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
	WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
	FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
	OTHER DEALINGS IN THE SOFTWARE.
--]]

-- This is just a very modified version of Fane by haste

local function UpdateColors(self)
	if(self:IsMouseOver()) then
		self:GetFontString():SetTextColor(0, 0.6, 1)
	elseif(self.alerting) then
		self:GetFontString():SetTextColor(1, 0, 0)
	elseif(self:GetID() == SELECTED_CHAT_FRAME:GetID()) then
		self:GetFontString():SetTextColor(1, 1, 1)
	else
		self:GetFontString():SetTextColor(0.5, 0.5, 0.5)
	end
end

local function Parse(self)
	UpdateColors(_G[self:GetName()..'Tab'])
end

for index = 1, 5 do
	local tab = _G['ChatFrame'..index..'Tab']
	tab.leftTexture:SetTexture(nil)
	tab.middleTexture:SetTexture(nil)
	tab.rightTexture:SetTexture(nil)

	tab.leftHighlightTexture:SetTexture(nil)
	tab.middleHighlightTexture:SetTexture(nil)
	tab.rightHighlightTexture:SetTexture(nil)

	tab.leftSelectedTexture:SetTexture(nil)
	tab.middleSelectedTexture:SetTexture(nil)
	tab.rightSelectedTexture:SetTexture(nil)

	tab.glow:SetTexture(nil)
	tab:SetAlpha(0)

	tab:HookScript('OnEnter', UpdateColors)
	tab:HookScript('OnLeave', UpdateColors)

	UpdateColors(tab)
end

CHAT_FRAME_TAB_SELECTED_NOMOUSE_ALPHA = 0
CHAT_FRAME_TAB_NORMAL_NOMOUSE_ALPHA = 0
CHAT_FRAME_TAB_NORMAL_MOUSEOVER_ALPHA = 0.7

hooksecurefunc('FCFTab_UpdateColors', UpdateColors)
hooksecurefunc('FCF_StartAlertFlash', Parse)
hooksecurefunc('FCF_FadeOutChatFrame', Parse)
