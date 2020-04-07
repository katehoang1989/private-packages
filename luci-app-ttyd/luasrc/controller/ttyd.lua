module("luci.controller.ttyd", package.seeall)

function index()
	if not (luci.sys.call("pidof ttyd > /dev/null") == 0) then
		return
	end
	
	entry({"admin", "services", "ttyd"}, template("ttyd"), _("ttyd"), 10).leaf = true
end
