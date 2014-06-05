--[[
	This is the client-side network api. Called when net api method "connect()" is called
]]


--buildConnectionTable(NUMBER nid): builds and returns an "object" for dealing with a specific connection (client)
function buildConnectionTable(nid)
	ct = {}

	local id = nid
	local mqueue = Queue.create()
	local listening = true

	local function update(sid, mess, prot)
		mqueue.push({["id"]=sid, ["protocol"]=prot, ["message"]=sid})
	end

	co = coroutine.create(function()
		while listening do
			event = {os.pullEventRaw()}
			if event ~= nil and event[1] == "rednet_message" then update(event[2], event[3], event[4]) end
		end
	end)


	function ct.close()
		listening = false
		coroutine.resume(co)
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

	coroutine.resume(co)

	return ct
end
