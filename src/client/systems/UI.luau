local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Console = require(ReplicatedStorage.Client.UI.Console)
local Fusion = require(ReplicatedStorage.Shared.Fusion)
local Padding = require(ReplicatedStorage.Client.UI.Components.Padding)
local Planck = require(ReplicatedStorage.Packages.Planck)
local Screen = require(ReplicatedStorage.Client.UI.Components.Screen)
local Stroke = require(ReplicatedStorage.Client.UI.Components.Stroke)
local Text = require(ReplicatedStorage.Client.UI.Components.Text)
local UIState = require(ReplicatedStorage.Client.UI.UIState)
local theme = require(ReplicatedStorage.Client.UI.theme)
local udim2 = require(ReplicatedStorage.Client.UI.Utils.udim2)
local usePx = require(ReplicatedStorage.Client.UI.Utils.usePx)

function UI()
	local scope = Fusion.scoped(Fusion, {
		Screen = Screen,
		Console = Console,
		Text = Text,
		Stroke = Stroke,
		Padding = Padding,
		usePx = usePx,
		udim2 = udim2,
	})

	local style = theme.context:now()
	print(
		'<b><font color="#FFFF00">Hello! this is the console. The syntax is similar to the source engine console '
			.. 'and has a few useful commands:\n-"bind" works the same as the source engine'
			.. '\n"cl_predict" boolean that determines if the client predicts (may have unexpected behavior)'
			.. '\n"correctPredict" boolean the detemines if mispredictions are corrected'
			.. '\n"listCommands" lists all commands not here (most of them, not many useful ones though)</font></b>'
	)

	scope:Screen {
		IgnoreGuiInset = true,
		Enabled = UIState.consoleEnabled,

		[Fusion.Children] = {
			scope:Console(),
		},
	}
	scope:Screen {
		[Fusion.Children] = {
			scope:Text {
				Position = UDim2.fromScale(0, 0),
				Size = scope:udim2(0, 0, 0, style.outputMessageHeight),
				AutomaticSize = Enum.AutomaticSize.X,
				AnchorPoint = Vector2.new(0, 0),

				BackgroundTransparency = 1,

				TextColor3 = style.colorNeutral,
				Text = '"~" or "`" to open console, there are some useful options there!',
				TextSize = scope:usePx(style.outputMessageHeight),

				[Fusion.Children] = {
					scope:Stroke(),
					scope:Padding {},
				},
			},
		},
	}
end

return {
	system = UI,
	phases = Planck.Phase.Startup,
	runConditions = {
		Planck.runOnce(),
	},
}
