local ReplicatedStorage = game:GetService("ReplicatedStorage")

local jecs = require(ReplicatedStorage.Shared.jecs)
local world = require(script.Parent.world)

export type command = {
	name: string,
	run: (...any) -> (),
	protection: "none" | "cheat" | "dev",
	context: "client" | "server",
	args: { name: string, type: string }?,
}
export type commandBindings = { [string]: { string } }
export type playerData = { commands: { commandBindings } }

local cts = {
	Controller = world:component() :: jecs.Entity<Player>,
	TickAdjustment = world:component() :: jecs.Entity<{ fastForward: number, pause: number }>,
	Tick = world:component() :: jecs.Entity<number>,
	LastServerProcessedCmd = world:component() :: jecs.Entity<number>,
	AdjustmentGeneration = world:component() :: jecs.Entity<number>,
	Position = world:component() :: jecs.Entity<Vector3>,
	Size = world:component() :: jecs.Entity<Vector3>,
	Velocity = world:component() :: jecs.Entity<Vector3>,
	Name = world:component() :: jecs.Entity<string>,
	InputCommandMap = world:component() :: jecs.Entity<{ [any]: any }>,
	BindingMap = world:component() :: jecs.Entity<{ [any]: any }>,
	OnButtonActivate = world:component() :: jecs.Entity<(Player) -> ()>,

	Predicted = world:component(),
	Interp = world:component(),

	InterpolatePosition = jecs.tag(),
	Replicate = jecs.tag(),
	Button = jecs.tag(),
}

for name: any, component: any in cts do
	world:set(component, jecs.Name, name)
end

return cts
