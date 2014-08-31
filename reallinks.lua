local queriedItems = {}
local staticColors = {
	achievement = 'ffffff00',
	battlepet = 'ffffd200',
	enchant = 'ffffd000',
	glyph = 'ff66bbff',
	instancelock = 'ffff8000',
	levelup = 'ffff4e00',
	spell = 'ff71d5ff',
	talent = 'ff4e96f7',
	quest = 'ffd100'
}

staticColors.trade = staticColors.enchant
staticColors.journal = staticColors.glyph
staticColors.battlePetAbil = staticColors.talent

--[[
? garrfollowerability
? garrfollower
? garrmission
? journal

currency - has no actual color api
--]]

local gsub = string.gsub
local match = string.match
local split = string.split
local sub = string.sub

local function GetLinkColor(linkString, ...)
	local type, arg1, arg2, arg3 = split(':', linkString)
	if(type == 'item') then
		local _, _, quality = GetItemInfo(arg1)
		if(quality) then
			local _, _, _, hex = GetItemQualityColor(quality)
			return hex
		elseif(...) then
			table.insert(queriedItems, {
				linkString = linkString,
				args = {...}
			})

			return false
		end
	elseif(type == 'battlepet' and arg3 ~= -1) then
		local _, _, _, hex = GetItemQualityColor(arg3)
		return hex
	elseif(type == 'quest' and arg2) then
		return sub(ConvertRGBtoColorString(GetQuestDifficultyColor(arg2)), 3, 10)
	else
		return staticColors[type]
	end
end

local function AddLinkColors(self, event, message, ...)
	local linkString = match(message, '|H(.-)|h')
	if(linkString) then
		local color = GetLinkColor(linkString, self, event, message, ...)
		if(color) then
			return false, gsub(message, '(|H.-|h.-|h)', '|c' .. color .. '%1|r'), ...
		end
	end

	return false
end

ChatFrame_AddMessageEventFilter('CHAT_MSG_BN_WHISPER', AddLinkColors)
ChatFrame_AddMessageEventFilter('CHAT_MSG_BN_WHISPER_INFORM', AddLinkColors)

local function ParseMessage(color, frame, event, message, ...)
	if(color) then
		message = gsub(message, '(|H.-|h.-|h)', '|c' .. color .. '%1|r')
	end

	ChatFrame_MessageEventHandler(frame, event, message, ...)
end

local Handler = CreateFrame('Frame')
Handler:RegisterEvent('GET_ITEM_INFO_RECEIVED')
Handler:SetScript('OnEvent', function()
	if(#queriedItems > 0) then
		for index, data in next, queriedItems do
			ParseMessage(GetLinkColor(data.linkString), unpack(data.args))

			queriedItems[index] = nil
		end
	end
end)
