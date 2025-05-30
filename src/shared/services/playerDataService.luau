local ReplicatedStorage = game:GetService("ReplicatedStorage")

local cts = require(ReplicatedStorage.Shared.cts)
local playerDataService = {}

type keys = "adjustmentGeneration" | "tickDifferenceHistory" | "commands" | "cmdHistory" | "cmd"

local template = {
	adjustmentGeneration = 0,
	tickDifferenceHistory = {},
	keybinds = {},
	cmdHistory = {},
	cmd = {} :: cts.cmd,
}

playerDataService.directAccess = {}

function playerDataService.addClient(userId: number)
	playerDataService.directAccess[userId] = template
end

function playerDataService.removeClient(userId: number)
	if playerDataService.directAccess[userId] == nil then
		warn(`tried to remove {userId} but it is already nil`)
	end
	playerDataService.directAccess[userId] = nil
end

function playerDataService.get(userId: number, key: keys): any
	if playerDataService.directAccess[userId] ~= nil then
		if playerDataService.directAccess[userId][key] ~= nil then
			return playerDataService.directAccess[userId][key]
		end
		warn(`no data for {key} in {userId}, setting {key} to default value: {template[key]}`)
		playerDataService.directAccess[userId][key] = template[key]
		return playerDataService.directAccess[userId][key]
	end
	warn(`{userId} not in data`)
	return
end

function playerDataService.set<T>(userId: number, key: keys, newValue: T): T?
	if playerDataService.directAccess[userId] ~= nil then
		playerDataService.directAccess[userId][key] = newValue
		return newValue
	end
	warn(`userId: {userId} not found in clientData`)
	return
end

function playerDataService.addToTable(userId: number, key: keys, value: any)
	if playerDataService.directAccess[userId] == nil then
		playerDataService.directAccess[userId] = template
		playerDataService.directAccess[userId][key] = { value }
		return
	end
	if playerDataService.directAccess[userId][key] == nil then
		playerDataService.directAccess[userId][key] = { value }
	end

	table.insert(playerDataService.directAccess[userId][key], value)
end

function playerDataService.removeFromTable(userId, key: keys, index)
	if playerDataService.directAccess[userId] and playerDataService.directAccess[userId][key] then
		table.remove(playerDataService.directAccess[userId][key], index)
	end
end

return playerDataService
