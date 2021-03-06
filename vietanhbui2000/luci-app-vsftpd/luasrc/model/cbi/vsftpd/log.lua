--[[
LuCI - Lua Configuration Interface

Copyright 2016 Weijie Gao <hackpascal@gmail.com>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0
]]--

m = Map("vsftpd", translate("vsftpd - Log Settings"))

sl = m:section(NamedSection, "log", "log", translate("Log Settings"))

o = sl:option(Flag, "syslog", translate("Enable sys log"))
o.default = false

o = sl:option(Flag, "xreflog", translate("Enable log file"))
o.default = true

o = sl:option(Value, "file", translate("Log file"))
o.default = "/var/log/vsftpd.log"


return m
