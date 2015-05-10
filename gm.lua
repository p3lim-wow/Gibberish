local _, ns = ...
local frame

local function CreateWindow()
	frame = FCF_OpenTemporaryWindow('WHISPER', 'GM')
	ChatFrame_RemoveAllMessageGroups(frame)
	FCF_SelectDockFrame(SELECTED_CHAT_FRAME)

	ns.Skin(frame:GetID())
end

local link = [[|TInterface\ChatFrame\UI-ChatIcon-Blizz:14:22:-1:-2:32:16:4:26:0:16|t |cff0090ff|HplayerGM:%s|h%s|h|r]]

local inMessage = link .. ': %s'
local outMessage = '|cffa1a1a1@|r' .. inMessage

local Handler = CreateFrame('Frame')
Handler:RegisterEvent('CHAT_MSG_WHISPER')
Handler:RegisterEvent('CHAT_MSG_WHISPER_INFORM')
Handler:RegisterEvent('PLAYER_LOGIN')
Handler:SetScript('OnEvent', function(self, event, ...)
	local message, name, _, _, _, flag = ...
	if(event == 'CHAT_MSG_WHISPER' and flag == 'GM') then
		if(not frame) then
			CreateWindow()
		end

		if(SELECTED_CHAT_FRAME ~= frame) then
			FCF_StartAlertFlash(frame)
		end

		GibberishLastGM = name

		local info = ChatTypeInfo.WHISPER
		local body = string.format(inMessage, name, name, message)
		frame:AddMessage(body, info.r, info.g, info.b)

		ChatEdit_SetLastTellTarget(name, 'WHISPER')
	elseif(event == 'CHAT_MSG_WHISPER_INFORM' and flag == 'GM') then
		local info = ChatTypeInfo.WHISPER
		local body = string.format(outMessage, name, name, message)
		frame:AddMessage(body, info.r, info.g, info.b)
	elseif(event == 'PLAYER_LOGIN' and GibberishLastGM) then
		CreateWindow()

		if(SELECTED_CHAT_FRAME ~= frame) then
			FCF_StartAlertFlash(frame)
		end

		local info = ChatTypeInfo.WHISPER
		local body = string.format(GM_CHAT_LAST_SESSION, string.format(link, GibberishLastGM, GibberishLastGM))
		frame:AddMessage(body, info.r, info.g, info.b)
	end
end)

hooksecurefunc('FCF_Tab_OnClick', function(self, button)
	if(frame and button == 'MiddleButton') then
		if(self:GetID() == frame:GetID()) then
			GibberishLastGM = nil
			frame = nil
		end
	end
end)

local function MessageFilter(self, _, _, _, _, _, _, flag)
	return self ~= frame and flag == 'GM'
end

ChatFrame_AddMessageEventFilter('CHAT_MSG_WHISPER', MessageFilter)
ChatFrame_AddMessageEventFilter('CHAT_MSG_WHISPER_INFORM', MessageFilter)

UIParent:UnregisterEvent('CHAT_MSG_WHISPER')
TicketStatusFrame.Show = function() end
