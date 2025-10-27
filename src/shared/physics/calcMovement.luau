local ReplicatedStorage = game:GetService("ReplicatedStorage")

local clampV3 = require(ReplicatedStorage.Shared.utils.clampV3)
local cvars = require(ReplicatedStorage.Shared.cvars)
local v3UnitsToStuds = require(ReplicatedStorage.Shared.utils.v3UnitsToStuds)
local MAX_DEPTH = 5
local MARGIN = 0.05
local DOUBLE_MARGIN = MARGIN * 2

local function vectorNormalize(vec: Vector3)
	if vec ~= Vector3.zero then
		return vec.Unit
	else
		return vec
	end
end

local function projectOnPlane(unitVector3: Vector3, normalVector3: Vector3): Vector3
	return unitVector3 - unitVector3:Dot(normalVector3) * normalVector3
end

local function cast(position: Vector3, direction: Vector3, size: Vector3?)
	local raycastParams = RaycastParams.new()
	raycastParams.CollisionGroup = "PlayerCollide"
	raycastParams.RespectCanCollide = true

	if size == nil then
		return workspace:Raycast(position, direction, raycastParams)
	else
		size = size - Vector3.new(DOUBLE_MARGIN, DOUBLE_MARGIN, DOUBLE_MARGIN)
		return workspace:Blockcast(CFrame.new(position), size, direction, raycastParams)
	end
end

local function accelerate(wishDir: Vector3, velocity: Vector3, deltaTime: number): Vector3
	local wishVelocity = wishDir * cvars.sv.MaxSpeed
	local wishSpeed = wishVelocity.Magnitude

	local currentSpeed = velocity:Dot(wishDir)
	local addspeed = wishSpeed - currentSpeed
	if addspeed <= 0 then
		return velocity
	end

	local accelSpeed = wishSpeed --* cvars.sv.Accelerate * deltaTime
	if accelSpeed > addspeed then
		accelSpeed = addspeed
	end

	return velocity + (accelSpeed * wishDir)
end

local function airAccelerate(wishDir: Vector3, velocity: Vector3, deltaTime: number): Vector3
	local wishVelocity = wishDir * cvars.sv.MaxSpeed

	local wishSpeed = wishVelocity.Magnitude
	wishVelocity = vectorNormalize(wishVelocity)
	local uncappedWishSpeed = wishSpeed
	if wishSpeed > 30 then
		wishSpeed = 30
	end

	local currentSpeed = velocity:Dot(wishVelocity)
	local addSpeed = wishSpeed - currentSpeed
	if addSpeed <= 0 then
		return velocity
	end

	local accelSpeed = uncappedWishSpeed -- * cvars.sv.Accelerate * deltaTime
	if accelSpeed > addSpeed then
		accelSpeed = addSpeed
	end

	return velocity + (wishVelocity * accelSpeed)
end

local function friction(velocity: Vector3, deltaTime: number)
	local vel = velocity

	local speed = math.sqrt(vel.X * vel.X + vel.Z * vel.Z)
	if speed == 0 then
		return Vector3.zero
	end

	local friction = cvars.sv.Friction

	--TODO: if the leading edge is over a dropoff, increase friction

	local control = if speed < cvars.sv.StopSpeed then cvars.sv.StopSpeed else speed
	local newSpeed = speed - (control * friction * deltaTime)

	if newSpeed < 0 then
		newSpeed = 0
	end

	newSpeed /= speed

	return vel * newSpeed
end

local function collideAndSlide(position: Vector3, velocity: Vector3, depth: number, size: Vector3?)
	if velocity == Vector3.zero then
		return Vector3.zero
	end
	if depth >= MAX_DEPTH then
		return Vector3.zero
	end

	local distance = velocity.Magnitude + MARGIN

	local result = cast(position, vectorNormalize(velocity) * distance, size)
	if result == nil then
		return velocity
	end

	local snapToSurface = velocity.Unit * (result.Distance - MARGIN)
	local leftover = velocity - snapToSurface

	if snapToSurface.Magnitude <= MARGIN then
		snapToSurface = Vector3.zero
	end

	--if result.Normal.Y > cvars.sv.MaxSlope then
	local magnitude = leftover.Magnitude
	leftover = projectOnPlane(leftover, result.Normal)
	leftover = vectorNormalize(leftover)
	leftover *= magnitude
	--end

	return snapToSurface + collideAndSlide(position + snapToSurface, leftover, depth + 1, size)
end

local function checkIsOnGround(position: Vector3, size: Vector3?): boolean
	local result = cast(position, Vector3.new(0, -1, 0), size)

	if result ~= nil and result.Distance <= MARGIN then
		return true
	else
		return false
	end
end

return function(
	wishDir: Vector3,
	position: Vector3,
	velocity: Vector3,
	deltaTime: number,
	size: Vector3?
): (Vector3, Vector3)
	local isOnGround = checkIsOnGround(position, size)
	local newVelocity

	local jump = false
	if wishDir.Y > 0 then
		jump = true
	end
	wishDir = Vector3.new(wishDir.X, 0, wishDir.Z)

	if isOnGround == true then
		velocity *= Vector3.new(1, 0, 1)
		newVelocity = friction(velocity, deltaTime)
		newVelocity = accelerate(wishDir, newVelocity, deltaTime)
		if jump == true then
			newVelocity += Vector3.new(0, cvars.sv.JumpForce, 0)
		end
	else
		newVelocity = airAccelerate(wishDir, velocity, deltaTime)
		newVelocity -= Vector3.new(0, cvars.sv.Gravity * deltaTime, 0)
	end

	local maxVelocity = cvars.sv.MaxVelocity

	local collideVelocity = newVelocity
	collideVelocity = clampV3(collideVelocity, maxVelocity)
	collideVelocity = v3UnitsToStuds(collideVelocity)
	collideVelocity *= cvars.sv.TimeScale
	collideVelocity *= deltaTime

	local newPosition = position + collideAndSlide(position, collideVelocity, 0, size)

	--newPosition = position + wishDir
	--newVelocity = Vector3.zero

	return newPosition, newVelocity
end
