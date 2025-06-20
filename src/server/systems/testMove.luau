local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local cts = require(ReplicatedStorage.Shared.cts)
local phases = require(ReplicatedStorage.Shared.phases)
local players = require(ServerScriptService.Server.players)
local scheduler = require(ReplicatedStorage.Shared.scheduler)
local world = require(ReplicatedStorage.Shared.world)

local part
local fraction = 5

local function visMovedir()
	for entity, player, position in world:query(cts.Player, cts.Position):iter() do
		local cmd = players[player].cmdBuffer[1]
		if cmd == nil then
			print "no cmd"
			return
		end

		local moveDir = Vector3.zero
		if cmd ~= nil then
			if cmd.forward ~= nil and cmd.forward.weight ~= nil then
				moveDir -= Vector3.new(0, 0, cmd.forward.weight)
			end
			if cmd.backward ~= nil and cmd.backward.weight ~= nil then
				moveDir += Vector3.new(0, 0, cmd.backward.weight)
			end
			if cmd.strafeLeft ~= nil and cmd.strafeLeft.weight ~= nil then
				moveDir -= Vector3.new(cmd.strafeLeft.weight, 0, 0)
			end
			if cmd.strafeRight ~= nil and cmd.strafeRight.weight ~= nil then
				moveDir += Vector3.new(cmd.strafeRight.weight, 0, 0)
			end
		end
		if moveDir ~= Vector3.zero then
			local dt = scheduler:getDeltaTime()
			moveDir = (moveDir.Unit * Vector3.new(fraction, fraction, fraction)) * Vector3.new(dt, dt, dt)
		end

		world:set(entity, cts.Position, position + moveDir)

		if part == nil then
			part = Instance.new("Part")
			part.Name = "HIHIHIHIHIHIHIHIHI"
			part.Anchored = true
			part.Size = Vector3.new(1, 1, 1)
			part.Transparency = 0.5
			part.Color = Color3.new(0, 1, 0)
			part.Position = world:get(entity, cts.Position) or Vector3.zero
			part.Parent = workspace
		else
			part.Position = world:get(entity, cts.Position) or Vector3.zero
		end
	end
end

return {
	system = visMovedir,
	phase = phases.ReflectState,
}
