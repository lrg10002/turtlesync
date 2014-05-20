
--[[
	Startup file. Runs on startup, calls main to load libraries, and may check for updates.
]]

os.loadAPI(".lrg/main")
main = _G.main
_G.main = nil

main.init()

if lrg.getConfigOptions().checkForUpdatesOnStartup then
	shell.run(".lrg/update")
end