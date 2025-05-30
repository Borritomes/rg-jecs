local ReplicatedStorage = game:GetService("ReplicatedStorage")

local jecs = require(ReplicatedStorage.Shared.jecs)
local world = require(script.Parent.world)

export type inputcmd = { began: boolean, ended: boolean, weight: number }
export type cmd = {
	forward: inputcmd?,
	backward: inputcmd?,
	strafeLeft: inputcmd?,
	strafeRight: inputcmd?,
}
export type cmdHistory = { [number]: cmd }

local cts = {
	Player = world:component() :: jecs.Entity<Player>,
	MoveDirection = world:component() :: jecs.Entity<Vector3>,
	TickAdjustment = world:component() :: jecs.Entity<{ fastForward: number, pause: number }>,
	Tick = world:component() :: jecs.Entity<number>,
	LastUpdate = world:component() :: jecs.Entity<number>,
	AdjustmentGeneration = world:component() :: jecs.Entity<number>,
	Position = world:component() :: jecs.Entity<Vector3>,
	Velocity = world:component() :: jecs.Entity<Vector3>,
	Name = world:component() :: jecs.Entity<string>,
	InputCommandMap = world:component() :: jecs.Entity<{ [any]: any }>,
	BindingMap = world:component() :: jecs.Entity<{ [any]: any }>,
	cmd = world:component() :: jecs.Entity<cmd>,
	CmdHistory = world:component() :: jecs.Entity<cmdHistory>,

	Replicate = jecs.tag(),
	Predicted = jecs.tag(),
}

for name: any, component: any in cts do
	world:set(component, jecs.Name, name)
end

return cts
