local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Console = require(ReplicatedStorage.Client.UI.Console)
local Planck = require(ReplicatedStorage.Packages.Planck)

function UI()
	Console()
end

return {
	system = UI,
	phases = Planck.Phase.Startup,
	runConditions = {
		Planck.runOnce(),
	},
}
