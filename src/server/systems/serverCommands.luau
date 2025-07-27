local ReplicatedStorage = game:GetService("ReplicatedStorage")

local commands = require(ReplicatedStorage.Shared.commands)
local phases = require(ReplicatedStorage.Shared.phases)
local routes = require(ReplicatedStorage.Shared.routes)

local function serverCommands()
	for pos, sender, command, args in routes.command:query():iter() do
		print("server commanding")
		--TODO: make sure the player has permission to execute server commands
		commands.executeSingle(command, args)
	end
end

return {
	system = serverCommands,
	phase = phases.InputProcess,
}
