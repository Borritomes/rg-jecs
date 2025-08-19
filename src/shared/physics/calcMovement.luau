local ReplicatedStorage = game:GetService("ReplicatedStorage")

local cts = require(ReplicatedStorage.Shared.cts)
local cvars = require(ReplicatedStorage.Shared.cvars)
local world = require(ReplicatedStorage.Shared.world)
local MARGIN = 0.015
local MAX_CLIP_PLANES = 5
local NUM_BUMPS = 4
local DOUBLE_MARGIN = MARGIN * 2

local function cast(position: Vector3, direction: Vector3, size: Vector3?)
	if size == nil then
		return workspace:Raycast(position, Vector3.new(0, -1, 0))
	else
		size = size - Vector3.new(DOUBLE_MARGIN, DOUBLE_MARGIN, DOUBLE_MARGIN)
		return workspace:Blockcast(CFrame.new(position), size, Vector3.new(0, -1, 0))
	end
end

local function accelerate() end

local function airAccelerate() end

local function friction() end

local function collideAndSlide(position: Vector3, velocity: Vector3, size: Vector3?)
	local deltaTime = world:get(cts.DeltaTime, cts.DeltaTime) or 1 / cvars.sv.TickRate

	local primalVelocity = velocity
	local originalVelocity = velocity
	local numPlanes = 0

	for count = 0, NUM_BUMPS do
	end
end

local function checkIsOnGround(position: Vector3, size: Vector3?): boolean
	local result = cast(position, Vector3.new(0, -1, 0), size)

	if result ~= nil then
		print(math.round(result.Distance * 1000) / 1000)
		return true
	else
		return false
	end
end

return function(wishDir: Vector3, position: Vector3, velocity: Vector3, size: Vector3?): (Vector3, Vector3)
	local isOnGround = checkIsOnGround(position, size)
	local newPosition
	local newVelocity

	if isOnGround == true then
		velocity = Vector3.new(velocity.X, 0, velocity.Z)
	end

	if isOnGround then
		newPosition, newVelocity = friction()
		newPosition, newVelocity = accelerate()
	else
		newPosition, newVelocity = airAccelerate()
	end

	local newPosition = position + wishDir
	local newVelocity = Vector3.zero

	return newPosition, newVelocity
end
