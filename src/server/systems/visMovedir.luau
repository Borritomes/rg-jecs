local ReplicatedStorage = game:GetService("ReplicatedStorage")

local cts = require(ReplicatedStorage.Shared.cts)
local phases = require(ReplicatedStorage.Shared.phases)
local world = require(ReplicatedStorage.Shared.world)

local destroy = function() end

local function visMovedir()
	for entity, moveDirection in world:query(cts.MoveDirection):iter() do
		destroy()
		local part = Instance.new("Part")
		part.Name = "HIHIHIHIHIHIHIHIHI"
		part.Anchored = true
		part.Size = Vector3.new(1, 1, 1)
		part.Transparency = 0.5
		part.Color = Color3.new(1 * moveDirection.X, 1, 1 * moveDirection.Z)
		part.Position = moveDirection
		part.Parent = workspace

		destroy = function()
			part:Destroy()
		end
	end
end

return {
	system = visMovedir,
	phase = phases.ReflectState,
}
