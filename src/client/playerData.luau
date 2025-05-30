local ReplicatedStorage = game:GetService("ReplicatedStorage")

local applyTableChanges = require(ReplicatedStorage.Shared.utils.applyTableChanges)
local bind = require(ReplicatedStorage.Client.commands.bind)
local playerData = {}
local data = {}

function playerData.applyChanges(changes)
	if changes.bindings ~= nil then
		for keycode, commands: { string } in changes.bindings do
			for i, command in commands do
				bind.run(keycode, command)
			end
		end
	end

	data = applyTableChanges(data, changes)
end

function playerData.get(key: any?)
	if key == nil then
		return data
	else
		return data[key]
	end
end

return playerData
