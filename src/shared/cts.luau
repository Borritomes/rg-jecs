local ReplicatedStorage = game:GetService("ReplicatedStorage")

local jecs = require(ReplicatedStorage.Shared.jecs)
local world = require(ReplicatedStorage.Shared.world)

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
	--singletons
	Tick = world:component() :: jecs.Entity<number>,
	DeltaTime = world:component() :: jecs.Entity<number>,
	InputCommandMap = world:component() :: jecs.Entity<{ [string]: any }>,
	BindingMap = world:component() :: jecs.Entity<{ [any]: any }>,
	CmdBufOverflow = world:component() :: jecs.Entity<number>,

	--normal
	Controller = world:component() :: jecs.Entity<Player>,
	Position = world:component() :: jecs.Entity<Vector3>,
	PositionHistory = world:component() :: jecs.Entity<{ [number]: Vector3? }?>,
	Size = world:component() :: jecs.Entity<Vector3>,
	Velocity = world:component() :: jecs.Entity<Vector3>,
	Name = world:component() :: jecs.Entity<string>,
	Health = world:component() :: jecs.Entity<number>,
	OnKilled = world:component() :: jecs.Entity<() -> ()>,
	OnButtonActivate = world:component() :: jecs.Entity<(Player) -> ()>,

	--pair prefixes
	Predicted = world:component(),
	Interp = world:component(),

	--tags
	Invurlnerable = jecs.tag(),
	InterpolatePosition = jecs.tag(),
	Replicate = jecs.tag(),
	Button = jecs.tag(),
}

for name: any, component: any in cts do
	world:set(component, jecs.Name, name)
end

return cts
