local ReplicatedStorage = game:GetService("ReplicatedStorage")

local cts = require(ReplicatedStorage.Shared.cts)
local phases = require(ReplicatedStorage.Shared.phases)
local world = require(ReplicatedStorage.Shared.world)

local function visMovedir()
	for entity, moveDirection in world:query(cts.MoveDirection):iter() do
		local part = Instance.new("Part")
		part.Name = "HIHIHIHIHIHIHIHIHI"
		part.Anchored = true
		part.Size = Vector3.new(1, 1, 1)
		part.Transparency = 0.5
		part.Color = Color3.new(1, 0, 0)
		part.Position = moveDirection
		part.Parent = workspace

		task.delay(0.1, function()
			part:Destroy()
		end)
	end
end

return {
	system = visMovedir,
	phase = phases.ReflectState,
}
