local ReplicatedStorage = game:GetService("ReplicatedStorage")

local cts = require(ReplicatedStorage.Shared.cts)
local world = require(ReplicatedStorage.Shared.world)

local function changeCmd(key, change)
	local cmd = world:get(cts.cmd, cts.cmd) or {}
	if cmd[key] == nil then
		cmd[key] = {
			began = false,
			ended = false,
			weight = 0,
		}
	end
	if change > 0 then
		cmd[key].began = true
	else
		cmd[key].ended = true
	end
	cmd[key].weight += change

	world:set(cts.cmd, cts.cmd, cmd)
end

return changeCmd
