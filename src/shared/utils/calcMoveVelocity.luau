local ReplicatedStorage = game:GetService("ReplicatedStorage")

local cvars = require(ReplicatedStorage.Shared.cvars)

local function accelerate(wishVelocity: Vector3, moveDirection: Vector3, velocity: Vector3): Vector3
	local wishSpeed = wishVelocity.Magnitude

	wishVelocity = if wishVelocity == Vector3.zero then Vector3.zero else wishVelocity.Unit

	local currentSpeed = velocity:Dot(moveDirection)
	local addSpeed = wishSpeed - currentSpeed
	if addSpeed <= 0 then
		return Vector3.zero
	end
	local accel = cvars.Accelerate :: number
	local accelSpeed = accel * wishSpeed
	if accelSpeed > addSpeed then
		accelSpeed = addSpeed
	end

	return (Vector3.one * accelSpeed) * moveDirection * cvars.TimeScale
end

local function airAccelerate(wishVelocity: Vector3, velocity: Vector3)
	local uncappedWishSpeed = wishVelocity.Magnitude
	local wishSpeed = wishVelocity.Magnitude
	if wishSpeed > 30 then --TODO: magic number :(
		wishSpeed = 30
	end
	wishVelocity = if wishVelocity == Vector3.zero then Vector3.zero else wishVelocity.Unit

	local currentSpeed = velocity:Dot(wishVelocity)
	local addSpeed = wishSpeed - currentSpeed
	if addSpeed == 0 then
		return Vector3.zero
	end

	local accelSpeed = uncappedWishSpeed * cvars.Accelerate * (1 / cvars.TickRate)
	if accelSpeed > addSpeed then
		accelSpeed = addSpeed
	end

	return (Vector3.one * accelSpeed) * wishVelocity * cvars.TimeScale
end

local function friction(velocity: Vector3)
	local speed = math.sqrt(velocity.X * velocity.X + velocity.Y * velocity.Y + velocity.Z * velocity.Z)

	--TODO: add edge friction

	local stopSpeed = cvars.StopSpeed
	local control = if speed < stopSpeed then stopSpeed else speed
	local newspeed = speed - (1 / cvars.TickRate) * control * cvars.Friction
	--local newspeed = speed - control * cvars.Friction

	if newspeed < 0 then
		newspeed = 0
	end

	if newspeed ~= 0 and speed ~= 0 then
		newspeed /= speed
	else
		newspeed = 0
	end

	return velocity * newspeed
end

local function floorCheck(position: Vector3, size: Vector3?): boolean
	local result
	local sizeY

	if size == nil or size == Vector3.zero then
		result = workspace:Raycast(position, Vector3.new(0, -1, 0))
	else
		local castSize = Vector3.new(size.X, size.Y / 2, size.Z)
		local castDirection = Vector3.new(0, -size.Y / 2, 0)

		result = workspace:Blockcast(CFrame.new(position), castSize, castDirection)
	end

	if size == nil then
		sizeY = 0
	else
		sizeY = size.Y
	end

	if result ~= nil and result.Distance <= (sizeY / 4) + 0.05 then
		return true
	else
		return false
	end
end

local function calcMoveVelocity(
	velocity: Vector3,
	position: Vector3,
	size: Vector3?,
	wishDir: Vector3,
	isJump: boolean?
): Vector3
	local isOnGround = floorCheck(position, size)

	local wishVelocity = wishDir * cvars.MaxSpeed

	if isOnGround == true then
		velocity = friction(velocity)
		velocity += accelerate(wishVelocity, wishDir, velocity)
		velocity -= Vector3.new(0, cvars.Gravity * (1 / cvars.TickRate), 0)
		return velocity
	else
		velocity += airAccelerate(wishVelocity, velocity)
		velocity -= Vector3.new(0, cvars.Gravity * (1 / cvars.TickRate), 0)
		return velocity
	end
end

return calcMoveVelocity
