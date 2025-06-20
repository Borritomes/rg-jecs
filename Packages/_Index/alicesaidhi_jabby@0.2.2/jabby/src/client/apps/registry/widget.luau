local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local pebble = require(script.Parent.Parent.Parent.Parent.Parent.pebble)
local vide = require(script.Parent.Parent.Parent.Parent.Parent.vide)
local tooltip = require(script.Parent.Parent.Parent.components.tooltip)
local spawn_app = require(script.Parent.Parent.Parent.spawn_app)
local entity = require(script.Parent.Parent.entity)

local create = vide.create
local effect = vide.effect
local source = vide.source
local show = vide.show

type SystemId = number

type props = {
	host: Player | "server",
	vm: number,
	id: number,

	validate_query: (string) -> (),
	ok: () -> boolean,
	msg: () -> string,

	paused: vide.Source<boolean>,
	refresh: (boolean) -> (),

	from: vide.Source<number>,
	upto: vide.Source<number>,

	update_system_query: (query: string) -> (),
	current_query: () -> string,
	total_entities: () -> number,

	enable_pick: vide.Source<boolean>,
	entity_hovering_over: () -> string,
	hovering_over: () -> BasePart,

	columns: () -> {{any}},

	destroy: () -> ()
}

local mouse_location = source(Vector2.zero)

RunService.PreRender:Connect(function()
	mouse_location(UserInputService:GetMouseLocation())
end)

