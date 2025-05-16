local ReplicatedStorage = game:GetService("ReplicatedStorage")

local phases = require(ReplicatedStorage.Shared.phases)

local function inputProcess() end

return {
	system = inputProcess,
	phase = phases.InputProcess,
}
