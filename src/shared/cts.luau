local ReplicatedStorage = game:GetService("ReplicatedStorage")

local jecs = require(ReplicatedStorage.Shared.jecs)
local world = require(script.Parent.world)

export type command = {
	run: (...any) -> boolean,
	protection: "none" | "cheat" | "dev",
	args: { name: string, type: string }?,
}
export type commandBindings = { [string]: { string } }
export type playerData = { commands: { commandBindings } }

local cts = {
	Player = world:component() :: jecs.Entity<Player>,
	Tick = world:component() :: jecs.Entity<number>,
	Position = world:component() :: jecs.Entity<Vector3>,
	Velocity = world:component() :: jecs.Entity<Vector3>,
	Name = world:component() :: jecs.Entity<string>,
	InputCommandMap = world:component() :: jecs.Entity<{ [any]: any }>,
	BindingMap = world:component() :: jecs.Entity<{ [any]: any }>,

	Replicate = jecs.tag(),
	Predicted = jecs.tag(),
}

for name: any, component: any in cts do
	world:set(component, jecs.Name, name)
end

return cts
