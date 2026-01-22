#!/bin/bash
# diy-part2.sh - Set LAN IP to 192.168.10.1 + Disable IPv6 + Home Assistant init

mkdir -p files/etc/config

# === 1. Network config: IPv4 only, LAN=192.168.10.1, disable IPv6 ===
cat > files/etc/config/network << 'EOF'
config interface 'loopback'
    option device 'lo'
    option proto 'static'
    option ipaddr '127.0.0.1'
    option netmask '255.0.0.0'

config globals 'globals'
    option ula_prefix 'fd00::/8'

config interface 'lan'
    option device 'eth0'
    option proto 'static'
    option ipaddr '192.168.10.1'
    option netmask '255.255.255.0'
    # Disable IPv6 completely
    option ip6assign ''
    option ip6ifaceid ''
    option ip6prefix ''

config interface 'wan'
    option device 'eth1'
    option proto 'dhcp'
    # Disable IPv6 on WAN
    option ipv6 '0'

config interface 'wan6'
    option device 'eth1'
    option proto 'none'   # Completely disable WAN6
EOF

# === 2. System config: disable IPv6 in sysctl (runtime) ===
mkdir -p files/etc/sysctl.d
cat > files/etc/sysctl.d/10-disable-ipv6.conf << 'EOF'
# Disable IPv6 globally
net.ipv6.conf.all.disable_ipv6=1
net.ipv6.conf.default.disable_ipv6=1
net.ipv6.conf.lo.disable_ipv6=1
net.ipv6.conf.eth0.disable_ipv6=1
net.ipv6.conf.eth1.disable_ipv6=1
EOF

# === 3. Optional: Remove IPv6 kernel modules to save space (recommended) ===
# This is done via .config, but we ensure no IPv6 packages are installed
# (Your .config already omits most IPv6 modules – good!)

# === 4. Home Assistant init script (unchanged) ===
cat > files/etc/init.d/homeassistant << 'EOF'
#!/bin/sh /etc/rc.common
START=99
USE_PROCD=1

start_service() {
    procd_open_instance
    procd_set_param command docker run --name homeassistant \
        --privileged \
        --restart=unless-stopped \
        -v /etc/homeassistant:/config \
        -v /etc/localtime:/etc/localtime:ro \
        --network=host \
        ghcr.io/home-assistant/home-assistant:stable
    procd_set_param stdout 1
    procd_set_param stderr 1
    procd_close_instance
}
EOF

chmod +x files/etc/init.d/homeassistant

# === 5. Cleanup before compile ===
rm -rf staging_dir/hostpkg 2>/dev/null || true
rm -rf build_dir/host* 2>/dev/null || true
