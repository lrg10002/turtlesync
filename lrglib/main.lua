--VERSION:0.3.1

local function installTurtleLibraries()

	_G["turtle"].tryForward = function()
		while not turtle.forward() do
			turtle.attack()
			turtle.attack()
			turtle.attack()
			sleep(1)
		end
	end

	_G["turtle"].tryUp = function()
		while not turtle.up() do
			turtle.attackUp()
			turtle.attackUp()
			turtle.attackUp()
			sleep(1)
		end
	end

	_G["turtle"].turnAround = function(dir)
		if not dir then dir = "Left" end
		if dir ~= "Left" and dir ~= "Right" then dir = "Left" end

		turtle["turn"..dir]()
		turtle["turn"..dir]()
	end
end

local function installLibraries()
	lrg = {}
	lrg.split = function(str, sep)
		local sep, fields = ":", {}
    	local pattern = string.format("([^%s]+)", sep)
   	 	str:gsub(pattern, function(c) fields[#fields+1] = c end)
    	return fields
	end

	lrg.getFileTags = function(fp)
		local ft = {}
		hand = fs.open(fp, "r")
		while true do
			line = hand.readLine()
			if not line.match("\\-\\-.*") then break end
			tags = line.match("\\-\\-(.*)")
			for _,v in ipairs(lrg.split(tags, "|")) do
				local kv = lrg.split(v)
				ft[kv[1]] = kv[2]
			end
		end
		hand.close()
		return ft
	end

	lrg.getVersion = function()
		return lrg.getFileTags(shell.getRunningProgram())["VERSION"];
	end

	lrg.getGithubUrl = function(path)
		return "https://raw.githubusercontent.com/lrg10002/turtlesync/master/"..path
	end

	lrg.getConfigOptions = function()
		hand = fs.open(".lrg/config", "r")
		conts = hand.readAll()
		hand.close()
		return textutils.unserialize(conts)
	end

	_G["lrg"] = lrg
end


--[[
	Library function - used by startup only, to init
]]

function init()
	installLibraries()
	if _G["turtle"] ~= nil then
		installTurtleLibraries()
	end
end