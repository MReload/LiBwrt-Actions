# Modify default IP
#sed -i 's/192.168.1.1/192.168.50.5/g' package/base-files/files/bin/config_generate

# Modify default theme
#sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile

# ==============================================
# 调整 Q6(NSS DSP) 内存预留（官方方案见 LibWrt issue #166）
# ZN-M2 为 512MB 内存，默认走 ipq6018-512m.dtsi（预留 55MB，0x3700000）
# 无WiFi后 Q6 不加载 WiFi 固件，可把这块预留缩小，把内存让给系统
# sed 目标地址必须是 0x4ab00000（q6_region 固定起始地址，只改大小）
# ==============================================
# 预留 16MB（nowifi 推荐值，省下约 39MB 可用内存）
sed -i 's/reg = <0x0 0x4ab00000 0x0 0x[0-9a-f]\+>/reg = <0x0 0x4ab00000 0x0 0x01000000>/' \
	target/linux/qualcommax/files/arch/arm64/boot/dts/qcom/ipq6018-512m.dtsi
# 预留 32MB 请改用：
#sed -i 's/reg = <0x0 0x4ab00000 0x0 0x[0-9a-f]\+>/reg = <0x0 0x4ab00000 0x0 0x02000000>/' \
#	target/linux/qualcommax/files/arch/arm64/boot/dts/qcom/ipq6018-512m.dtsi

# sed 未命中（上游把文件结构改了）时让编译立刻失败，避免拿内存错误配置出包
grep -q "0x01000000" target/linux/qualcommax/files/arch/arm64/boot/dts/qcom/ipq6018-512m.dtsi || {
	echo "ERROR: q6_region adjust failed, dtsi may have changed upstream" >&2
	exit 1
}
