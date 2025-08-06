--!nonstrict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local ServerScriptService = game:GetService("ServerScriptService")

local YetAnotherNet = require(ReplicatedStorage.Packages.YetAnotherNet)
local _jabby = require(ReplicatedStorage.Packages.jabby)
local cts = require(ReplicatedStorage.Shared.cts)
local cvars = require(ReplicatedStorage.Shared.cvars)
local pipelines = require(ReplicatedStorage.Shared.pipelines)
local replecs = require(ReplicatedStorage.Packages.replecs)
local routes = require(ReplicatedStorage.Shared.routes)
local scheduler = require(ReplicatedStorage.Shared.scheduler)
local world = require(ReplicatedStorage.Shared.world)

local replicator = replecs.create(world).server
replicator:init()

local timeRemaining = 1 / cvars.TickRate
local isNetFrameActive = false
local systems = {}

local function addSystems(folder: Folder)
	if folder:GetChildren() == {} then
		return
	end
	for _, system in folder:GetDescendants() do
		if not system:IsA("ModuleScript") then
			continue
		end

		table.insert(systems, require(system))
	end
end

addSystems(ReplicatedStorage.Shared.systems)
addSystems(ServerScriptService.Server.systems)

--set current tick to server's or zero idk
local beginFrame, endFrame = YetAnotherNet.createHook(routes)

scheduler
	:insert(pipelines.Heartbeat, RunService, "Heartbeat")
	:insert(pipelines.FixedUpdate)
	:addSystems(systems)
	:run(pipelines.Heartbeat)

RunService.Heartbeat:Connect(function(deltaTime)
	local tickRate = cvars.TickRate

	timeRemaining -= deltaTime

	if isNetFrameActive == false then
		beginFrame()
		isNetFrameActive = true
	end
	local queuedTicks = 0
	if timeRemaining < 0 then
		queuedTicks += math.floor((timeRemaining * tickRate) * -1)
		timeRemaining = (1 / tickRate) - timeRemaining

		queuedTicks += 1
	end

	if queuedTicks > 0 then
		for count = 0, queuedTicks - 1 do
			world:set(cts.Tick, cts.Tick, (world:get(cts.Tick, cts.Tick) or 0) + 1)
			scheduler:run(pipelines.FixedUpdate)
			endFrame()
			isNetFrameActive = false
		end
	end

	--print(world:get(cts.Tick, cts.Tick))
end)
