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

protocol = "lrg_builder_"..buildId

rednet.host(protocol, "lrg_builder_hostname_"..tostring(os.getComputerID()))

toBuild = {}
serverId = 0
build = true

function build()
	for h=1,#toBuild do
		row = toBuild[h]
		for i=1,#row do
			checkBuild()
			b = row:sub(i,i)
			if b == 0 then 
				turtle.tryForward()
			else
				turtle.select(tonumber(b))
				if turtle.getItemCount(turtle.getSelectedSlot()) < 1 then
					build = false
					rednet.send(serverId, "@EMPTYSLOT", protocol)
					checkBuild()
				end
				turtle.placeDown()
				if b ~= #row then turtle.tryForward() end
			end
		end
		turtle.tryUp()
		turtle.turnAround()
	end
end

function gatherInfo()
	while true do
		id, mess = rednet.receive(protocol)
		if mess=="@STARTINST" then
			serverId = id
			while true do
				id, mess = rednet.receive(protocol)
				if mess=="@ENDINST" then break end
				table.insert(toBuild, mess)
			end
			break
		end
	end
end

function checkBuild()
	while not build do
		sleep(1)
	end
end

gatherInfo()

function gatherMessages()
	while true do
		id, mess = rednet.receive(protocol)
		if mess=="@STOPBUILD" then build = false end
		if mess=="@STARTBUILD" then build = true end
	end
end

parallel.waitForAny(gatherMessages, build)




