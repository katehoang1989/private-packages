module("luci.controller.clearlucicache",package.seeall)

function index()
	entry({"admin","services","clearlucicache"}, call("clearlucicache"), _("Clear LuCI Cache"), 9999)
end

function clearlucicache()
	luci.sys.call("rm /tmp/luci-modulecache/* /tmp/luci-indexcache")
	luci.http.redirect(luci.dispatcher.build_url("admin/status/overview"))
end
