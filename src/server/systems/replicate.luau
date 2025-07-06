--!nonstrict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local cts = require(ReplicatedStorage.Shared.cts)
local jecs = require(ReplicatedStorage.Shared.jecs)
local phases = require(ReplicatedStorage.Shared.phases)
local routes = require(ReplicatedStorage.Shared.routes)
local tablekit = require(ReplicatedStorage.Packages.tablekit)
local world = require(ReplicatedStorage.Shared.world)

local previousSnapshot = {} :: {}
table.freeze(previousSnapshot)

local function replicate()
	local snapshot = {}
	local removed = tablekit.DeepCopy(previousSnapshot)
	local changes = {
		removed = {},
		changed = {},
	}

	for component in world.component_index do
		local isTag = jecs.is_tag(world, component)
		local isPair = jecs.IS_PAIR(component)

		for entity, value in world:query(component):with(cts.Replicate) do
			snapshot[entity] = snapshot[entity] or {}

			if isTag == true then
				snapshot[entity]["tags"] = snapshot[entity]["tags"] or {}

				table.insert(snapshot[entity]["tags"], component)

				if removed[entity] and removed[entity]["tags"] then
					table.remove(removed[entity]["tags"], table.find(removed[entity]["tags"], component))
				end

				if
					previousSnapshot[entity] == nil
					or previousSnapshot[entity]["tags"] == nil
					or table.find(previousSnapshot[entity]["tags"], component) == nil
				then
					changes.changed[entity] = changes.changed[entity] or {}
					changes.changed[entity]["tags"] = changes.changed[entity]["tags"] or {}

					table.insert(changes.changed[entity]["tags"], component)
				end
			elseif isPair == true then
				local pair = {
					relationship = jecs.pair_first(world, component),
					target = jecs.pair_second(world, component),
					value = value,
				}

				snapshot[entity][component] = pair

				if removed[entity] and removed[entity][component] then
					removed[entity][component] = nil
				end

				if
					previousSnapshot[entity] == nil
					or previousSnapshot[entity][component] == nil
					or previousSnapshot[entity][component] ~= snapshot[entity][component]
				then
					changes.changed[entity] = changes.changed[entity] or {}
					changes.changed[entity][component] = changes.changed[entity][component] or {}

					changes.changed[entity][component] = pair
				end
			else
				snapshot[entity][component] = value

				if removed[entity] and removed[entity][component] then
					removed[entity][component] = nil
				end

				---DEBUG
				if false then
					if previousSnapshot[entity] == nil then
						print "1"
						continue
					end
					if previousSnapshot[entity][component] == nil then
						print "2"
						continue
					end
					if previousSnapshot[entity][component] ~= snapshot[entity][component] then
						print "3"
					end
				end
				---DEBUG

				if
					previousSnapshot[entity] == nil
					or previousSnapshot[entity][component] == nil
					or previousSnapshot[entity][component] ~= snapshot[entity][component]
				then
					changes.changed[entity] = changes.changed[entity] or {}
					changes.changed[entity][component] = changes.changed[entity][component] or {}

					changes.changed[entity][component] = value
				end
			end
		end
	end

	changes.removed = removed
	--TODO: dont send if there are no changes
	routes.replicate:send(changes)
	--previousSnapshot = snapshot
	--table.freeze(previousSnapshot)
end

return {
	system = replicate,
	phase = phases.Replication,
}
