local _, ns = ...
local frame

local function CreateWindow()
	frame = FCF_OpenTemporaryWindow('WHISPER', 'GM')
	ChatFrame_RemoveAllMessageGroups(frame)
	FCF_SelectDockFrame(SELECTED_CHAT_FRAME)

	ns.Skin(frame:GetID())
	PlaySound('TellMessage', 'Master')
end

local function AddMessage(body, outgoing)
	if(not outgoing) then
		if(not frame) then
			CreateWindow()
		end

		if(SELECTED_CHAT_FRAME ~= frame) then
			FCF_StartAlertFlash(frame)
		end
	end

	local info = ChatTypeInfo.WHISPER
	frame:AddMessage(body, info.r, info.g, info.b)
end

local link = [[|TInterface\ChatFrame\UI-ChatIcon-Blizz:14:22:-1:-2:32:16:4:26:0:16|t |cff0090ff|HplayerGM:%s|h%s|h|r]]

local inMessage = link .. ': %s'
local outMessage = '|cffa1a1a1@|r' .. inMessage

local Handler = CreateFrame('Frame')
Handler:RegisterEvent('CHAT_MSG_WHISPER')
Handler:RegisterEvent('CHAT_MSG_WHISPER_INFORM')
Handler:RegisterEvent('UPDATE_WEB_TICKET')
Handler:RegisterEvent('PLAYER_LOGIN')
Handler:SetScript('OnEvent', function(self, event, ...)
	local message, name, _, _, _, flag = ...
	if(event == 'CHAT_MSG_WHISPER' and flag == 'GM') then
		AddMessage(string.format(inMessage, name, name, message))
		GibberishLastGM = name
		ChatEdit_SetLastTellTarget(name, 'WHISPER')
	elseif(event == 'CHAT_MSG_WHISPER_INFORM' and flag == 'GM') then
		AddMessage(string.format(outMessage, name, name, message), true)
	elseif(event == 'UPDATE_WEB_TICKET') then
		local hasTicket, numTickets, ticketStatus, caseIndex = ...
		if(ticketStatus == LE_TICKET_STATUS_NMI) then
			AddMessage(TICKET_STATUS_NMI)
		elseif(frame and (not ticketStatus or ticketStatus >= 2)) then
			AddMessage('Your ticket has been closed.')
			GibberishLastGM = nil
		end
	elseif(event == 'PLAYER_LOGIN' and GibberishLastGM) then
		AddMessage(string.format(GM_CHAT_LAST_SESSION, string.format(link, GibberishLastGM, GibberishLastGM)))
	end
end)

hooksecurefunc('FCF_Tab_OnClick', function(self, button)
	if(frame and button == 'MiddleButton') then
		if(self:GetID() == frame:GetID()) then
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
