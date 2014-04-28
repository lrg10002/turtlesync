version = "0.1"
prefix = "https://raw.githubusercontent.com/lrg10002/turtlesync/master/"

function getPathParts(path)
    local sep, fields = "/", {}
    local pattern = string.format("([^%s]+)", sep)
    path:gsub(pattern, function(c) fields[#fields+1] = c end)
    return fields
end

function fail()
	print("> Installation did not finish because of errors.")
	error()
end

function installGithubFile(gpath, fpath)
	hand = http.get(prefix..gpath)
	fconts = hand.readAll(); hand.close()
	if fpath:find("/") then
		parts = getPathParts(fpath)
		cp = ""
		for i,p in ipairs(parts) do
			if i == #parts then 
				cp = cp..p
				hand = fs.open(cp, "w")
				hand.write(fconts); hand.close()
			else
				cp = cp..p.."/"
				if not fs.exists(cp) then fs.makeDir(cp)
				elseif fs.exists(cp) and not fs.isDir(cp) then fs.delete(cp); fs.makeDir(cp) end
			end
		end
	else
		hand = fs.open(fpath, "w")
		hand.write(fconts); hand.close()
	end
end


req = http.get(prefix.."resources/version")
libVersion = req.readLine()
req.close()

term.clear(); term.setCursorPos(1,1)
print("==LrgLib installer version "..version.."==")
print("")
print("> Latest version of LrgLib: " .. libVersion)
print("> Checking for preexisting version...")
if lrg~=nil then
	print("> LrgLib version " .. lrg.getVersion().. "! Will not install; check for updates instead!")
	return
end

print ("> None exists. Gathering files to install...")
req = http.get(prefix.."installer/installInst")
fti = req.readAll()
req.close()

info = textutils.unserialize(fti)
fti = info.files

print("> Installing files...")
print("")

for k,v in pairs(fti) do
	if k=="startup" then
		if fs.exists("startup") then
			print("> Found existing startup file. Wrapping and renaming to \"startup1\"...")
			fs.move("startup","startup1")
			pes = fs.open("startup1", "r")
			conts = pes.readAll()
			pes.close()
			pes = fs.open("startup1", "w")
			pes.writeLine("--HOOK:STARTUP")
			pes.write(conts)
			pes.close()
		end
	end
	print("> Installing file \""..v.."\"...")
	local status, message = pcall(installGithubFile(v,k))
	if status then
		print("> File \""..v.."\" installed successfully.")
	else
		print("!> ERROR: File \""..v.."\" could not be installed!.")
		print("   " .. message)
		fail()
	end
end

print("")
print("> Installation was successful! Your OS will now reboot. Thanks for installing!")
os.sleep(2.5)
os.reboot()