type lazyTable = { [any]: any }

local function applyTableChanges(maybeTarget: lazyTable?, changes: lazyTable)
	local target = maybeTarget or {}
	local removed = {}

	for key in changes do
		if key == "__removed" then
			continue
		end

		if typeof(changes[key]) == "table" then
			target[key] = applyTableChanges(target[key], changes[key])
		else
			target[key] = changes[key]
		end
	end

	if removed then
		for i, key in removed do
			target[key] = nil
		end
	end

	return target
end

return applyTableChanges
