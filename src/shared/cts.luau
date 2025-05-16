local ReplicatedStorage = game:GetService("ReplicatedStorage")

local jecs = require(ReplicatedStorage.Shared.jecs)
local world = require(script.Parent.world)

local cts = {
	TickAdjustment = world:component() :: jecs.Entity<{ fastForward: number, pause: number }>,
	Tick = world:component() :: jecs.Entity<number>,
	LastUpdate = world:component() :: jecs.Entity<number>,
	AdjustmentGeneration = world:component() :: jecs.Entity<number>,
	Position = world:component() :: jecs.Entity<Vector3>,
	Velocity = world:component() :: jecs.Entity<Vector3>,
	Name = world:component() :: jecs.Entity<string>,

	Replicate = jecs.tag(),
	Prediction = jecs.tag(),
}

for name: any, component: any in cts do
	world:set(component, jecs.Name, name)
end

return cts
