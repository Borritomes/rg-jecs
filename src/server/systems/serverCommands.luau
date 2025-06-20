local ReplicatedStorage = game:GetService("ReplicatedStorage")

local commands = require(ReplicatedStorage.Shared.commands)
local phases = require(ReplicatedStorage.Shared.phases)
local routes = require(ReplicatedStorage.Shared.routes)

local function serverCommands()
	for pos, sender, command in routes.command:query():iter() do
		--TODO: make sure the player has permission to execute server commands

		if command.command ~= nil then
			command.command.run(table.unpack(command.args))
		end
	end
end

return {
	system = serverCommands,
	phase = phases.InputProcess,
}
