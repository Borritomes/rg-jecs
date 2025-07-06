local ReplicatedStorage = game:GetService("ReplicatedStorage")

local cmd = require(ReplicatedStorage.Client.cmd)

return {} :: { [Player]: { cmdBuffer: { cmd.cmd } } }
