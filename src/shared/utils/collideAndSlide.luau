local RunService = game:GetService("RunService")

local function projectV3OnPlane(unitVector3: Vector3, normalVector3: Vector3): Vector3
	return unitVector3 - unitVector3:Dot(normalVector3) * normalVector3
end

local MARGIN = 0.05
local MAX_DEPTH = 4

local colors = {
	Color3.new(1, 0, 0),
	Color3.new(1, 1, 0),
	Color3.new(0, 1, 0),
	Color3.new(0, 1, 1),
	Color3.new(0, 0, 1),
}
local destroyers = {
	[1] = function() end,
	[2] = function() end,
	[3] = function() end,
	[4] = function() end,
	[5] = function() end,
}

local function collideAndSlide(velocity: Vector3, position: Vector3, size: Vector3, depth: number): Vector3
	local result = nil :: RaycastResult?
	local raycastParams = RaycastParams.new()
	raycastParams.CollisionGroup = "PlayerCollide"
	raycastParams.RespectCanCollide = true

	if depth >= MAX_DEPTH then
		return Vector3.zero
	end

	local distance = velocity.Magnitude + MARGIN
	size -= Vector3.new(MARGIN, MARGIN, MARGIN)

	if size == Vector3.zero then
		result = workspace:Raycast(position, velocity, raycastParams)
	else
		local unitVelocity = if velocity == Vector3.zero then Vector3.zero else velocity.Unit
		result = workspace:Blockcast(CFrame.new(position), size, unitVelocity * distance, raycastParams)
		if RunService:IsClient() and false then
			do
				destroyers[depth + 1]()
				local part = Instance.new("Part")
				part.Size = Vector3.new(size.X, size.Y, size.Z)
				part.Anchored = true
				part.Transparency = 0.5
				part.Color = colors[depth + 1] or Color3.new(1, 1, 1)
				part.CanCollide = false
				part.CanTouch = false
				part.CanQuery = false
				if result then
					part.Position = position + velocity.Unit * (result.Distance - MARGIN)
				else
					part.Position = position + velocity
				end
				part.Parent = workspace
				destroyers[depth + 1] = function()
					part:Destroy()
				end
			end
		end
	end

	if result ~= nil then
		local velocityUnit = if velocity == Vector3.zero then Vector3.zero else velocity.Unit
		local hitPosition = velocityUnit * (result.Distance - MARGIN)
		local leftoverVelocity = velocity - hitPosition

		if hitPosition.Magnitude <= MARGIN then
			hitPosition = Vector3.zero
		end

		local magnitude = leftoverVelocity.Magnitude
		local leftoverVelocityUnit = if leftoverVelocity == Vector3.zero then Vector3.zero else leftoverVelocity.Unit
		leftoverVelocity = projectV3OnPlane(leftoverVelocityUnit, result.Normal)
		leftoverVelocity *= magnitude

		return hitPosition
			+ collideAndSlide(
				leftoverVelocity,
				position + hitPosition,
				size + Vector3.new(MARGIN, MARGIN, MARGIN),
				depth + 1
			)
	end

	return velocity
end

return collideAndSlide
