local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Planck = require(ReplicatedStorage.Packages.Planck)

local Phases = {
	NetworkStart = Planck.Phase.new("NetworkStart"),
	Heartbeat = Planck.Phase.new("Heartbeat"),
	InputProcess = Planck.Phase.new("InputProcess"),
	First = Planck.Phase.new("First"),
	FixedUpdate = Planck.Phase.new("FixedUpdate"),
	Last = Planck.Phase.new("Last"),
	PhysicsApply = Planck.Phase.new("PhysicsApply"),
	Replication = Planck.Phase.new("Replication"),
	NetworkSend = Planck.Phase.new("NetworkdSend"),
	NetworkEnd = Planck.Phase.new("NetworkEnd"),
}

return Phases
