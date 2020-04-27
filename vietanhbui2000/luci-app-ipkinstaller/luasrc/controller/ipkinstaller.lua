--[[
luci-app-filetransfer
Description: File upload / download
Author: yuleniwo  xzm2@qq.com  QQ:529698939
Modify: ayongwifi@126.com  www.openwrtdl.com
]]--

module("luci.controller.ipkinstaller", package.seeall)

function index()
	entry({"admin", "services", "ipkinstaller"}, form("installer"), _("IPK Installer"),89)
end
