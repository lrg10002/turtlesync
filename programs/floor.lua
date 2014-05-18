
args = {...}

width = tonumber(args[1])
length = tonumber(args[2])

local function pause()
	term.clear(); term.setCursorPos(1,1)
	print("Out of materials! Waiting for more...")
	print("Refill and press any key to continue...")
	print("Progress will be saved.")
	os.pullEvent("key")
end

for x=1,width do
	for y=1,length do
		if turtle.getItemCount(turtle.getSelectedSlot()) < 1 then
			if turtle.getSelectedSlot() == 16 then
				pause()
				turtle.select(1)
			else
				turtle.select(turtle.getSelectedSlot()+1)
			end
		end

		turtle.placeDown()
		if x~=width then turtle.forward() end
	end

	if x%2 == 0 then
		turtle.turnLeft()
		turtle.forward()
		turtle.turnLeft()
	else
		turtle.turnRight()
		turtle.forward()
		turtle.turnRight()
	end
end