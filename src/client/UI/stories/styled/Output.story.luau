local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Shared.Fusion)
local Output = require(ReplicatedStorage.Client.UI.Console.Output)

local controls = {}

local story = {
	fusion = Fusion,
	controls = controls,
	story = function(props: { scope: Fusion.Scope, controls: typeof(controls), target: Instance })
		local scope = props.scope

		return Output(scope, {})
	end,
}

return story
