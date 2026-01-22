#!/bin/bash
# diy-part1.sh - Add custom feed for luci-app-speedtest-web (ZeaKyX)

# Add official ImmortalWrt feeds (already present by default, but safe to keep)
# ./scripts/feeds update -a is called later

# Add ZeaKyX's speedtest-web feed (contains both speedtest-web and luci-app-speedtest-web)
echo "src-git speedtest https://github.com/ZeaKyX/luci-app-speedtest-web.git" >> feeds.conf.default

# Update all feeds: official + speedtest
./scripts/feeds update -a

# Install all selected packages (including luci-app-speedtest-web and its dependency speedtest-web)
./scripts/feeds install -a
