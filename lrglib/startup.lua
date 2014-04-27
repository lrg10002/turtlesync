
--[[
	Startup file. Runs on startup, calls main to load libraries, and may check for updates.
]]

os.loadApi(".lrg/main")
main = _G.main
_G.main = nil

main.init()