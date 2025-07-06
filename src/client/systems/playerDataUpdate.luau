local ReplicatedStorage = game:GetService("ReplicatedStorage")

local bind = require(ReplicatedStorage.Shared.commands.bind)
local phases = require(ReplicatedStorage.Shared.phases)
local routes = require(ReplicatedStorage.Shared.routes)
local unbind = require(ReplicatedStorage.Shared.commands.unbind)

local function playerDataUpdate()
	for pos, sender, changes in routes.playerData:query():iter() do
		if changes.bindings ~= nil then
			for keycode, commands in changes.bindings do
				if keycode == "__removed" then
					for i, keycode in commands do
						unbind.run(keycode)
					end
					continue
				end
				for _, command in commands do
					bind.run(keycode, command)
				end
			end
		end
	end
end

return {
	system = playerDataUpdate,
	phase = phases.Replication,
}
