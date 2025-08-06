local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Shared.Fusion)
local TextInput = require(ReplicatedStorage.Client.UI.Components.TextInput)

local controls = {}

local story = {
	fusion = Fusion,
	controls = controls,
	story = function(props: { scope: Fusion.Scope, controls: typeof(controls), target: Instance })
		local scope = props.scope

		return TextInput(scope, {})
	end,
}

return story
