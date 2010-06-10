--[[
	Copyright (c) 2007-2008 Trond A Ekseth
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

local function OnEnter(self)
	self:GetFontString():SetTextColor(0, 0.6, 1)
end

local function OnLeave(self)
	if(self.flashing) then
		self:GetFontString():SetTextColor(1, 0, 0)
	else
		self:GetFontString():SetTextColor(1, 1, 1)
	end
end

DEFAULT_CHATFRAME_ALPHA = 0
CHAT_TELL_ALERT_TIME = 0

hooksecurefunc('FCF_SelectDockFrame', function(self)
	local tab = _G[self:GetName()..'Tab']
	if(tab.flashing) then
		tab:GetFontString():SetTextColor(1, 1, 1)
		tab.flashing = nil
	end
end)

FCF_FlashTab = function(self)
	if(self ~= SELECTED_DOCK_FRAME) then
		local tab = _G[self:GetName()..'Tab']
		tab:GetFontString():SetTextColor(1, 0, 0)
		tab.flashing = true

		UIFrameFadeIn(tab, 0)
	end
end

local addon = CreateFrame('Frame')
addon:RegisterEvent('PLAYER_LOGIN')
addon:SetScript('OnEvent', function()
	for k, v in pairs(DOCKED_CHAT_FRAMES) do
		_G[v:GetName()..'TabLeft']:Hide()
		_G[v:GetName()..'TabMiddle']:Hide()
		_G[v:GetName()..'TabRight']:Hide()

		local tab = _G[v:GetName()..'Tab']
		tab:GetHighlightTexture():SetTexture(nil)
		tab:SetScript('OnEnter', OnEnter)
		tab:SetScript('OnLeave', OnLeave)

		local font, size = GameFontNormalSmall:GetFont()
		tab:GetFontString():SetFont(font, size, 'OUTLINE')
		tab:GetFontString():SetTextColor(1, 1, 1)
	end
end)
