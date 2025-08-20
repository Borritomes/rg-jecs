local cvars = {
	sv = {
		CmdBufferTarget = 5,
		TickRate = 33,
		TimeScale = 1,
		Gravity = 800,
		MaxVelocity = 1024,
		MaxSlopeAngle = 0.05,
		Accelerate = 10,
		StopSpeed = 100,
		MaxSpeed = 320,
		Friction = 4,
		JumpForce = 270,
		useRange = 15,
		MaxSlope = 0.7,
	},
	cl = {
		Interp = 0.2,
		Predict = true,
		CorrectMispredict = true,
		Fov = 90,
		CameraClampY = 89,
		MouseLocked = true,
		Sensitivity = 1,
		CameraOffset = 10,
	},
}

return cvars
