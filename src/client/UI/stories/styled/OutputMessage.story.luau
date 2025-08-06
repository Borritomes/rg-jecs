local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Box = require(ReplicatedStorage.Client.UI.Components.Box)
local Fusion = require(ReplicatedStorage.Shared.Fusion)
local OutputMessage = require(ReplicatedStorage.Client.UI.Console.OutputMessage)
local theme = require(ReplicatedStorage.Client.UI.theme)

local controls = {}

local story = {
	fusion = Fusion,
	controls = controls,
	story = function(props: { scope: Fusion.Scope, controls: typeof(controls), target: Instance })
		local scope = props.scope

		Box(scope, {
			Size = UDim2.fromOffset(250, 150),

			BackgroundColor3 = theme.context:now().info,

			Parent = props.target,
		})
	end,
}

return story
