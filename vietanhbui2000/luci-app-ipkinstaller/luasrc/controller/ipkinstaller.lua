
module("luci.controller.ipkinstaller", package.seeall)

function index()
	entry({"admin", "services", "ipkinstaller"}, form("installer"), _("IPK Installer"), 9997)
end
