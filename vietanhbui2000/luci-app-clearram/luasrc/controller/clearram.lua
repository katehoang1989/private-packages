module("luci.controller.clearram",package.seeall)

function index()
	entry({"admin","services","clearram"}, call("clearram"), _("Clear RAM"), 9998)
end
function clearram()
	luci.sys.call("sync && echo 3 > /proc/sys/vm/drop_caches")
	luci.http.redirect(luci.dispatcher.build_url("admin/status/overview"))
end
