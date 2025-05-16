local clientDataService = {}

local template = {
	adjustmentGeneration = 0,
	tickDifferenceHistory = {},
}

local clientData = {}

function clientDataService.addClient(userId: number)
	clientData[userId] = template
end

function clientDataService.removeClient(userId: number)
	if clientData[userId] == nil then
		warn(`tried to remove {userId} but it is already nil`)
	end
	clientData[userId] = nil
end

function clientDataService.get(userId: number, key: string): any
	if clientData[userId] ~= nil then
		if clientData[userId][key] ~= nil then
			return clientData[userId][key]
		end
		warn(`no data for {key} in {userId}, setting {key} to default value: {template[key]}`)
		clientData[userId][key] = template[key]
		return clientData[userId][key]
	end
	warn(`{userId} not in data`)
	return nil
end

function clientDataService.set(userId: number, key: string, newValue: any)
	if clientData[userId] ~= nil then
		clientData[userId][key] = newValue
		return
	end
	warn(`userId: {userId} not found in clientData`)
end

function clientDataService.addToTable(userId: number, key: string, value: any)
	if clientData[userId] == nil then
		clientData[userId] = template
		clientData[userId][key] = { value }
		return
	end
	if clientData[userId][key] == nil then
		clientData[userId][key] = { value }
	end

	table.insert(clientData[userId][key], value)
end

function clientDataService.removeFromTable(userId, key, index)
	if clientData[userId] and clientData[userId][key] then
		table.remove(clientData[userId][key], index)
	end
end

return clientDataService
