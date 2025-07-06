local ReplicatedStorage = game:GetService("ReplicatedStorage")

local cts = require(ReplicatedStorage.Shared.cts)
local world = require(ReplicatedStorage.Shared.world)

local function unbind(key: string)
	if key == "__removed" then
		return
	end
	key = key:upper()
	local bindingMap = world:get(cts.BindingMap, cts.BindingMap) or {}

	if bindingMap[key] == nil then
		print(`bindingMap[{key}] is nil`)
		return
	end
	for i, v in bindingMap[key] do
		if typeof(v) == "Instance" then
			v:Destroy()
		end
	end

	bindingMap[key] = nil
	world:set(cts.BindingMap, cts.BindingMap, bindingMap)
end

return {
	run = unbind,
	protection = "none",
	args = { { name = "key", type = "string" } },
}
