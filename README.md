# LiBwrt-Actions

基于 [P3TERX/Actions-OpenWrt](https://github.com/P3TERX/Actions-OpenWrt) 模板的个人 OpenWrt 云编译项目,使用 GitHub Actions 自动编译 [LiBwrt/LibWrt](https://github.com/LiBwrt/LibWrt) 固件。

> 本仓库由 [LibWrt-ZNM2](https://github.com/MReload/LibWrt-ZNM2) 与 LiBwrt-Actions 合并而来:工作流与 NoWiFi 核心配置取自本仓库,软件包方案取自 ZNM2 精简版。

## 固件信息

| 项目 | 内容 |
|------|------|
| **设备** | 兆能 M2 (ZN-M2 / IPQ60XX / 512MB) |
| **源码** | [LiBwrt/LibWrt](https://github.com/LiBwrt/LibWrt) `25.12-nss` 分支 |
| **内核** | 6.12 |
| **NSS** | ✅ 硬件加速 (固件 v12.5) |
| **WiFi** | ❌ 无 WiFi 版本(禁用 ath11k) |
| **默认 IP** | 192.168.1.1 |
| **默认密码** | 无 |

## NoWiFi 说明

ZN-M2 的有线网口走 NSS 硬件加速,本固件为无 WiFi 版本,已做以下优化:

1. **禁用 ath11k 驱动和固件** —— 减小固件体积、降低内存占用
2. **q6_region 内存调整** —— 从 55MB 减到 16MB,无 WiFi 后 DSP 固件不加载,释放约 39MB 可用内存(方案来自 [LibWrt issue #166](https://github.com/LiBwrt/LibWrt/issues/166),见 `diy-part2.sh`,sed 未命中会主动报错终止)
3. **NSS 固件 v12.5** —— 在 `.config` 中通过 `NSS_FIRMWARE_VERSION_12_5` 选择,可按需改为 11.4 / 12.1 / 12.2

## 内置插件(精简版)

- luci-app-autoreboot —— 定时重启
- luci-app-firewall —— 防火墙
- luci-app-package-manager —— 软件包管理
- luci-theme-bootstrap —— Bootstrap 主题
- 中文界面 (zh_Hans)

如需 samba4、AdGuardHome、SQM、ttyd 等,编辑 `.config` 添加对应的 `CONFIG_PACKAGE_luci-app-xxx=y` 即可。

## 使用方法

1. 进入 **Actions** 页面,选择 **OpenWrt Builder**,点击 **Run workflow** 手动触发
2. 等待约 1~1.5 小时编译完成
3. 在 **Releases** 下载固件(保留最近 3 个版本),或在本次运行的 **Artifacts** 下载

固件文件:`libwrt-qualcommax-ipq60xx-zn_m2-squashfs-sysupgrade.bin`(已运行系统升级用)/ `factory.bin`(原厂刷机用)

## 自定义

### 修改软件包

编辑 `.config`,在 LuCI 应用区增删 `CONFIG_PACKAGE_luci-app-xxx=y`。

### 修改 q6_region 内存预留

编辑 `diy-part2.sh`,按注释切换 16MB / 32MB 的 sed 行。

### 修改默认 IP

编辑 `diy-part2.sh`,取消注释并修改:

```bash
sed -i 's/192.168.1.1/你的IP/g' package/base-files/files/bin/config_generate
```

## 目录结构

```
├── .config                          # OpenWrt 编译配置(设备/软件包)
├── diy-part1.sh                     # feeds 更新前执行(添加自定义 feed)
├── diy-part2.sh                     # feeds 安装后执行(改 IP/调内存等)
└── .github/workflows/
    └── openwrt-builder.yml          # GitHub Actions 编译工作流
```

## 致谢

- [P3TERX/Actions-OpenWrt](https://github.com/P3TERX/Actions-OpenWrt)
- [LiBwrt/LibWrt](https://github.com/LiBwrt/LibWrt)
- [qosmio/nss-packages](https://github.com/qosmio/nss-packages)
- [OpenWrt](https://github.com/openwrt/openwrt) / [ImmortalWrt](https://github.com/immortalwrt/immortalwrt)

## License

MIT © [P3TERX](https://p3terx.com)
