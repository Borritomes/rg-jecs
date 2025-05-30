local ReplicatedStorage = game:GetService("ReplicatedStorage")

local cts = require(ReplicatedStorage.Shared.cts)
local phases = require(ReplicatedStorage.Shared.phases)
local playerDataService = require(ReplicatedStorage.Shared.services.playerDataService)
local world = require(ReplicatedStorage.Shared.world)

local function playerMoveDirection()
	for entity, player, moveDirection in world:query(cts.Player, cts.MoveDirection):iter() do
		local cmd = playerDataService.directAccess[player.UserId].cmd

		local movedir = Vector3.zero

		if cmd.forward ~= nil and cmd.forward.began == true or cmd.forward ~= nil and cmd.forward.weight ~= 0 then
			movedir += Vector3.new(cmd.forward.weight, 0, 0)
		end
		if cmd.backward ~= nil and cmd.backward.began == true or cmd.backward ~= nil and cmd.backward.weight ~= 0 then
			movedir -= Vector3.new(cmd.backward.weight, 0, 0)
		end
		if
			cmd.strafeLeft ~= nil and cmd.strafeLeft.began == true
			or cmd.strafeLeft ~= nil and cmd.strafeLeft.weight ~= 0
		then
			movedir -= Vector3.new(0, 0, cmd.strafeLeft.weight)
		end
		if
			cmd.strafeRight ~= nil and cmd.strafeRight.began == true
			or cmd.strafeRight ~= nil and cmd.strafeRight.weight ~= 0
		then
			movedir += Vector3.new(0, 0, cmd.strafeRight.weight)
		end

		if movedir ~= Vector3.zero then
			movedir = movedir.Unit
		end

		world:set(entity, cts.MoveDirection, movedir)
	end
end

return {
	system = playerMoveDirection,
	phase = phases.First,
}
