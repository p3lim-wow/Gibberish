local _, ns = ...
local Frame

local function AddMessage(body, outgoing)
	if(not outgoing) then
		if(not Frame) then
			Frame = FCF_OpenTemporaryWindow('WHISPER', 'GM')
			ChatFrame_RemoveAllMessageGroups(Frame)
			FCF_SelectDockFrame(SELECTED_CHAT_FRAME)

			ns.Skin(Frame:GetID())
		end

		if(SELECTED_CHAT_FRAME ~= Frame) then
			FCF_StartAlertFlash(Frame)
		end
	end

	local info = ChatTypeInfo.WHISPER
	Frame:AddMessage(body, info.r, info.g, info.b)
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
		if(name == CHAT_MSG_SYSTEM) then
			GibberishLastGM = nil
		else
			GibberishLastGM = name
			ChatEdit_SetLastTellTarget(name, 'WHISPER')
		end

		AddMessage(string.format(inMessage, name, name, message))
	elseif(event == 'CHAT_MSG_WHISPER_INFORM' and flag == 'GM') then
		AddMessage(string.format(outMessage, name, name, message), true)
	elseif(event == 'PLAYER_LOGIN' and GibberishLastGM) then
		AddMessage(string.format(GM_CHAT_LAST_SESSION, string.format(link, GibberishLastGM, GibberishLastGM)))
	end
end)

hooksecurefunc('FCF_Tab_OnClick', function(self, button)
	if(Frame and button == 'MiddleButton') then
		if(self:GetID() == Frame:GetID()) then
			GibberishLastGM = nil
			Frame = nil
		end
	end
end)

local function MessageFilter(self, _, _, _, _, _, _, flag)
	return self ~= Frame and flag == 'GM'
end

ChatFrame_AddMessageEventFilter('CHAT_MSG_WHISPER', MessageFilter)
ChatFrame_AddMessageEventFilter('CHAT_MSG_WHISPER_INFORM', MessageFilter)

UIParent:UnregisterEvent('CHAT_MSG_WHISPER')
TicketStatusFrame.Show = function() end
