--!nolint LocalShadow
--!nolint LocalUnused
--!nonstrict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

type command = {
	run: (...any) -> boolean,
	protection: "none" | "cheat" | "dev",
	args: { name: string, type: string }?,
}

local commands = {}

local function stringToType(value: string, Type: string): (boolean, any)
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

function commands.evaluate(text: string): (boolean, string | { { command: command?, args: { any } } })
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
					if script:FindFirstChild(currentWord) then
						currentCommand = require(script:FindFirstChild(currentWord))
					else
						return false, "unkown command " .. currentWord
					end
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
					if script:FindFirstChild(currentWord) then
						currentCommand = require(script:FindFirstChild(currentWord))
					else
						return false, "unkown command " .. currentWord
					end
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

function commands.executeQueue(queue: { { command: command?, args: { any } } }): boolean
	for i, value in queue do
		if value.command then
			value.command.run(table.unpack(value.args))
		else
			return false
		end
	end

	return true
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
