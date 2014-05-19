
args = {...}

tWidth = 0
tLength = 0

local function pause(x,y)
	fhand = fs.open(".floorProg", "w")
	fhand.write(textutils.serialize({["x"]=x, ["y"]=y, ["w"]=tWidth, ["l"]=tLength}))
	fhand.close()
	term.clear(); term.setCursorPos(1,1)
	print("Out of materials! Waiting for more...")
	print("Refill and press any key to continue...")
	print("Progress will be saved.")
	os.pullEvent("key")
end

local function findNextOpenSlot(x,y)
	if turtle.getItemCount(turtle.getSelectedSlot()) < 1 then
		if turtle.getSelectedSlot() == 16 then
			pause(x,y)
			turtle.select(1)
		else
			turtle.select(turtle.getSelectedSlot()+1)
			findNextOpenSlot()
		end
	end
end


function run(x,y,width,length)
	tWidth = width
	tLength = length
	for x=1,width do
		for y=1,length do
			findNextOpenSlot(x,y)
			turtle.placeDown()
			if y~=length then turtle.forward() end
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
end

if args[1]=="resume" then
	fhand = fs.open(".floorProg", "r")
	conts = fhand.readAll()
	fhand.close()
	res = textutils.unserialize(conts)
	run(res.x, res.y, res.w, res.l)
	return
end

width = tonumber(args[1])
length = tonumber(args[2])

run(1,1,width,length)