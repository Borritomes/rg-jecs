local ReplicatedStorage = game:GetService("ReplicatedStorage")

local jecs = require(ReplicatedStorage.Shared.jecs)
local phases = require(ReplicatedStorage.Shared.phases)
local routes = require(ReplicatedStorage.Shared.routes)
local world = require(ReplicatedStorage.Shared.world)

local entityMap = {} :: { [jecs.Entity]: jecs.Entity }

local function receiveReplication()
	local componentIndex = world.component_index

	for pos, sender, changes in routes.replicated:query():iter() do
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
					local relationship = value.relationship
					local target = value.target

					if relationship == nil or target == nil or value.value == nil then
						warn("pair missing elements")
						continue
					end

					-- if relationship is an entity
					if componentIndex[relationship] == nil then
						if entityMap[relationship] ~= nil then
							relationship = entityMap[relationship]
						else
							entityMap[relationship] = world:entity()
							relationship = entityMap[relationship]
						end
					end
					-- if target is an entity
					if componentIndex[target] == nil then
						if entityMap[target] ~= nil then
							target = entityMap[target]
						else
							entityMap[target] = world:entity()
							target = entityMap[target]
						end
					end

					world:set(entityMap[entity], jecs.pair(relationship, target), value.value)
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
				warn("can't remove nil components")
			end
		end
	end
end

return {
	system = receiveReplication,
	phase = phases.Replication,
}
