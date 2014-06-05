
function buildServerTable(host)
	ct = {}

	local mqueue = Queue.create()
	local listening = true

	local function update(sid, mess, prot)
		reply = function(mess, prot)
			if not prot then
				rednet.send(sid, mess)
			else
				rednet.send(sid, mess, prot)
			end
		end
		mqueue.push({["id"]=sid, ["protocol"]=prot, ["message"]=sid, ["reply"] = reply})
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


	function ct.read(prot)
		if prot then
			while true do
				m = mqueue.poll()
				if m.protocol == prot then 
					return mqueue.pop()
				end
			end
		else
			return mqueue.pop()
		end
	end

	function ct.available()
		return mqueue.length() > 0
	end

	coroutine.resume(co)

	return ct
end