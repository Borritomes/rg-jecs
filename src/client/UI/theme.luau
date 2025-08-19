local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Shared.Fusion)

local theme = {}

local scope = Fusion.scoped(Fusion)

theme.styles = {
	dark = {
		background = Color3.new(0.1, 0.1, 0.1),
		highlight = Color3.new(0.2, 0.2, 0.2),
		title = Color3.new(0.3, 0.3, 0.3),
		info = Color3.new(0.075, 0.075, 0.075),

		font = Font.fromEnum(Enum.Font.BuilderSans),

		colorNeutral = Color3.new(0.7, 0.7, 0.7),
		colorRed = Color3.new(0.9, 0.15, 0.15),

		windowTopbarSize = 20,
		outputMessageHeight = 24,

		padding = 8,
		strokeWidth = 2,

		textTitle = 28,
		textCaption = 20,
	},
	light = {
		background = Color3.new(0.9, 0.9, 0.9),
		highlight = Color3.new(0.7, 0.7, 0.7),
		title = Color3.new(0.6, 0.6, 0.6),
		info = Color3.new(0.7, 0.7, 0.7),

		font = Font.fromEnum(Enum.Font.BuilderSans),

		colorNeutral = Color3.new(0.3, 0.3, 0.3),
		colorRed = Color3.new(0.7, 0.3, 0.3),

		windowTopbarSize = 20,
		outputMessageHeight = 24,

		padding = 8,
		strokeWidth = 2,

		textTitle = 28,
		textCaption = 20,
	},
}

theme.currentStyleName = scope:Value("dark")

theme.dynamic = {} :: typeof(theme.styles.dark)
for namedColor in theme.styles.dark do
	theme.dynamic[namedColor] = scope:Computed(function(use)
		local styleName = use(theme.currentStyleName)
		return theme.styles[styleName][namedColor]
	end)
end

theme.context = Fusion.Contextual(theme.dynamic)

return theme
