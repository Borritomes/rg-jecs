return function(Vector: Vector3, max: number): Vector3
	if Vector.Magnitude > max then
		return Vector.Unit * max
	end
	return Vector3.new(
		math.clamp(Vector.X, -max, max),
		math.clamp(Vector.Y, -max, max),
		math.clamp(Vector.Z, -max, max)
	)
end
