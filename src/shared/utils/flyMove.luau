local ReplicatedStorage = game:GetService("ReplicatedStorage")

local clampV3 = require(ReplicatedStorage.Shared.utils.clampV3)
local collideAndSlide = require(ReplicatedStorage.Shared.utils.collideAndSlide)
local cvars = require(ReplicatedStorage.Shared.cvars)
local v3UnitsToStuds = require(ReplicatedStorage.Shared.utils.v3UnitsToStuds)

return function(position: Vector3, velocity: Vector3, size: Vector3?)
	local maxVelocity = cvars.MaxVelocity

	velocity = clampV3(velocity, -maxVelocity, maxVelocity)
	velocity = v3UnitsToStuds(velocity)
	velocity *= cvars.TimeScale
	velocity *= 1 / cvars.TickRate

	return position + collideAndSlide(velocity, position, size or Vector3.zero, 0)
end
