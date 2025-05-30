local ReplicatedStorage = game:GetService("ReplicatedStorage")

local cts = require(ReplicatedStorage.Shared.cts)
local phases = require(ReplicatedStorage.Shared.phases)
local playerDataService = require(ReplicatedStorage.Shared.services.playerDataService)
local routes = require(ReplicatedStorage.Shared.routes)
local world = require(ReplicatedStorage.Shared.world)

local MIN_EXCEPTABLE_DATA = 2
local MAX_DATA_STORED = 5
local MIN_DIFFERENCE = 0
local MAX_DIFFERENCE = 10
local TICK_LEAD_TARGET = 4

local doDebugPrint = false

local function correctClientTick()
	local serverTick = world:get(cts.Tick, cts.Tick) or 0

	for pos, sender: Player, Tick: number, data: { adjustmentGeneration: number } in routes.adjustTick:query() do
		local tickDifference = Tick - serverTick
		--print(tickDifference)

		local adjustmentGeneration = playerDataService.get(sender.UserId, "adjustmentGeneration") or 0
		--if the client's generation is greater than the server's
		if adjustmentGeneration < data.adjustmentGeneration then
			playerDataService.set(sender.UserId, "adjustmentGeneration", data.adjustmentGeneration)
			adjustmentGeneration = data.adjustmentGeneration
			continue
		end

		local tickDifferenceHistory = playerDataService.get(sender.UserId, "tickDifferenceHistory")

		if #tickDifferenceHistory > MAX_DATA_STORED then
			playerDataService.removeFromTable(sender.UserId, "tickDifferenceHistory", 1)
		end

		playerDataService.addToTable(sender.UserId, "tickDifferenceHistory", tickDifference)

		if #tickDifferenceHistory <= MIN_EXCEPTABLE_DATA then
			continue
		end

		local averageDifference = 0
		local sum = 0

		for i = 1, #tickDifferenceHistory do
			sum += tickDifferenceHistory[i]
		end

		averageDifference = sum / #tickDifferenceHistory
		averageDifference = math.floor(averageDifference)

		if averageDifference >= MIN_DIFFERENCE and averageDifference <= MAX_DIFFERENCE then
			if doDebugPrint == true then
				print("synced")
			end
			continue
		end

		if tickDifferenceHistory[#tickDifferenceHistory] < TICK_LEAD_TARGET then
			--if theres a lag spike
			if
				tickDifferenceHistory[#tickDifferenceHistory]
				> tickDifferenceHistory[#tickDifferenceHistory - 1] + TICK_LEAD_TARGET
			then
				averageDifference = 0
			end
		end

		--warn(`Tick not synced {tickDifference}`)
		local difference = averageDifference - TICK_LEAD_TARGET
		local pause = 0
		local fastForward = 0
		--print(difference)
		if difference > 0 then
			--print("pause " .. difference * -1)
			pause = difference
		else
			--print("fastForward " .. difference)
			fastForward = difference * -1
		end

		if doDebugPrint == true then
			print "not synced"
		end
		routes.adjustTick
			:send({
				fastForward = fastForward,
				pause = pause,
				adjustmentGeneration = adjustmentGeneration,
			})
			:to(sender)
	end
end

return {
	system = correctClientTick,
	phase = phases.Heartbeat,
}
