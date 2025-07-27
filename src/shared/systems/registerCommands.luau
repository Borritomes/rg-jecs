local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Planck = require(ReplicatedStorage.Packages.Planck)
local commands = require(ReplicatedStorage.Shared.commands)

local function registerCommands()
	for i, instance in ReplicatedStorage.Shared.commands:GetDescendants() do
		if instance:IsA("ModuleScript") then
			commands.registerCommand(require(instance))
		end
	end
end

return {
	system = registerCommands,
	phase = Planck.Phase.Startup,
}
