local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local cvars = require(ReplicatedStorage.Shared.cvars)
local phases = require(ReplicatedStorage.Shared.phases)
local world = require(ReplicatedStorage.Shared.world)

local player = Players.LocalPlayer
local xRotation = 0
local yRotation = 0

local function camera()
	local currentCamera = workspace.CurrentCamera

	if currentCamera.CameraType ~= Enum.CameraType.Scriptable then
		currentCamera.CameraType = Enum.CameraType.Scriptable
	end
	currentCamera.FieldOfView = cvars.fov

	local clamp = cvars.CameraClampY
	local mouseLocked = cvars.MouseLocked

	if mouseLocked == true then
		UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
	elseif mouseLocked == false then
		UserInputService.MouseBehavior = Enum.MouseBehavior.Default
	end

	currentCamera.CFrame = CFrame.new(0, 0, 0)

	local mouseDelta = UserInputService:GetMouseDelta()
	local mouseSensitivity = UserSettings().GameSettings.MouseSensitivity * cvars.Sensitivity
	--local ySize = world:get(entity, cts.Size).Y / 2 or 1

	xRotation += math.rad((mouseDelta.X * 0.5) * mouseSensitivity * -1)
	yRotation += math.rad((mouseDelta.Y * 0.5) * mouseSensitivity * -1)

	yRotation = math.clamp(yRotation, math.rad(-clamp), math.rad(clamp))

	--local cameraRotate = (currentCamera.CFrame + currentCamera.CFrame.UpVector * ySize)
	--	* CFrame.fromEulerAnglesYXZ(yRotation, xRotation, 0)
	local cameraRotate = currentCamera.CFrame * CFrame.fromEulerAnglesYXZ(yRotation, xRotation, 0)

	local offset = 1
	currentCamera.CFrame = cameraRotate - cameraRotate.LookVector * offset
end

return {
	system = camera,
	phase = phases.Heartbeat,
}
