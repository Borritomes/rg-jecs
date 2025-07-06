local SCALE_RATIO = 1.0885714286

return function(hammerUnits: number): number
	return ((hammerUnits / 16) * SCALE_RATIO)
end
