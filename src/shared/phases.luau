local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Planck = require(ReplicatedStorage.Packages.Planck)

local Phases = {
	--Heartbeat
	PreHeartbeat = Planck.Phase.new("PreHeartbeat"),
	Heartbeat = Planck.Phase.new("Heartbeat"),

	--FixedUpdate
	RecieveReplication = Planck.Phase.new("RecieveReplication"),
	Input = Planck.Phase.new("Input"),
	First = Planck.Phase.new("First"),
	FixedUpdate = Planck.Phase.new("FixedUpdate"),
	Last = Planck.Phase.new("Last"),
	ReflectState = Planck.Phase.new("ReflectState"),
	SendReplication = Planck.Phase.new("SendReplication"),
}

return Phases
