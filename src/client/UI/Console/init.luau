local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Shared.Fusion)
local screen = require(ReplicatedStorage.Client.UI.Components.screen)
local window = require(ReplicatedStorage.Client.UI.Components.window)

return function()
	local scope = Fusion.scoped(Fusion, {
		screen = screen,
		window = window,
	})

	return scope:screen {
		[Fusion.Children] = {
			scope:window {
				Title = "Developer Console",
			},
		},
	}
end
