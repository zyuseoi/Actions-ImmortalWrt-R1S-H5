# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)

# Add a feed source
sed -i '1i src-git passwall_packages https://github.com/Openwrt-Passwall/openwrt-passwall-packages\nsrc-git passwall_luci https://github.com/Openwrt-Passwall/openwrt-passwall' feeds.conf.default
