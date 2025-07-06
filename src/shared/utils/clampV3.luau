return function(Vector: Vector3, min: number, max: number): Vector3
	return Vector3.new(math.clamp(Vector.X, min, max), math.clamp(Vector.Y, min, max), math.clamp(Vector.Z, min, max))
end
