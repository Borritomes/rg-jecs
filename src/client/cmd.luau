export type inputcmd = { began: boolean, ended: boolean, weight: number }
export type cmd = {
	forward: inputcmd?,
	backward: inputcmd?,
	strafeLeft: inputcmd?,
	strafeRight: inputcmd?,
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
