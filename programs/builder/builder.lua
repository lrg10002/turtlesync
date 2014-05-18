args = {...}

if not args or #args < 1 then
	error("Check arguments!")
end

if not lrg then
	error("LrgLib not found! Please install it!")
end

if not turtle then
	error("This is the turtle-side script! Please install on a turtle!")
end

sides = {"left","right"}
modemSide = nil

for _,s in ipairs(sides) do
	if peripheral.getType(s)=="modem" then
		modemSide = s
		break
	end
end

if not modemSide then
	error("This turtle must be equipt with a modem!")
end

rednet.open(modemSide)

buildId = args[1]

rednet.host("lrg_builder_"..buildId, "lrg_builder_hostname_"..tostring(os.getComputerID()))

toBuild = {}

function build()
	for h=1,#toBuild do
		row = toBuild[h]
		for i=1,#row do
			b = row:sub(i,i)
			if b == 0 then 
				turtle.tryForward()
			else
				turtle.select(tonumber(b))
				turtle.placeDown()
				if b ~= #row then turtle.tryForward() end
			end
		end
		turtle.tryUp()
		turtle.turnAround()
	end
end