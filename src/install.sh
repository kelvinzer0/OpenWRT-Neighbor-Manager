#!/bin/sh

set -e

echo "Mulai instalasi luci-neighbor-manager..."

# 1. Buat folder konfigurasi
mkdir -p /etc/config

# 2. Buat file config neighbor_manager
cat > /etc/config/neighbor_manager <<EOF
config neighbor
    option ip6addr '2a0e:b107:384:ee25::555'
    option macaddr '00:06:08:10:0a:2e'
    option ifname 'br-lan'
EOF

# 3. Buat init script di /etc/init.d/neighbor_manager
cat > /etc/init.d/neighbor_manager <<'EOF'
#!/bin/sh /etc/rc.common

START=95
STOP=10

start() {
    config_load neighbor_manager
    config_foreach add_neighbor neighbor
}

add_neighbor() {
    ip6addr=$(config_get "$1" ip6addr)
    macaddr=$(config_get "$1" macaddr)
    ifname=$(config_get "$1" ifname)

    # Tambah neighbor IPv6 statis
    ip -6 neigh add "$ip6addr" lladdr "$macaddr" dev "$ifname" 2>/dev/null || true
}
EOF

chmod +x /etc/init.d/neighbor_manager

# 4. Enable init script agar jalan saat boot
/etc/init.d/neighbor_manager enable

# 5. Jalankan sekarang juga
/etc/init.d/neighbor_manager start

# 6. Pasang modul LuCI neighbor manager (bisa dengan file minimal Lua CBI) di /usr/lib/lua/luci/model/cbi/neighbor_manager.lua
mkdir -p /usr/lib/lua/luci/model/cbi

cat > /usr/lib/lua/luci/model/cbi/neighbor_manager.lua <<'EOF'
m = Map("neighbor_manager", "Neighbor Manager")

s = m:section(TypedSection, "neighbor", "IPv6 Neighbors")
s.anonymous = true
s.addremove = true

ip6 = s:option(Value, "ip6addr", "IPv6 Address")
ip6.datatype = "ip6addr"

mac = s:option(Value, "macaddr", "MAC Address")
mac.datatype = "macaddr"

ifname = s:option(Value, "ifname", "Interface")
ifname.default = "br-lan"

return m
EOF

# 7. Daftarkan modul LuCI agar muncul di menu (misal di menu admin -> Network)
mkdir -p /usr/lib/lua/luci/controller

cat > /usr/lib/lua/luci/controller/neighbor_manager.lua <<'EOF'
module("luci.controller.neighbor_manager", package.seeall)

function index()
    entry({"admin", "network", "neighbor_manager"}, cbi("neighbor_manager"), "Neighbor Manager", 60)
end
EOF

# 8. Restart LuCI agar modul baru muncul
/etc/init.d/uhttpd restart || true

echo "Instalasi selesai! Modul Neighbor Manager sudah aktif di LuCI pada menu Network."
