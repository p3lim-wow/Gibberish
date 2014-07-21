local _, ns = ...

local function Navigate(self, key)
	if(key ~= 'UP' and key ~= 'DOWN') then return end

	local history = self.history
	if(#history == 0) then return end

	local total = #history
	local index = (self.index or (total + 1)) + (key == 'UP' and -1 or 1)
	if(index < 1) then
		index = total
	elseif(index > total) then
		index = 1
	end

	self.index = index
	self:SetText(history[index])
end

local function AddLine(self, line)
	if(not line or line == '') then return end
	self.index = nil

	local command = string.match(line, '^(/%S+)')
	if(command and IsSecureCmd(command)) then return end

	local history = self.history
	for index = 1, #history do
		if(history[index] == line) then
			return table.insert(history, table.remove(history, index))
		end
	end

	table.insert(history, line)

	if(#history > self:GetHistoryLines()) then
		table.remove(history, 1)
	end
end

function ns.History(self)
	self.history = {}
	self:SetAltArrowKeyMode(false)
	self:SetScript('OnArrowPressed', Navigate)
	hooksecurefunc(self, 'AddHistoryLine', AddLine)
end
