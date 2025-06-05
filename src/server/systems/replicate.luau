local ReplicatedStorage = game:GetService("ReplicatedStorage")

local jecs = require(ReplicatedStorage.Shared.jecs)
local phases = require(ReplicatedStorage.Shared.phases)
local routes = require(ReplicatedStorage.Shared.routes)

local function replicate()
	local snapshot = {} :: {
		[jecs.Entity]: {
			{ rel: jecs.Entity, trg: jecs.Entity, val: routes.supported }
			| { comp: number, val: routes.supported? }
		},
	}
end

return {
	system = replicate,
	phase = phases.Replication,
}
