local m,s,o
local SYS  = require "luci.sys"

m = Map("flowoffload")
m.title	= translate("Flow Offload Settings")
m.description = translate("Opensource Linux Flow Offload driver (HWNAT/Fast Path)")
m:append(Template("flowoffload/status"))

s = m:section(TypedSection, "flow")
s.addremove = false
s.anonymous = true

flow = s:option(Flag, "flow_offloading", translate("Flow Offload"))
flow.default = 0
flow.rmempty = false
flow.description = translate("Software flow offloading (decrease cpu load / increase routing throughput)")

hw = s:option(Flag, "flow_offloading_hw", translate("HWNAT"))
hw.default = 0
hw.rmempty = true
hw.description = translate("Hardware flow offloading (depends on hardware capability, such as MTK 762x)")
hw:depends("flow_offloading", 1)

bbr = s:option(Flag, "bbr", translate("BBR Acceleration"))
bbr.default = 0
bbr.rmempty = false
bbr.description = translate("Bottleneck Bandwidth and Round-trip propagation time (BBR) Acceleration")

dns = s:option(Flag, "dns", translate("DNS Acceleration"))
dns.default = 0
dns.rmempty = false
dns.description = translate("DNS Cache Acceleration and anti DNS Cache Poisoning")

o = s:option(Value, "dns_server", translate("Upstream DNS Servers"))
o.default = "114.114.114.114,114.114.115.115"
o.description = translate("Multiple DNS servers can be seperated with ','")
o:depends("dns", 1)

return m
