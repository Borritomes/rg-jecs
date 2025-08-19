local ReplicatedStorage = game:GetService("ReplicatedStorage")

local cts = require(ReplicatedStorage.Shared.cts)
local jecs = require(ReplicatedStorage.Shared.jecs)
local world = require(ReplicatedStorage.Shared.world)
local events: { [string]: (jecs.Entity<unknown> | "none", Player | string, ...any) -> () } = {}

function events.print(entity, activator, message: string, repeatFor: string)
	for i = 1, tonumber(repeatFor) or 1 do
		print(message)
	end
end

function events.killPlayer(entity, activator)
	if typeof(activator) ~= "Instance" then
		return
	end
	if not activator:IsA("Player") then
		return
	end

	if typeof(entity) == "number" then
		world:set(entity, cts.Health, 0)
	end
end

return events
