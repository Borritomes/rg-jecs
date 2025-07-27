local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Planck = require(ReplicatedStorage.Packages.Planck)
local phases = require(script.Parent.phases)

local pipelines = {
	FixedUpdate = Planck
		.Pipeline
		.new("FixedUpdate")
		:insert(phases.NetworkStart)
		:insert(phases.Replication) --THE CLIENT NEEDS TO USE THIS AND THE SERVER SEND WORLD ON SENDSTATE
		:insert(phases.InputProcess)
		:insert(phases.First)
		:insert(phases.FixedUpdate)
		:insert(phases.Last)
		:insert(phases.PhysicsApply)
		:insert(phases.ReflectState)
		:insert(phases.SendState)
		:insert(phases.NetworkEnd),
	Heartbeat = Planck.Pipeline.new("Heartbeat"):insert(phases.PreHeartbeat):insert(phases.Heartbeat),
}

return pipelines
