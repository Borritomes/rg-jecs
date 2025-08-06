local ReplicatedStorage = game:GetService("ReplicatedStorage")

local cts = require(ReplicatedStorage.Shared.cts)
local jecs = require(ReplicatedStorage.Packages.jecs)
local phases = require(ReplicatedStorage.Shared.phases)
local routes = require(ReplicatedStorage.Shared.routes)
local world = require(ReplicatedStorage.Shared.world)

local entityMap = {} :: { [jecs.Entity]: jecs.Entity }

local function getFromMap(world: jecs.World, id)
	if entityMap[id] == nil then
		if world:has(id, jecs.Name) then
			entityMap[id] = world:entity(id)
		else
			entityMap[id] = world:entity()
		end
	end

	return entityMap[id]
end

local function makeAlive(world: jecs.World, id)
	local rel = jecs.ECS_PAIR_FIRST(id)
	local tgt = jecs.ECS_PAIR_SECOND(id)

	rel = getFromMap(world, rel)
	tgt = getFromMap(world, tgt)

	return jecs.pair(rel, tgt)
end

local function receiveReplication()
	for pos, sender, changes in routes.replicate:query():iter() do
		for entity, components in changes.changed do
			if entityMap[entity] == nil then
				entityMap[entity] = world:entity()
			end

			for component, value in components :: { [jecs.Id | "tags"]: any } do
				if type(component) == "string" then
					for i, tag in value do
						world:add(entityMap[entity], tag)
					end
				elseif jecs.IS_PAIR(component) then
					local pair = makeAlive(world, component)

					world:set(entityMap[entity], pair, value)
				else
					world:set(entityMap[entity], component, value)
				end
			end
		end

		for entity, components in changes.removed do
			if entityMap[entity] ~= nil then
				for component: jecs.Id | "tags", value in components do
					if component == "tags" then
						for i, tag in value do
							world:remove(entity, tag)
						end
					else
						world:remove(entity, component)
					end
				end
			else
				warn("can't remove components from entity nil")
			end
		end
	end
end

return {
	system = receiveReplication,
	phase = phases.Replication,
}
