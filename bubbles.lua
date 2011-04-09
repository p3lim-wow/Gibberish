local FONT = [=[Interface\AddOns\Cassone\semplice.ttf]=]
local TEXTURE = [=[Interface\ChatFrame\ChatFrameBackground]=]
local BACKDROP = {bgFile = TEXTURE, edgeFile = TEXTURE, edgeSize = 1}

local function SkinBubble(self, text)
	self:ClearAllPoints()
	self:SetPoint('TOPLEFT', text, -10, 10)
	self:SetPoint('BOTTOMRIGHT', text, 10, -10)
	self:SetBackdrop(BACKDROP)
	self:SetBackdropColor(0, 0, 0, 0.5)
	self:SetBackdropBorderColor(0, 0, 0)

	text:SetFont(FONT, 8, 'MONOCHROMEOUTLINE')
	text:SetJustifyH('LEFT')

	for index = 1, select('#', self:GetRegions()) do
		local region = select(index, self:GetRegions())
		if(region:GetObjectType() == 'Texture') then
			region:SetTexture(nil)
		end
	end
end

local function ParseChildren(string, ...)
	for index = 1, select('#', ...) do
		local object = select(index, ...)
		for key = 1, select('#', object:GetRegions()) do
			local region = select(key, object:GetRegions())
			if(region:GetObjectType() == 'FontString' and region:GetText() == string) then
				SkinBubble(object, region)
			end
		end
	end
end


local addon = CreateFrame('Frame')
addon:SetScript('OnEvent', function(self, event, ...)
	self.string = ...
	self:Show()
end)

addon:SetScript('OnUpdate', function(self)
	if(WorldFrame:GetNumChildren() ~= numChildren) then
		numChildren = WorldFrame:GetNumChildren()
		ParseChildren(self.string, WorldFrame:GetChildren())
		return self:Hide()
	end
end)

for event in pairs({
	CHAT_MSG_SAY = true,
	CHAT_MSG_YELL = true,
	CHAT_MSG_MONSTER_SAY = true,
	CHAT_MSG_MONSTER_YELL = true,
}) do
	addon:RegisterEvent(event)
end
