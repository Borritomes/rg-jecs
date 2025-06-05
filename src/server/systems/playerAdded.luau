local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Planck = require(ReplicatedStorage.Packages.Planck)
local cts = require(ReplicatedStorage.Shared.cts)
local jecs = require(ReplicatedStorage.Shared.jecs)
local phases = require(ReplicatedStorage.Shared.phases)
local playerDataService = require(ReplicatedStorage.Shared.services.playerDataService)
local routes = require(ReplicatedStorage.Shared.routes)
local world = require(ReplicatedStorage.Shared.world)

local hasNewEvent, collectEvents = Planck.onEvent(Players, Players.PlayerAdded)

local function playerAdded()
	for i, player: Player in collectEvents() do
		do
			local ent = world:entity()
			world:set(ent, cts.Name, "ent")
			local ent2 = world:entity()
			world:set(ent2, cts.Name, "ent2")
			local ent3 = world:entity()
			world:set(ent3, cts.Name, "ent3")
			world:add(ent, cts.Replicate)
			world:add(ent2, cts.Replicate)
			world:add(ent3, cts.Replicate)
			world:set(ent, cts.Position, Vector3.new(2, 5, 1))
			world:set(ent2, cts.Position, Vector3.new(1, 3, 5))
			world:set(ent2, cts.Velocity, Vector3.new(20, 0, 10))
			world:set(ent3, jecs.pair(cts.Position, cts.Velocity), Vector3.new(1, 2, 3))
			world:set(ent2, jecs.pair(cts.Position, cts.Velocity), Vector3.new(2, 4, 6))
		end
		local character = world:entity()
		world:set(character, cts.Player, player)
		world:set(character, cts.MoveDirection, Vector3.zero)

		playerDataService.addClient(player.UserId)
		routes.playerAdded:send({ Tick = world:get(cts.Tick, cts.Tick) or 0 }):to(player)
	end
end

return {
	system = playerAdded,
	phase = phases.Heartbeat,
	runConditions = {
		hasNewEvent,
	},
}