return function(props: props)

	local page_input = source("1")
	local rows_input = source("25")

	local page = source(1)
	local rows = source(20)

	effect(function()
		page_input(tostring(page()))
	end)

	effect(function()
		rows_input(tostring(rows()))
	end)

	effect(function()
		local page = page()
		local rows_per_page = rows()

		local from = (page - 1) * rows_per_page + 1
		local upto = from + rows_per_page - 1

		props.from(from)
		props.upto(upto)
	end)

	local row_template = {
		Size = UDim2.new(0, 0, 0, 26),
		AutomaticSize = Enum.AutomaticSize.X
	} :: any

	return pebble.widget {
		title = "Querying",
		subtitle = `host: {props.host} vm: {props.vm} id: {props.id}`,

		min_size = Vector2.new(300, 300),

		bind_to_close = props.destroy,

		create "Frame" {

			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,

			tooltip {
				transparency = 0.3,
				visible = function()
					return props.entity_hovering_over() and #props.entity_hovering_over() > 0 or false
				end,

				pebble.typography {
					automaticsize = Enum.AutomaticSize.XY,

					text = function()
						return props.entity_hovering_over() or ""
					end,
					xalignment = Enum.TextXAlignment.Left,
					wrapped = true,
					code = true,
					
					{ RichText = true },

					create "UIStroke" {
						Thickness = 1,
						Color = pebble.theme.bg[-5]
					}
				}
			},

			create "Highlight" {
				DepthMode = Enum.HighlightDepthMode.AlwaysOnTop,
				OutlineColor = Color3.new(1, 1, 1),
				FillColor = pebble.theme.acc[0],
				FillTransparency = 0.5,
	
				Adornee = props.hovering_over
			},

			create "UIListLayout" {
				VerticalFlex = Enum.UIFlexAlignment.SpaceAround,
				Padding = UDim.new(0, 8)
			},

			create "Frame" {
				Name = "Query + Pick",
				Size = UDim2.new(1, 0, 0, 30),

				BackgroundTransparency = 1,
				
				create "UIListLayout" {
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalFlex = Enum.UIFlexAlignment.SpaceAround,
					VerticalFlex = Enum.UIFlexAlignment.SpaceAround,
					Padding = UDim.new(0, 8)
				},

				create "Frame" {

					Name = "Query",

					Size = UDim2.fromScale(0, 1),
					BackgroundTransparency = 1,

					create "UIFlexItem" {
						FlexMode = Enum.UIFlexMode.Fill
					},

					pebble.textfield {
						size = UDim2.new(1, 0, 0, 30),
						placeholder = "Query",
		
						code = true,
		
						oninput = function(text)
							props.validate_query(text)
						end,
		
						enter = function(text)
							props.update_system_query(text)
						end
					},

				},

				pebble.button {
					size = UDim2.fromOffset(30, 30),
	
					text = "",

					accent = props.enable_pick,

					activated = function()
						props.enable_pick(not props.enable_pick())
					end,
					
					create "ImageLabel" {
						Size = UDim2.fromOffset(24, 24),
						Position = UDim2.fromScale(0.5, 0.5),
						AnchorPoint = Vector2.new(0.5, 0.5),
	
						BackgroundTransparency = 1,

						ImageColor3 = pebble.theme.fg_on_bg_high[3],
	
						Image = "rbxassetid://10734898355"
					},
	
				},

			},

			create "Frame" {
				Size = UDim2.new(1, 0, 0, 24),

				BackgroundTransparency = 1,

				Visible = function()
					return not props.ok() and #props.msg() > 0
				end,
				
				pebble.typography {
					text = props.msg
				},

			},

			create "Frame" {
				
				Size = UDim2.new(1, 0, 0, 32),

				BackgroundColor3 = pebble.theme.bg[2],
				AutomaticSize = Enum.AutomaticSize.Y,

				create "UICorner" {
					CornerRadius = UDim.new(0, 8)
				},

				create "UIListLayout" {
					FillDirection = Enum.FillDirection.Horizontal,
					Padding = UDim.new(0, 8),
					HorizontalFlex = Enum.UIFlexAlignment.SpaceAround,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					Wraps = true
				},

				pebble.row {
					spacing = UDim.new(0, 8),
					alignitems = Enum.ItemLineAlignment.Center,
					row_template,

					pebble.typography {
						text = "Page:"
					},
	
					pebble.textfield {
						size = UDim2.fromOffset(40, 26),
						placeholder = "1",
						
						text = function()
							return page_input()
						end,
	
						oninput = page_input,
	
						enter = function(text)
							local n = tonumber(text)
	
							if n == nil then
								page_input(tostring(page()))
							else
								page(n)
							end
						end
					},

					pebble.typography {
						text = function()
							return `/ {math.ceil(props.total_entities() / rows())}`
						end
					},
				},


				pebble.row {
					spacing = UDim.new(0, 8),
					alignitems = Enum.ItemLineAlignment.Center,
					row_template,

					pebble.typography {
						text = "Rows:"
					},

					pebble.textfield {
						size = UDim2.fromOffset(40, 26),
						placeholder = "Rows",

						text = function()
							return rows_input()
						end,

						oninput = rows_input,

						enter = function(text)
							local n = tonumber(text)

							if n == nil then
								rows_input(tostring(rows()))
							else
								rows(n)
							end
						end
					},
				},

				pebble.row {
					spacing = UDim.new(0, 4),
					row_template,
					
					pebble.button {
						size = UDim2.fromOffset(26, 26),
						text = "",

						accent = function()
							return not props.paused()
						end,

						activated = function()
							props.paused(not props.paused())
						end,

						{LayoutOrder = 10},
						
						create "ImageLabel" {
							Size = UDim2.fromOffset(24, 24),
							Position = UDim2.fromScale(0.5, 0.5),
							AnchorPoint = Vector2.new(0.5, 0.5),
		
							BackgroundTransparency = 1,

							ImageColor3 = pebble.theme.fg_on_bg_high[3],
		
							Image = function()
								return if props.paused() then "rbxassetid://10735024209"
							else "rbxassetid://10734923214"
							end
						},
		
					},

					show(props.paused, function()
						return pebble.button {
							size = UDim2.fromOffset(26, 26),
							text = "",
		
							activated = function()
								props.refresh(true)
							end,
							
							create "ImageLabel" {
								Size = UDim2.fromOffset(24, 24),
								Position = UDim2.fromScale(0.5, 0.5),
								AnchorPoint = Vector2.new(0.5, 0.5),
			
								BackgroundTransparency = 1,
		
								ImageColor3 = pebble.theme.fg_on_bg_high[3],
			
								Image = "rbxassetid://10734933222"
							},
			
						}
					end)
				}

			},


			pebble.background {
				size = UDim2.fromScale(1, 0),
				automaticsize = Enum.AutomaticSize.Y,

				create "UICorner" {
					CornerRadius = UDim.new(0, 8)
				},
				
				create "UIFlexItem" {
					FlexMode = Enum.UIFlexMode.Fill
				},
				
				pebble.tablesheet {
					size = UDim2.fromScale(1, 1),
					suggested_column_sizes = { 0.1 },

					column_sizes = function()
						local t = {}
						for i in props.columns() do
							t[i] = 200
						end
						t[1] = 50
						return t
					end,
					columns = props.columns,
	
					read_value = function(c, r)
						local column = props.columns()[c]
						if not column then return "" end
						return column[r] or ""
					end,
	
					on_click = function(c, r)
						if not props.columns()[1][r-1] then return end
						spawn_app.spawn_app(entity, {
							host = props.host,
							vm = props.vm,
							id = props.id,
							entity = props.columns()[1][r-1]
						})
					end,
					on_click2 = function() end,

					below = {

						pebble.padding {
							x = UDim.new(0, 4),
							y = UDim.new(0, 2)
						},

						create "UIListLayout" {
							FillDirection = Enum.FillDirection.Horizontal,
							VerticalAlignment = Enum.VerticalAlignment.Center,
							Padding = UDim.new(0, 8)
						},

						pebble.button {
							size = UDim2.fromOffset(70, 26),
							text = "Previous",

							activated = function()
								page(page() - 1)
							end,

							disabled = function()
								return page() == 1 or props.ok() == false
							end
						} :: Instance,

						pebble.button {
							size = UDim2.fromOffset(70, 26),
							text = "Next",

							activated = function()
								page(page() + 1)
							end,

							disabled = function()
								local max_pages = math.max(1, math.ceil(props.total_entities() / rows()))
								return page() == max_pages or props.ok() == false
							end
						} :: Instance,
						
						pebble.typography {
							position = UDim2.new(0, 4, 0.5, 0),
							anchorpoint = Vector2.new(0, 0.5),

							text = function()
								return `total entities: {props.total_entities()}\tfrom: {props.from()}\tuntil: {props.upto()}`
							end,
						} :: Instance,
					}
				}

			}

		}

	}

end