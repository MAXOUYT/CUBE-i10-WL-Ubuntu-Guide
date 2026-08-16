# 🖥️ CUBE i10-WL 触屏驱动修复包

![License](https://img.shields.io/badge/固件-专有-red)
![License](https://img.shields.io/badge/代码-GPLv2-blue)
![Platform](https://img.shields.io/badge/平台-Bay%20Trail-lightgrey)
![Kernel](https://img.shields.io/badge/内核-7.0.0--14--generic-green)

> <img src="https://img.shields.io/badge/%E2%9A%A0%EF%B8%8F%20%E7%89%88%E6%9D%83%E5%A3%B0%E6%98%8E-%E5%9B%BA%E4%BB%B6%E5%BD%92%E9%85%B7%E6%AF%94%E9%AD%94%E6%96%B9(CUBE)%E5%8E%9F%E5%8E%82%E6%89%80%E6%9C%89-red?style=for-the-badge" alt="版权声明"><br>
> <img src="https://img.shields.io/badge/%E7%94%A8%E9%80%94-%E4%BB%85%E4%BE%9B%E4%B8%AA%E4%BA%BA%E5%AD%A6%E4%B9%A0%E4%B8%8E%E8%AE%BE%E5%A4%87%E4%BF%AE%E5%A4%8D-darkred?style=for-the-badge" alt="用途"><br>
> <img src="https://img.shields.io/badge/%E7%89%88%E6%9D%83%E6%96%B9-%E8%AF%B7%E8%81%94%E7%B3%BB%E6%88%91%E4%BB%AC%E7%AB%8B%E5%8D%B3%E5%88%A0%E9%99%A4-red?style=for-the-badge" alt="版权方">

> 让 CUBE i10-WL（及同系列 Bay Trail 平板）触屏在 Linux 下正常工作的完整方案。
> 完整修复流程见 [**CUBE i10-WL Linux 完整修复手册**](https://github.com/MAXOUYT/CUBE-i10-WL-Ubuntu-Guide/blob/main/README.md)（含 32 位 UEFI 引导、GRUB 修复等全部环节）。

---

## 📦 内容说明

修复分为两个独立部分：

| 部分 | 说明 |
|---|---|
| **内核驱动修复** | 固件 + 内核模块（stuck workaround + 坐标修正）|
| **桌面校准** | X11 校准脚本（登录自动运行）|

## 📁 文件清单

```
触屏驱动及校准配置/
├── fix-touchscreen.sh          # 内核修复脚本（自动装依赖，需 root，支持参数1/2）
├── calibrate-touchscreen.sh    # 桌面校准脚本（X11 专用）
├── README.md                   # 本说明
├── 固件/
│   └── mssl1680.fw             # Silead GSL1680 固件（官方提取）
├── 内核模块源码/             # 参数1: 1972x1514（默认, 推荐）
│   ├── silead_fix.c            # 内核模块源码（GPL v2）
│   ├── silead_fix.ko           # 预编译模块（7.0.0-14-generic）
│   └── Makefile                # 编译脚本
├── 参数2-1366x768/             # 参数2: 1366x768（备用）
│   ├── silead_fix.c            # 1366x768 版源码
│   ├── silead_fix.ko           # 1366x768 版预编译模块
│   └── Makefile                # 编译脚本
├── switch-coords.sh            # 一键切换参数1/2（需 root）
├── 配置/
│   ├── silead-fix.conf         # modprobe 自动加载
│   └── calibrate-touchscreen.sh
└── 工具/
    ├── fwtool                  # 固件转换工具（gsl-firmware）
    └── Firmware/               # Firmware::Silead Perl 模块
```

## 🚀 快速开始

### 第 1 步：内核驱动修复（所有环境必需）

```bash
# 需要 root 权限；脚本会自动安装编译依赖（build-essential/gcc-14/linux-headers）
sudo ./fix-touchscreen.sh      # 默认使用 参数1 (1972x1514)
# sudo ./fix-touchscreen.sh 2  # 如需使用 参数2 (1366x768)
```

### 参数说明（重要）

> 触屏坐标参数有两个版本，解决"触摸偏移"问题：

| 参数 | 目录 | 坐标 | 说明 |
|---|---|---|---|
| **参数1**（默认）| `内核模块源码/` | **1972×1514** | 触摸芯片真实分辨率，坐标原生正确，**推荐** |
| **参数2**（备用）| `参数2-1366x768/` | 1366×768 | 屏幕分辨率，仅当参数1触摸偏移时使用 |

**切换方法**（安装后无需重装，直接切换）：
```bash
sudo ./switch-coords.sh 1   # 切到 参数1 (1972x1514)
sudo ./switch-coords.sh 2   # 切到 参数2 (1366x768)
```
> 💡 若触摸出现偏移，先执行 `sudo ./switch-coords.sh 2` 试参数2，再观察；不行就切回参数1。

### 第 2 步：桌面校准（仅 X11 需要）

```bash
./calibrate-touchscreen.sh
# 或加入 ~/.xprofile 实现登录自动运行
```

## 📦 自动安装依赖（新机器必看）

> 全新系统可能缺少编译工具链。**fix-touchscreen.sh 已内置依赖自动检测与安装**：
> 自动检查并安装 `build-essential`、`gcc-14`、`linux-headers-$(uname -r)` 等，无需手动准备。

> ⚠️ 依赖安装需要**联网**（apt 源可用）。若离线环境，请提前准备好这些依赖包。

## ⚠️ 注意事项

- **固件非开源**：`mssl1680.fw` 提取自 CUBE 官方 Windows 驱动，版权归原厂，分享时请标注。
- **预编译 .ko 仅适用 7.0.0-14-generic**：其他内核需用 `Makefile` 重新编译。
- **坐标已内置**：默认参数1（1972×1514）为芯片真实分辨率；参数2（1366×768）为备用。
- **切换参数**：安装后可用 `switch-coords.sh` 一键切换，无需重装系统。

## 📋 许可证

| 组件 | 许可证 |
|---|---|
| silead_fix.c / .ko | GPL v2 |
| fwtool / Firmware::Silead | GPL v2（[onitake/gsl-firmware](https://github.com/onitake/gsl-firmware)）|
| mssl1680.fw | 专有（Proprietary）|

> <img src="https://img.shields.io/badge/%E2%9A%A0%EF%B8%8F%20%E7%89%88%E6%9D%83%E5%A3%B0%E6%98%8E-%E5%9B%BA%E4%BB%B6%E5%BD%92%E9%85%B7%E6%AF%94%E9%AD%94%E6%96%B9(CUBE)%E5%8E%9F%E5%8E%82%E6%89%80%E6%9C%89-red?style=for-the-badge" alt="版权声明"><br>
> <img src="https://img.shields.io/badge/%E7%94%A8%E9%80%94-%E4%BB%85%E4%BE%9B%E4%B8%AA%E4%BA%BA%E5%AD%A6%E4%B9%A0%E4%B8%8E%E8%AE%BE%E5%A4%87%E4%BF%AE%E5%A4%8D-darkred?style=for-the-badge" alt="用途"><br>
> <img src="https://img.shields.io/badge/%E7%89%88%E6%9D%83%E6%96%B9-%E8%AF%B7%E8%81%94%E7%B3%BB%E6%88%91%E4%BB%AC%E7%AB%8B%E5%8D%B3%E5%88%A0%E9%99%A4-red?style=for-the-badge" alt="版权方">
