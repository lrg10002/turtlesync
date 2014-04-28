
print("> Checking for updates...")
req = http.get(lrg.getGithubUrl("resources/version"))
libVersion = req.readLine()
req.close()

if libVersion ~= lrg.getVersion() then
	print("> Update found! Updating to version " .. libVersion .."!")
else
	print("> No updates were found.")
	return
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

print("> Getting file list...")
req = http.get(lrg.getGithubUrl("installer/installInst"))
fti = req.readAll()
req.close()
info = textutils.unserialize(fti)
fti = info.files

print("> Updating files...")
print("")

for k,v in pairs(fti) do
	print("> Updating local file \""..k.."\" to \"" .. v .. "\"...")
	local status, message = pcall(installGithubFile(v,k))
	if status then
		print("> File \""..v.."\" was updated successfully.")
	else
		print("!> ERROR: File \""..v.."\" could not be updated!.")
		print("   " .. message)
		fail()
	end
end

print("")
print("> Update complete. You are now using version " .. libVersion ..".")