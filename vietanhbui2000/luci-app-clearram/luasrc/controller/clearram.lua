module("luci.controller.clearram",package.seeall)

function index()
	entry({"admin","status","clearram"}, call("clearram"), _("Clear RAM"), 9999)
end
function clearram()
	luci.sys.call("sync && echo 3 > /proc/sys/vm/drop_caches")
	luci.http.redirect(luci.dispatcher.build_url("admin/status"))
end
