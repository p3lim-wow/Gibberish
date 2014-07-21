local patterns = {
	'(https://%S+)',
	'(http://%S+)',
	'(www%.%S+)',
	'(%d+%.%d+%.%d+%.%d+:?%d*/?%S*)',
}

local numPatterns = #patterns

for _, event in next, {
	'CHAT_MSG_GUILD',
	'CHAT_MSG_PARTY',
	'CHAT_MSG_RAID',
	'CHAT_MSG_RAID_LEADER',
	'CHAT_MSG_CHANNEL',
	'CHAT_MSG_WHISPER',
	'CHAT_MSG_BN_WHISPER',
	'CHAT_MSG_SAY'
} do
	ChatFrame_AddMessageEventFilter(event, function(self, event, str, ...)
		for index = 1, numPatterns do
			local result, match = string.gsub(str, patterns[index], '|cff80c8fe|Hurl:%1|h[%1]|h|r')
			if(match > 0) then
				return false, result, ...
			end
		end
	end)
end

local orig = ItemRefTooltip.SetHyperlink
function ItemRefTooltip.SetHyperlink(self, link, ...)
	if(string.sub(link, 1, 3) == 'url') then
		local editbox = ChatEdit_GetLastActiveWindow()
		ChatEdit_ActivateChat(editbox)
		editbox:Insert(string.sub(link, 5))
		editbox:HighlightText()

		return
	end

	orig(self, link, ...)
end
