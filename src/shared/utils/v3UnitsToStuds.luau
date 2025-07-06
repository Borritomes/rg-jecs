local ReplicatedStorage = game:GetService("ReplicatedStorage")

local unitsToStuds = require(ReplicatedStorage.Shared.utils.unitsToStuds)

return function(hammerUnits: Vector3): Vector3
	return Vector3.new(unitsToStuds(hammerUnits.X), unitsToStuds(hammerUnits.Y), unitsToStuds(hammerUnits.Z))
end
