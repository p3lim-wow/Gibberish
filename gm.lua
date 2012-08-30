local __, Gibberish = ...

local frame, current

local getString = '|TInterface\\ChatFrame\\UI-ChatIcon-Blizz:14:22:-1:-2:32:16:4:26:0:16|t|cff0090ff|HplayerGM:%s|h%s|h|r: %s'
local informString = '|cffA1A1A1@|r|TInterface\\ChatFrame\\UI-ChatIcon-Blizz:14:22:-1:-2:32:16:4:26:0:16|t|cff0090ff|HplayerGM:%s|h%s|h|r: %s'
local sessionString = '|TInterface\\ChatFrame\\UI-ChatIcon-Blizz:14:22:-1:-2:32:16:4:26:0:16|t|cff0090ff|HplayerGM:%s|h%s|h|r'

local function CreateChat()
	local selected = SELECTED_CHAT_FRAME

	frame = FCF_OpenNewWindow('GM')

	ChatFrame_RemoveAllMessageGroups(frame)
	ChatFrame_RemoveAllChannels(frame)
	FCF_SelectDockFrame(selected)

	Gibberish.Skin(frame:GetID())
end

local Handler = CreateFrame('Frame')
Handler:RegisterEvent('CHAT_MSG_WHISPER')
Handler:RegisterEvent('CHAT_MSG_WHISPER_INFORM')
Handler:RegisterEvent('PLAYER_LOGOUT')
Handler:RegisterEvent('PLAYER_LOGIN')
Handler:SetScript('OnEvent', function(self, event, ...)
	local message, name, __, __, __, flag = ...
	if(event == 'CHAT_MSG_WHISPER' and flag == 'GM') then
		if(not frame) then
			CreateChat()
		end

		if(SELECTED_CHAT_FRAME ~= frame) then
			FCF_StartAlertFlash(frame)
		end

		current = name
		r2liymvyaxno = name

		local info = ChatTypeInfo.WHISPER
		local body = string.format(getString, name, name, message)

		frame:AddMessage(body, info.r, info.g, info.b)

		ChatEdit_SetLastTellTarget(name, 'WHISPER')
	elseif(event == 'CHAT_MSG_WHISPER_INFORM' and flag == 'GM') then
		local info = ChatTypeInfo.WHISPER_INFORM
		local body = string.format(informString, name, name, message)

		frame:AddMessage(body, info.r, info.g, info.b)
	elseif(event == 'PLAYER_LOGIN' and r2liymvyaxno) then
		CreateChat()

		if(SELECTED_CHAT_FRAME ~= frame) then
			FCF_StartAlertFlash(frame)
		end

		local info = ChatTypeInfo.WHISPER
		frame:AddMessage(string.format(GM_CHAT_LAST_SESSION, string.format(sessionString, r2liymvyaxno, r2liymvyaxno)), info.r, info.g, info.b)
	elseif(event == 'PLAYER_LOGOUT' and frame) then
		if(frame) then
			FCF_Close(frame)
		end
	end
end)

hooksecurefunc('FCF_Tab_OnClick', function(self, button)
	if(button == 'MiddleButton') then
		local chatFrame = _G['ChatFrame' .. self:GetID()]
		if(chatFrame == frame) then
			r2liymvyaxno = nil
			frame = nil
		end
	end
end)

UIParent:UnregisterEvent('CHAT_MSG_WHISPER')
TicketStatusFrame.Show = function() end
