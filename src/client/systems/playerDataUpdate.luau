local ReplicatedStorage = game:GetService("ReplicatedStorage")

local createAction = require(ReplicatedStorage.Shared.utils.createAction)
local phases = require(ReplicatedStorage.Shared.phases)
local removeAction = require(ReplicatedStorage.Shared.utils.removeAction)
local routes = require(ReplicatedStorage.Shared.routes)

local function playerDataUpdate()
	for pos, sender, changes in routes.playerData:query():iter() do
		if changes.bindings ~= nil then
			for keycode, commands in changes.bindings do
				if keycode == "__removed" then
					for i, keycode in commands do
						removeAction(keycode)
					end
					continue
				end
				for _, command in commands do
					createAction(keycode, command)
				end
			end
		end
	end
end

return {
	system = playerDataUpdate,
	phase = phases.Replication,
}
