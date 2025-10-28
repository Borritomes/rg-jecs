--!nolint FunctionUnused
--!nolint LocalShadow
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local changeCmd = require(ReplicatedStorage.Shared.utils.changeCmd)
local config = require(ReplicatedStorage.Client.config)
local routes = require(ReplicatedStorage.Shared.routes)

type command = {
	name: string,
	run: (...any) -> (),
	protection: "none" | "cheat" | "dev",
	context: "client" | "server",
	args: { { name: string, type: string } }?,
}
type commandQueue = { { command: command?, args: { any } } }

local isServer = RunService:IsServer()

local commands = {}
commands.registered = {}

function commands.stringToType(value: string, Type: string): (boolean, any)
	if Type == "number" then
		local convertedValue = tonumber(value)

		if convertedValue ~= nil then
			return true, convertedValue
		else
			return false
		end
	end
	if Type == "string" then
		return true, value
	end
	if Type == "boolean" then
		if value == "true" or value == "1" then
			return true, true
		elseif value == "false" or value == "0" then
			return true, false
		else
			return false
		end
	end

	return false
end

function commands.registerCommand(command: command)
	commands.registered[command.name] = command
end

function commands.createCommand(props: command): command
	return {
		name = props.name,
		run = props.run,
		context = props.context,
		protection = props.protection,
		args = props.args,
	}
end

function commands.createCmdCommand(name): command
	commands.registered["-" .. name] = {
		name = name,
		run = function()
			changeCmd(name, -1)
		end,
		context = "client",
		protection = "none",
	}

	return {
		name = "+" .. name,
		run = function()
			changeCmd(name, 1)
		end,
		context = "client",
		protection = "none",
	}
end

local function getCommand(name: string): command?
	if commands.registered[name] ~= nil then
		return commands.registered[name]
	elseif config.aliases[name] ~= nil then
		local ok, queue = commands.evaluate(config.aliases[name])

		if ok == true and typeof(queue) ~= "string" then
			return {
				name = name,
				run = function()
					commands.executeQueue(queue)
				end,
				protection = "none",
				context = "client",
			}
		else
			return nil
		end
	end

	return nil
end

function commands.evaluate(text: string): (boolean, string | commandQueue)
	if text == nil or text == "" then
		return false, "no command given"
	end
	local textLength = text:len()
	if textLength > 512 then
		return false, "max command length is 512"
	end
	local currentCommand = nil :: command?
	local expect: "command" | "argument" = "command"
	local isInDoubleQuotes = false
	local currentWord = ""
	local currentArgConstruct = ""
	local arguments = {}

	local queue = {} :: { { command: command?, args: { any } } }

	for i = 1, textLength do
		local char = text:sub(i, i)

		if isInDoubleQuotes == true then
			if char == '"' then
				isInDoubleQuotes = false
				table.insert(arguments, currentArgConstruct)
				currentArgConstruct = ""

				if i == textLength then
					local commandResult = getCommand(currentWord)
					if commandResult == nil then
						return false, "unkown command " .. currentWord
					end

					currentCommand = commandResult

					expect = "argument"
					table.insert(queue, { command = currentCommand, args = arguments })
				end
			else
				currentArgConstruct ..= char
			end
		else
			if char == " " or char == ";" or i == textLength then
				if i == textLength and char ~= " " and char ~= ";" then
					currentWord ..= char
				end
				if expect == "command" and currentWord ~= "" then
					local commandResult = getCommand(currentWord)
					if commandResult == nil then
						return false, "unkown command " .. currentWord
					end

					currentCommand = commandResult

					expect = "argument"
					currentWord = ""
				else
					if currentWord ~= "" then
						table.insert(arguments, currentWord)
						currentWord = ""
					end
				end
				if char == " " then
				end
				if char == ";" or i == textLength then
					expect = "command"
					table.insert(queue, { command = currentCommand, args = arguments })
					currentCommand = nil
					arguments = {}
					isInDoubleQuotes = false
					currentWord = ""
					currentArgConstruct = ""
				end
			elseif char == '"' then
				isInDoubleQuotes = true
			else
				currentWord ..= char
			end
		end
	end

	return true, queue
end

function commands.executeQueue(queue: commandQueue): boolean
	for i, value in queue do
		if value.command then
			if isServer or value.command.context == "client" and value.command.protection == "none" then
				value.command.run(table.unpack(value.args))
			else
				routes.command:send(value.command.name, value.args)
			end
		else
			return false
		end
	end

	return true
end

function commands.executeSingle(command: string, args: { any }?, player: Player?)
	local command = commands.registered[command]
	if command == nil then
		return
	end
	if typeof(player) ~= "Instance" then
		return
	end

	if args ~= nil then
		command.run(player, table.unpack(args))
	else
		command.run(player)
	end
end

function commands.execute(text: string)
	local ok, result = commands.evaluate(text)
	if ok == false then
		return result
	end
	if typeof(result) ~= "string" then
		ok = commands.executeQueue(result)
		if ok == false then
			return "internal error"
		end

		return "] " .. text
	else
		return result
	end
end

return commands
