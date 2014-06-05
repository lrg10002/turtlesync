
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



--FUNCTION serverUpdateFunctions: the update function for the current server
local serverUpdateFunction = nil

--API client: the loaded client api
local client = nil

--API server: the loaded server api
local server = nil

--load(): Called by the LrgLib main file when loading the library.
function load()
	os.loadAPI(".lrg/libraries/netclient")
	client = _G["netclient"]
	_G["netclient"] = nil

	os.loadAPI(".lrg/libraries/netserver")
	server = _G["netserver"]
	_G["netserver"] = nil
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

--checkRednet(): checks the rednet connection
local function checkRednet()
	ms = getModem()
	if ms == nil then error("[LrgLib] lrg.net: No modem found when attempting to connect!") end
	if not rednet.isOpen(ms) then
		rednet.open(ms)
	end
end


--[[
 //////////////////////////////////////////////////////////////////////////////////////////////////////////////
 ///////////////////////////////////////////API FUNCTIONS/////////////////////////////////////////////////////
 ////////////////////////////////////////////////////////////////////////////////////////////////////////////
]]


--connect(STRING host): called by the user to connect to a hostname
function connect(host)
	checkRednet()

	nid = rednet.lookup("lrg_host_lookup", host)
	if nid == nil then return nil end

	return client.buildConnectionTable(nid)
end


--startServer(STRING host): registers a hostname-lookup for the current computer with the specified hostname, and returns a server-side listener
function startServer(host)
	checkRednet()
	rednet.host("lrg_host_lookup", host)
	return server.buildServerTable(host)
end