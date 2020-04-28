
module("luci.controller.ipkinstaller", package.seeall)

function index()
	entry({"admin", "services", "ipkinstaller"}, form("installer"), _("IPK Installer"), 96)
end
