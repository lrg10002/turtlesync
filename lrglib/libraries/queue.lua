
function create()

	values = {}

	amount = 0

	queue = {}

	function queue.push(obj)
		amount = amount + 1
		values[amount] = obj
	end

	function queue.pop()
		if amount==0 then return nil end

		ret = values[1]

		nvalues = {}

		if amount == 1 then
			values = {}
			amount = 0
			return ret
		end

		for x=2,amount do
			nvalues[x-1] = values[x]
		end

		values = nvalues

		amount = amount - 1

		return ret
	end

	function queue.length()
		return amount
	end

	return queue

end