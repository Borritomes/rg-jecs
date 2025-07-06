local ReplicatedStorage = game:GetService("ReplicatedStorage")

local cmd = require(ReplicatedStorage.Client.cmd)

return function(command: cmd.cmd?): (Vector3, boolean)
	local wishDir = Vector3.zero
	local wishJump = false

	if command == nil then
		return Vector3.zero, false
	end
	local lookVector = Vector3.zero
	local rightVector = Vector3.zero

	if command.cameraCFrame then
		lookVector = (command.cameraCFrame.LookVector * Vector3.new(1, 0, 1)).Unit
		rightVector = (command.cameraCFrame.RightVector * Vector3.new(1, 0, 1)).Unit
	end

	if command.forward ~= nil and command.forward.weight > 0 then
		wishDir += lookVector
	end
	if command.backward ~= nil and command.backward.weight > 0 then
		wishDir -= lookVector
	end
	if command.strafeLeft ~= nil and command.strafeLeft.weight > 0 then
		wishDir -= rightVector
	end
	if command.strafeRight ~= nil and command.strafeRight.weight > 0 then
		wishDir += rightVector
	end
	if command.jump ~= nil and command.jump.began == true then
		wishJump = true
	end

	if wishDir ~= Vector3.zero then
		wishDir = wishDir.Unit
	end

	return wishDir, wishJump
end
