local ReplicatedStorage = game:GetService("ReplicatedStorage")

local cts = require(ReplicatedStorage.Shared.cts)
local phases = require(ReplicatedStorage.Shared.phases)
local world = require(ReplicatedStorage.Shared.world)

local parts = {} :: { [number]: Part? }

local function render()
	for entity, position in world:query(cts.Position) do
		if parts[entity] == nil then
			local part = Instance.new("Part")
			part.Anchored = true
			part.CanCollide = false
			part.Size = Vector3.new(2, 4, 2)
			part.Color = Color3.new(0, 1, 0)
			part.Transparency = 1
			part.Parent = workspace

			parts[entity] = part
		end

		local part = parts[entity]

		if part ~= nil then
			part.Position = position
		end
	end
end

return {
	system = render,
	phase = phases.ReflectState,
}
