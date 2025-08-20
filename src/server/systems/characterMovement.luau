local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local calcMovement = require(ReplicatedStorage.Shared.physics.calcMovement)
local cts = require(ReplicatedStorage.Shared.cts)
local cvars = require(ReplicatedStorage.Shared.cvars)
local getWishDir = require(ReplicatedStorage.Shared.utils.getWishDir)
local phases = require(ReplicatedStorage.Shared.phases)
local playersState = require(ServerScriptService.Server.playersState)
local routes = require(ReplicatedStorage.Shared.routes)
local world = require(ReplicatedStorage.Shared.world)

local function characterMovement()
	for entity, controller, position, velocity in world:query(cts.Controller, cts.Position, cts.Velocity) do
		local size = world:get(entity, cts.Size)
		local cmd = playersState[controller].cmdBuffer[1]
		local wishDir = getWishDir(cmd)
		local newPosition, newVelocity = calcMovement(wishDir, position, velocity, 1 / cvars.sv.TickRate, size)
		--print(newPosition)
		if cmd ~= nil and cmd.timestamp ~= nil then
			local overflow = cvars.sv.CmdBufferTarget - #playersState[controller].cmdBuffer
			routes.confirmCmd:send(cmd.timestamp, if overflow ~= 0 then overflow else nil):to(controller)
		end
		if typeof(controller) ~= "string" then
			table.remove(playersState[controller].cmdBuffer, 1)
		end
		world:set(entity, cts.Position, newPosition)
		world:set(entity, cts.Velocity, newVelocity)
	end
end

return {
	system = characterMovement,
	phase = phases.FixedUpdate,
}
