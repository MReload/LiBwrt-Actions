# Uncomment a feed source
#sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

# LibWrt 的 feeds.conf.default 已自带 nss_packages / sqm_scripts_nss /
# immortalwrt packages / luci 等全部所需源，默认无需额外添加。
# 如需额外 feed，参考下面示例：
#echo 'src-git kenzo https://github.com/kenzok8/openwrt-packages' >>feeds.conf.default
