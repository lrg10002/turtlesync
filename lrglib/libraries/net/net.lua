
--[[
	This is the official LrgLib net API. It is designed to make
networking in ComputerCraft so much simpler, with high-level,
easy-to-learn functions.
]]


--[[
 //////////////////////////////////////////////////////////////////////////////////////////////////////////////
 //////////////////////////////////////////LOCAL FUNCTIONS////////////////////////////////////////////////////
 ////////////////////////////////////////////////////////////////////////////////////////////////////////////
]]

--TABLE updateFunctions: a table which holds lists of all the update functions of all of the current connections
local updateFunctions = {}

--event(TABLE res): called by the overwritten pullEventRaw Method when a message is received
local function event(res)
	tof = updateFunctions[res[2]]
	if not tof then return end
	for _,v in pairs(tof) do
		v(res[2], res[3], res[4])
	end
end

--load(): Called by the LrgLib main file when loading the library.
function load()
	if type(os._lrg_pullEventRaw) == "function" then return end
	os._lrg_pullEventRaw = os.pullEventRaw
	os.pullEventRaw = function(filter)
		res = {os._lrg_pullEventRaw(filter)}
		if res[1]=="rednet_message" then event(res) end
		return unpack(res)
	end
end

--getModem(): returns the side of a modem (and opens if necessary)
local function getModem()
	sides = {"top", "bottom", "left", "right", "front", "back"}
	for _,v in ipairs(sides) do
		if peripheral.isPresent(v) then
			if peripheral.getType(v) == "modem" then
				return v
			end
		end
	end
	return nil
end

--buildConnectionTable(NUMBER nid): builds and returns an "object" for dealing with a specific connection
local function buildConnectionTable(nid)
	ct = {}

	local id = nid
	local mqueue = Queue.create()

	local function update(sid, mess, prot)
		mqueue.push({["id"]=sid, ["protocol"]=prot, ["message"]=sid})
	end


	if updateFunctions[id] == nil then 
		updateFunctions[id] = {}
		updateFunctions[id].nUID = 0
	end

	local nUID = updateFunctions[id].nUID
	updateFunctions[id][updateFunctions[id].nUID] = update
	updateFunctions[id].nUID = nUID + 1


	function ct.close()
		updateFunctions[id][nUID] = nil
	end


	function ct.send(message, protocol)
		if not protocol then 
			rednet.send(id, message) 
		else
			rednet.send(id, message, protocol)
		end		
	end

	function ct.read()
		return mqueue.pop()
	end

	function ct.available()
		return mqueue.length() > 0
	end

	return ct
end

--[[
 //////////////////////////////////////////////////////////////////////////////////////////////////////////////
 ///////////////////////////////////////////API FUNCTIONS/////////////////////////////////////////////////////
 ////////////////////////////////////////////////////////////////////////////////////////////////////////////
]]

--connect(STRING host): called by the user to connect to a hostname
function connect(host)
	ms = getModem()
	if not ms then error("[LrgLib] lrg.net: No modem found when attempting to connect!") end

	nid = rednet.lookup("lrg_host_lookup", host)
	if nid == nil then return nil end

	return buildConnectionTable(nid)
end


local hostname = nil

--register(STRING host): registers a hostname-lookup for the current computer with the specified hostname
function register(host)
	if hostname then rednet.unhost("lrg_host_lookup", hostname) end
	hostname = host
	rednet.host("lrg_host_lookup", host)
end

--unRegister(): unregisters the current computer from the current hostname
function unRegister()
	rednet.unhost("lrg_host_lookup", hostname)
end