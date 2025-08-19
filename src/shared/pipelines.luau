local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Planck = require(ReplicatedStorage.Packages.Planck)
local phases = require(script.Parent.phases)

local pipelines = {
	FixedUpdate = Planck
		.Pipeline
		.new("FixedUpdate")
		:insert(phases.RecieveReplication) --THE CLIENT NEEDS TO USE THIS AND THE SERVER SEND WORLD ON SENDSTATE
		:insert(phases.Input)
		:insert(phases.First)
		:insert(phases.FixedUpdate)
		:insert(phases.Last)
		:insert(phases.ReflectState)
		:insert(phases.SendReplication),
	Heartbeat = Planck.Pipeline.new("Heartbeat"):insert(phases.PreHeartbeat):insert(phases.Heartbeat),
}

return pipelines
