local actions = require(script.Parent.actions)
export type actionCommandState = { isActive: boolean, didBegin: boolean, didEnd: boolean }

local actionCommandState = { isActive = false, didBegin = false, didEnd = false }
table.freeze(actionCommandState)

local cmd = {
	[actions.Forward] = actionCommandState,
	[actions.Backward] = actionCommandState,
	[actions.StrafeLeft] = actionCommandState,
	[actions.StrafeRight] = actionCommandState,
	[actions.Jump] = actionCommandState,
	[actions.Duck] = actionCommandState,
	[actions.Use] = actionCommandState,
	[actions.Attack] = actionCommandState,
}

return cmd
