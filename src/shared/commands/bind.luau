local ReplicatedStorage = game:GetService("ReplicatedStorage")

local commands = require(ReplicatedStorage.Shared.commands)
local cts = require(ReplicatedStorage.Shared.cts)
local world = require(ReplicatedStorage.Shared.world)

local keycodeMap = {}
for i, keycode: Enum.KeyCode in Enum.KeyCode:GetEnumItems() do
	keycodeMap[keycode.Name:upper()] = keycode
end

local MAX_COMMAND_LENGTH = 512

local function bind(keycode: string, command: string): boolean
	keycode = keycode:upper()
	if keycodeMap[keycode] == nil or keycode == "__REMOVED" then
		print(`unkown keycode {keycode}`)
		return false
	end
	if command:len() > MAX_COMMAND_LENGTH then
		return false
	end
	local inputCommandMap = world:get(cts.InputCommandMap, cts.InputCommandMap) or {}
	local bindingMap = world:get(cts.BindingMap, cts.BindingMap) or {}

	if inputCommandMap[command] == nil then
		local inputAction = Instance.new("InputAction")
		inputAction.Name = command
		inputAction.Parent = ReplicatedStorage.Actions

		local pressedCommand = command
		local releasedCommand = nil

		if command:sub(1, 1) == "+" then
			releasedCommand = "-" .. command:sub(2)
		end

		local ok, pressedCommandQueue = commands.evaluate(pressedCommand)

		local pressedConnection = inputAction.Pressed:Connect(function()
			if ok == true and typeof(pressedCommandQueue) ~= "string" then
				commands.executeQueue(pressedCommandQueue)
			end
		end)

		local releasedCommandQueue
		local releasedConnection

		if releasedCommand ~= nil then
			ok, releasedCommandQueue = commands.evaluate(releasedCommand)
		end

		if ok == true and typeof(releasedCommandQueue) ~= "string" then
			releasedConnection = inputAction.Released:Connect(function()
				if releasedCommand ~= nil then
					commands.executeQueue(releasedCommandQueue)
				end
			end)
		else
			releasedConnection = inputAction.Released:Connect(function() end)
		end

		inputCommandMap[command] = {
			inputAction = inputAction,
			pressedConnection = pressedConnection,
			releasedConnection = releasedConnection,
		}
	end
	if inputCommandMap[command][keycode] == nil then
		if
			typeof(inputCommandMap[command].inputAction) == "Instance"
			and inputCommandMap[command].inputAction:IsA("InputAction")
			and inputCommandMap[command].inputAction:FindFirstChild(keycode) == nil
		then
			local inputBinding = Instance.new("InputBinding")
			inputBinding.Name = keycode
			inputBinding.KeyCode = keycodeMap[keycode]
			inputBinding.Parent = inputCommandMap[command].inputAction

			if bindingMap[keycode] == nil then
				bindingMap[keycode] = {}
			end
			table.insert(bindingMap[keycode], inputBinding)
			if inputCommandMap[command].bindings == nil then
				inputCommandMap[command].bindings = {}
			end
			inputCommandMap[command].bindings[keycode] = inputBinding
		end
	end

	world:set(cts.InputCommandMap, cts.InputCommandMap, inputCommandMap)
	world:set(cts.BindingMap, cts.BindingMap, bindingMap)

	return true
end

return {
	run = bind,
	protection = "none",
	args = { { name = "key", type = "string" }, { name = "command", type = "string" } },
}
