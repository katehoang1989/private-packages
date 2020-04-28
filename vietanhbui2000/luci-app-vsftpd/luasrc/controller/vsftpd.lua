--[[
LuCI - Lua Configuration Interface

Copyright 2016 Weijie Gao <hackpascal@gmail.com>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0
]]--

require("luci.sys")

module("luci.controller.vsftpd", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/vsftpd") then
		return
	end

	entry({"admin", "services"}, firstchild(), "Services", 10).dependent = false
	entry({"admin", "services", "vsftpd"},
		alias("admin", "services", "vsftpd", "general"),
		_("vsftpd"))

	entry({"admin", "services", "vsftpd", "general"},
		cbi("vsftpd/general"),
		_("General Settings"), 10).leaf = true

	entry({"admin", "services", "vsftpd", "virtualusers"},
		cbi("vsftpd/virtualusers"),
		_("Virtual Users"), 20).leaf = true

	entry({"admin", "services", "vsftpd", "anonymoususers"},
		cbi("vsftpd/anonymoususers"),
		_("Anonymous Users"), 30).leaf = true

	entry({"admin", "services", "vsftpd", "log"},
		cbi("vsftpd/log"),
		_("Log Settings"), 40).leaf = true

	entry({"admin", "services", "vsftpd", "item"},
		cbi("vsftpd/item"), nil).leaf = true
end
