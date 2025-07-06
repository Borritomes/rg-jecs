return function(unitVector3: Vector3, normalVector3: Vector3): Vector3
	return unitVector3 - unitVector3:Dot(normalVector3) * normalVector3
end
