local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Planck = require(ReplicatedStorage.Packages.Planck)

local Phases = {
	Heartbeat = Planck.Phase.new("Heartbeat"),
	NetworkStart = Planck.Phase.new("NetworkStart"),
	Replication = Planck.Phase.new("Replication"),
	InputProcess = Planck.Phase.new("InputProcess"),
	First = Planck.Phase.new("First"),
	FixedUpdate = Planck.Phase.new("FixedUpdate"),
	Last = Planck.Phase.new("Last"),
	PhysicsApply = Planck.Phase.new("PhysicsApply"),
	ReflectState = Planck.Phase.new("ReflectState"),
	SendState = Planck.Phase.new("SendState"),
	NetworkEnd = Planck.Phase.new("NetworkEnd"),
}

return Phases
