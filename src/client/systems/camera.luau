local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local Fusion = require(ReplicatedStorage.Shared.Fusion)
local UIState = require(ReplicatedStorage.Client.UI.UIState)
local cts = require(ReplicatedStorage.Shared.cts)
local cvars = require(ReplicatedStorage.Shared.cvars)
local jecs = require(ReplicatedStorage.Shared.jecs)
local phases = require(ReplicatedStorage.Shared.phases)
local world = require(ReplicatedStorage.Shared.world)

local localPlayer = Players.LocalPlayer
local xRotation = 0
local yRotation = 0

local function camera()
	local position = Vector3.new(0, 0, 0)
	local size = Vector3.zero

	for entity, player, pos in world:query(cts.Controller, cts.Position) do
		if player == localPlayer then
			position = world:get(entity, jecs.pair(cts.Interp, cts.Position)) or pos
			if world:has(entity, cts.Size) then
				size = world:get(entity, cts.Size) or Vector3.zero
			end
		end
	end

	local currentCamera = workspace.CurrentCamera

	if currentCamera.CameraType ~= Enum.CameraType.Scriptable then
		currentCamera.CameraType = Enum.CameraType.Scriptable
	end
	currentCamera.FieldOfView = cvars.cl.Fov

	local clamp = cvars.cl.CameraClampY
	local mouseLocked = cvars.cl.MouseLocked
	local consoleEnabled = Fusion.peek(UIState.consoleEnabled)

	if mouseLocked == true and consoleEnabled == false then
		UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
	else
		UserInputService.MouseBehavior = Enum.MouseBehavior.Default
	end

	currentCamera.CFrame = CFrame.new(position)

	local mouseDelta = UserInputService:GetMouseDelta()
	local mouseSensitivity = UserSettings().GameSettings.MouseSensitivity * cvars.cl.Sensitivity
	local ySize = size.Y / 2

	xRotation += math.rad((mouseDelta.X * 0.5) * mouseSensitivity * -1)
	yRotation += math.rad((mouseDelta.Y * 0.5) * mouseSensitivity * -1)

	yRotation = math.clamp(yRotation, math.rad(-clamp), math.rad(clamp))

	local cameraRotate = (currentCamera.CFrame + currentCamera.CFrame.UpVector * ySize)
		* CFrame.fromEulerAnglesYXZ(yRotation, xRotation, 0)

	currentCamera.CFrame = cameraRotate - cameraRotate.LookVector * cvars.cl.CameraOffset
end

return {
	system = camera,
	phase = phases.Heartbeat,
}
