local events = {}

function events.print(message: string, repeatFor: string)
	for i = 1, tonumber(repeatFor) or 1 do
		print(message)
	end
end

return events
