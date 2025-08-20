local ReplicatedStorage = game:GetService("ReplicatedStorage")

local clampV3 = require(ReplicatedStorage.Shared.utils.clampV3)
local cvars = require(ReplicatedStorage.Shared.cvars)
local unitsToStuds = require(ReplicatedStorage.Shared.utils.unitsToStuds)
local v3UnitsToStuds = require(ReplicatedStorage.Shared.utils.v3UnitsToStuds)
local MAX_DEPTH = 5
local MARGIN = 0.015
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

	local accelSpeed = wishSpeed * cvars.sv.Accelerate * deltaTime
	if accelSpeed > addspeed then
		accelSpeed = addspeed
	end

	return velocity + accelSpeed * wishDir
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

	local accelSpeed = uncappedWishSpeed * cvars.sv.Accelerate * deltaTime
	if accelSpeed > addSpeed then
		accelSpeed = addSpeed
	end

	return velocity + (wishVelocity * accelSpeed)
end

--[[void SV_UserFriction (void)
{
	float	*vel;
	float	speed, newspeed, control;
	vec3_t	start, stop;
	float	friction;
	trace_t	trace;
	
	vel = velocity;
	
	speed = sqrt(vel[0]*vel[0] +vel[1]*vel[1]);
	if (!speed)
		return;

// if the leading edge is over a dropoff, increase friction
	start[0] = stop[0] = origin[0] + vel[0]/speed*16;
	start[1] = stop[1] = origin[1] + vel[1]/speed*16;
	start[2] = origin[2] + sv_player->v.mins[2];
	stop[2] = start[2] - 34;

	trace = SV_Move (start, vec3_origin, vec3_origin, stop, true, sv_player);

	if (trace.fraction == 1.0)
		friction = sv_friction.value*sv_edgefriction.value;
	else
		friction = sv_friction.value;

// apply friction	
	control = speed < sv_stopspeed.value ? sv_stopspeed.value : speed;
	newspeed = speed - host_frametime*control*friction;
	
	if (newspeed < 0)
		newspeed = 0;
	newspeed /= speed;

	vel[0] = vel[0] * newspeed;
	vel[1] = vel[1] * newspeed;
	vel[2] = vel[2] * newspeed;
}]]
local function friction(velocity: Vector3, deltaTime: number)
	local vel = velocity

	local speed = math.sqrt(vel.X * vel.X + vel.Z * vel.Z)
	if not speed then
		return velocity
	end

	local friction = cvars.sv.Friction

	--TODO: if the leading edge is over a dropoff, increase friction

	local control = if speed < cvars.sv.StopSpeed then cvars.sv.StopSpeed else speed
	local newSpeed = speed - deltaTime * control * friction

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

	local result = cast(position, velocity.Unit * distance, size)
	if result == nil then
		return velocity
	end

	local snapToSurface = velocity.Unit * (result.Distance - MARGIN)
	local leftover = velocity - snapToSurface

	if snapToSurface.Magnitude <= MARGIN then
		snapToSurface = Vector3.zero
	end

	local magnitude = leftover.Magnitude
	leftover = projectOnPlane(leftover, result.Normal)
	if leftover ~= Vector3.zero then
		leftover = leftover.Unit
	end
	leftover *= magnitude

	return snapToSurface + collideAndSlide(position + snapToSurface, leftover, depth + 1, size)
end

local function checkIsOnGround(position: Vector3, size: Vector3?): boolean
	local result = cast(position, Vector3.new(0, -1, 0), size)

	if result ~= nil then
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
		newVelocity = accelerate(wishDir, velocity, deltaTime)
		if jump == true then
			print "jump"
			newVelocity += Vector3.new(0, unitsToStuds(cvars.sv.JumpForce), 0)
		end
	else
		newVelocity = airAccelerate(wishDir, velocity, deltaTime)
		newVelocity -= Vector3.new(0, cvars.sv.Gravity * deltaTime, 0)
	end

	local maxVelocity = cvars.sv.MaxVelocity

	local collideVelocity = newVelocity
	collideVelocity = clampV3(velocity, maxVelocity)
	collideVelocity = v3UnitsToStuds(velocity)
	collideVelocity *= cvars.sv.TimeScale
	collideVelocity *= deltaTime

	local newPosition = position + collideAndSlide(position, newVelocity, 0, size)

	--newPosition = position + wishDir
	--newVelocity = Vector3.zero

	newVelocity = Vector3.zero
	return newPosition, newVelocity
end
