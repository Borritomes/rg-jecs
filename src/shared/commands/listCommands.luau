local ReplicatedStorage = game:GetService("ReplicatedStorage")

local commands = require(ReplicatedStorage.Shared.commands)

return commands.createCommand({
	name = "listCommands",
	run = function()
		print(
			"commands: bind, cl_predict, correctPredict, +backward, -backward, +forward,"
				.. " -forward, +jump, -jump, listCommands, +strafeLeft, -strafeLeft, +strafeRight, "
				.. "-strafeRight, test (toggles mouse lock, don't ask why), toggleConsole, unbind, "
				.. "+use, -use, zoomIn, zoomOut"
		)
	end,
	protection = "none",
	context = "client",
})
