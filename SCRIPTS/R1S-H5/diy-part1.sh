#!/bin/bash
# diy-part1.sh - Add required feeds for SagerNet Core and other packages

# Use official ImmortalWrt feeds (no third-party unless necessary)
# SagerNet Core is now in the main ImmortalWrt packages feed (23.05+)

# Optional: Uncomment if you need latest luci-app-docker from kenzo (usually not needed)
# echo "src-git kenzo https://github.com/kenzok8/openwrt-packages" >> feeds.conf.default

# Update feeds
./scripts/feeds update -a
./scripts/feeds install -a
