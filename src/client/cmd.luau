export type inputcmd = { began: boolean, ended: boolean, weight: number }
export type cmd = {
	timestamp: number?,
	cameraCFrame: CFrame?,

	forward: inputcmd?,
	backward: inputcmd?,
	strafeLeft: inputcmd?,
	strafeRight: inputcmd?,
	jump: inputcmd?,
	use: inputcmd?,
}
export type cmdRecord = { [number]: cmd? }

local cmd = {}

function cmd.inputcmd()
	return {
		began = false,
		ended = true,
		weight = 0,
	}
end

cmd.current = {} :: cmd

cmd.record = {} :: cmdRecord

return cmd
