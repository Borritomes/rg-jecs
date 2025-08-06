local ReplicatedStorage = game:GetService("ReplicatedStorage")

local cts = require(ReplicatedStorage.Shared.cts)
local world = require(ReplicatedStorage.Shared.world)
return function(player: Player)
	local character = world:entity()
	world:set(character, cts.Controller, player)
	world:set(character, cts.Position, Vector3.new(0, -3.5, -10))
	world:set(character, cts.Velocity, Vector3.new(0, 0, 0))
	world:set(character, cts.Size, Vector3.new(2, 4, 2))
	world:set(character, cts.Name, player.Name)
	world:set(character, cts.Health, 100)
	world:add(character, cts.Replicate)
	world:add(character, cts.InterpolatePosition)
	world:add(character, cts.Predicted)

	return character
end
