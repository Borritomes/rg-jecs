local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local cts = require(ReplicatedStorage.Shared.cts)
local cvars = require(ReplicatedStorage.Shared.cvars)
local events = require(ServerScriptService.Server.events)
local phases = require(ReplicatedStorage.Shared.phases)
local playersState = require(ServerScriptService.Server.playersState)
local world = require(ReplicatedStorage.Shared.world)

local raycastParams = RaycastParams.new()
raycastParams.RespectCanCollide = true

--[[local a1 = Instance.new("Attachment")
local a2 = Instance.new("Attachment")
local beam = Instance.new("Beam")

a1.Parent = workspace
a2.Parent = workspace

beam.FaceCamera = true
beam.Attachment0 = a1
beam.Attachment1 = a2
beam.Parent = workspace]]

local function buttonInteract()
	for entity, controller, position in world:query(cts.Controller, cts.Position) do
		local cmd = playersState[controller].cmdBuffer[1]
		if cmd == nil then
			continue
		end

		if cmd.use and cmd.use.began == true then
			local offset = Vector3.zero

			local size: Vector3? = world:get(entity, cts.Size)
			if size ~= nil then
				offset = Vector3.new(0, size.Y / 2, 0)
			end

			local lookDirection = (cmd.cameraCFrame or CFrame.new(1, 0, 0)).LookVector * cvars.useRange
			position += offset

			local result = workspace:Raycast(position, lookDirection, raycastParams)
			--a1.WorldPosition = position
			--a2.WorldPosition = position + lookDirection

			if result ~= nil then
				--a2.WorldPosition = result.Position
				local instance = result.Instance
				local buttonEvent = instance:GetAttribute("buttonEvent")
				local params = instance:GetAttribute("eventParams")

				if typeof(params) ~= "string" then
					return
				end
				if buttonEvent == nil then
					continue
				end

				if events[buttonEvent] ~= nil then
					if params ~= nil then
						events[buttonEvent](table.unpack(params:split(";")))
					end
				end
			end
		end
	end
end

return {
	system = buttonInteract,
	phase = phases.InputProcess,
}
