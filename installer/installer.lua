version = "0.1"
prefix = "https://raw.githubusercontent.com/lrg10002/turtlesync/master/"
req = http.get(prefix.."resources/version")
libVersion = req.readLine()
req.close()

print("==LrgLib installer version "..version.."==")
print()
print("> Latest version of LrgLib: " .. libVersion)
print("> Checking for preexisting version...")
if lrg~=nil then
	print("> LrgLib version " .. lrg.getVersion().. "! Will not install!")
	return
end

print ("> None exists. Gathering files to install...")
req = http.get(prefix.."installer/installInst")
fti = req.readAll()
req.close()