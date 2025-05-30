local ReplicatedStorage = game:GetService("ReplicatedStorage")

local tablekit = require(ReplicatedStorage.Packages.tablekit)

-- most stuff here is from https://github.com/MaximumADHD/Roblox-Boilerplate/blob/main/Shared/DeltaTable.luau
local function getTableChanges(oldTable: any, newTable: any)
	if oldTable == nil then
		warn("oldTable is nil")
		oldTable = tablekit.DeepCopy(newTable)
	end

	local changes = {}
	local changeCount = 0

	for key, value in newTable do
		if oldTable[key] == nil then
			changes[key] = value
			changeCount += 1
		else
			if typeof(value) == "table" then
				local childTable, childChangeCount = getTableChanges(oldTable[key], newTable[key])

				if childChangeCount > 0 then
					changeCount += 1
					changes[key] = childTable
				end
			else
				local oldValue = oldTable[key]
				local newValue = newTable[key]

				if oldValue ~= newValue then
					changeCount += 1
					changes[key] = newValue
				end
			end
		end
	end

	local removed = {}

	for key in oldTable do
		if newTable[key] == nil then
			table.insert(removed, key)
			changeCount += 1
		end
	end

	if next(removed) then
		changes.__removed = removed
	end

	return changes, changeCount
end

return getTableChanges
