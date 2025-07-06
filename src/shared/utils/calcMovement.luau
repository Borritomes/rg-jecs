local ReplicatedStorage = game:GetService("ReplicatedStorage")

local calcMoveVelocity = require(ReplicatedStorage.Shared.utils.calcMoveVelocity)
local cmd = require(ReplicatedStorage.Client.cmd)
local flyMove = require(ReplicatedStorage.Shared.utils.flyMove)
local getWishDir = require(ReplicatedStorage.Shared.utils.getWishDir)

return function(cmd: cmd.cmd?, position: Vector3, velocity: Vector3, size: Vector3?): (Vector3, Vector3)
	local wishDir, isJump = getWishDir(cmd)

	local resultVelocity = calcMoveVelocity(velocity, position, size, wishDir, isJump)
	--resultVelocity -= Vector3.new(0, cvars.Gravity * (1 / cvars.TickRate), 0)
	local resultPosition = flyMove(position, resultVelocity, size)

	return resultPosition, resultVelocity
end
