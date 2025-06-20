local ReplicatedStorage = game:GetService("ReplicatedStorage")

local cts = require(ReplicatedStorage.Shared.cts)
local world = require(ReplicatedStorage.Shared.world)
return function(player: Player)
	local character = world:entity()
	world:set(character, cts.Player, player)
	world:set(character, cts.Position, Vector3.new(0, -3.5, -10))

	return character
end
