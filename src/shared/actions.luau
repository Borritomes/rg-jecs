export type ActionSnapshot = { [number]: { isActive: boolean, didBegin: boolean, didEnd: boolean } }

local actions = {
	Forward = 1,
	Backward = 2,
	StrafeLeft = 3,
	StrafeRight = 4,
	Jump = 5,
	Crouch = 6,
	Primary = 7,
	Secondary = 8,
	Interact = 9,
	UnlockMouse = 10,
	ToggleConsole = 11,
}

return actions
