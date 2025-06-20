local ReplicatedStorage = game:GetService("ReplicatedStorage")

local cmd = require(ReplicatedStorage.Client.cmd)

local function changeCmd(key: string, change: number)
	local cmdTrace = cmd.current[key]

	if cmdTrace == nil then
		cmdTrace = cmd.inputcmd()
		cmd.current[key] = cmdTrace
	end

	cmdTrace.weight += change
	if change > 0 then
		cmdTrace.began = true
	elseif change < 0 then
		cmdTrace.ended = true
	end
end

return changeCmd
