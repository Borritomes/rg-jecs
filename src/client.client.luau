--!nonstrict
local ContextActionService = game:GetService("ContextActionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")

local YetAnotherNet = require(ReplicatedStorage.Packages.YetAnotherNet)
local cts = require(ReplicatedStorage.Shared.cts)
local cvars = require(ReplicatedStorage.Shared.cvars)
local jabby = require(ReplicatedStorage.Packages.jabby)
local pipelines = require(ReplicatedStorage.Shared.pipelines)
local routes = require(ReplicatedStorage.Shared.routes)
local scheduler = require(ReplicatedStorage.Shared.scheduler)
local world = require(ReplicatedStorage.Shared.world)

StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)

local client = jabby.obtain_client()

local function createWidget(_, state: Enum.UserInputState)
	if state ~= Enum.UserInputState.Begin then
		return
	end
	client.spawn_app(client.apps.home :: any, nil)
end

ContextActionService:BindAction("Open Jabby Home", createWidget, false, Enum.KeyCode.LeftAlt)

local timeRemaining = 1 / cvars.TickRate
local isNetFrameActive = false
local systems = {}

local function addSystems(folder)
	for _, system in folder:GetChildren() do
		if not system:IsA("ModuleScript") then
			continue
		end

		table.insert(systems, require(system))
	end
end

addSystems(ReplicatedStorage.Shared.systems)
addSystems(ReplicatedStorage.Client.systems)

--set current tick to server's or zero idk
local beginFrame, endFrame = YetAnotherNet.createHook(routes)

scheduler
	:insert(pipelines.Heartbeat, RunService, "Heartbeat")
	:insert(pipelines.FixedUpdate)
	:addSystems(systems)
	:run(pipelines.Heartbeat)

RunService.Heartbeat:Connect(function(deltaTime)
	--[[local tickAdjustment = world:get(cts.TickAdjustment, cts.TickAdjustment) or {
		pause = 0,
		fastForward = 0,
	}]]
	local tickAdjustment = {
		pause = 0,
		fastForward = 0,
	}

	local tickRate = cvars.TickRate
	local pause = tickAdjustment.pause

	if isNetFrameActive == false then
		beginFrame()
		isNetFrameActive = true
	end
	if pause == 0 then
		local fastForward = tickAdjustment.fastForward
		timeRemaining -= deltaTime

		--[[
			tailScaledTime += deltaTime
			accumulator += deltaTime
	
			-- Get stepCount.
			local stepCount = 0 -- ~ 1 to 2 at 60fps.
			while accumulator >= timeStep do
				accumulator -= timeStep
				stepCount += 1
			end
		]]
		local queuedTicks = 0
		if timeRemaining < 0 then
			queuedTicks += math.floor((timeRemaining * tickRate) * -1)
			timeRemaining = (1 / tickRate) - timeRemaining

			queuedTicks += 1
		end

		if queuedTicks > 0 then
			for count = 0, (queuedTicks + fastForward) - 1 do
				world:set(cts.Tick, cts.Tick, (world:get(cts.Tick, cts.Tick) or 0) + 1)
				scheduler:run(pipelines.FixedUpdate)
			end
			world:set(cts.TickAdjustment, cts.TickAdjustment, { fastForward = 0, pause = pause })
			endFrame()
			isNetFrameActive = false
		end
	elseif pause > 0 then
		warn("paused")
		world:set(cts.TickAdjustment, cts.TickAdjustment, {
			fastForward = tickAdjustment.fastForward,
			pause = pause - 1,
		})
	else
		print(`pause {pause} is negative`)
	end
end)
