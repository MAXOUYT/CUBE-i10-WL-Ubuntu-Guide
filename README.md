# CUBE-i10-WL-Ubuntu-Guide
酷比魔方 i10-WL 输入64位 Ubuntu-Linux(Ubuntu-Server 26.04 LTS) 教程（触屏修复）

# 🧩 酷比魔方 i10-WL（Bay Trail）Linux 完整修复手册

> 从"无法启动"到"日常可用"的全部关键修复步骤
> 整合自实际部署经验，含触屏完整修复方案

---

## 📑 目录

- [📖 关于本手册](#-关于本手册)
- [🔧 硬件进门指南（零基础必读）](#-1️⃣-硬件进门指南零基础必读)
- [💾 重装前的数据备份（PE 环境）](#0️⃣-重装前的数据备份pe-环境)
- [🛟 安装失败先别急着重装！（应急判断）](#0️⃣5-安装失败先别急着重装应急判断)
- [⚠️ 安装前置须知（必读）](#️-安装前置须知必读)
  - [0️⃣ 提前准备外置网卡驱动](#0️⃣-提前准备外置网卡驱动重要)
  - [1️⃣ 这台机器的"奇葩"之处](#1️⃣-这台机器的奇葩之处64-位处理器--32-位-uefi)
  - [2️⃣ 如何用 Ventoy 启动 Ubuntu ISO](#2️⃣-如何用-ventoy-启动-ubuntu-iso安装系统)
- [第一阶段：紧急启动（GRUB 未修复时）](#第一阶段紧急启动grub-未修复时)
- [第二阶段：创建用户 & 恢复模式](#第二阶段创建用户--恢复模式)
- [第三阶段：软件源修复](#第三阶段软件源修复在线源恢复)
- [第四阶段：修复 32 位 UEFI 引导](#第四阶段修复-32-位-uefi-引导)
- [第五阶段：修复 GRUB 字体乱码](#第五阶段修复-grub-字体乱码)
- [第六阶段：固化 eMMC 驱动](#第六阶段固化-emmc-驱动到-initramfs)
- [第七阶段：屏蔽内置网卡 + 外接网卡修复](#第七阶段屏蔽内置网卡rtl8723bs)
- [第八阶段：屏蔽 wlan0 + 加速启动](#第八阶段屏蔽-systemd-等待-wlan0--加速启动)
- [第九 & 十阶段：GRUB 内核参数](#第九--十阶段合并grub-内核参数)
- [第十一阶段：ZRAM + 交换文件](#第十一阶段配置-zram--交换文件)
- [第十二阶段：触屏修复（完整方案）](#第十二阶段触屏修复silead-gsl1680完整方案)
- [第十三阶段：浏览器内存优化](#第十三阶段浏览器内存优化edge--firefox)
- [第十四阶段：WiFi / 网络维护](#第十四阶段wifi--网络常用维护)
- [第十五阶段：系统时间校准（NTP）](#第十五阶段系统时间校准ntp)
- [第十六阶段：蓝牙音频 AAC](#第十六阶段蓝牙音频-aac-支持可选)
- [第十七阶段：Flatpak 网络劫持排查](#第十七阶段flatpak-网络劫持排查)
- [第十八阶段：zhcon 中文终端](#第十八阶段tty2-自动启动-zhcon中文终端)
- [第十九阶段：电池状态查看](#第十九阶段电池状态查看日常维护)
- [📋 常见问题（FAQ）](#-常见问题faq)
  - [🖥️ MATE 桌面图标显示（主文件夹/回收站）](#️-mate-桌面图标显示主文件夹回收站)
- [📋 许可证声明](#-许可证声明)

---
# 📖 关于本手册

> <span style="color:red"><b>⚠️ 版权声明：本仓库所含 mssl1680.fw 固件版权归酷比魔方（CUBE）原厂所有，仅供个人学习与设备修复使用。若您是版权方并希望移除相关内容，请联系我们，我们将立即删除。</b></span>

本手册基于 **酷比魔方 i10-WL**（Intel Bay Trail 平台）的实际部署经验整理而成，包含：
- eMMC 驱动固化、外接网卡修复、触屏完整方案（Silead GSL1680）
- 软件源配置、ZRAM 优化、蓝牙 AAC 等日常维护

**适用设备**：酷比魔方 i10-WL / i10 系列，以及采用 Intel Bay Trail（Z3735F/Z3736F）的同类平板。

**许可证**：文档内容采用 CC BY-NC-SA 4.0，代码部分遵循各组件原有许可证（详见文末）。

**测试环境**：Ubuntu 26.04 LTS + MATE 桌面环境实测通过。

<span style="color: gray;">💡 可自行选择 Kubuntu 或 Lubuntu 以获得现成的桌面环境。本教程旨在对设备进行最大程度的优化，以及保证桌面环境是较为丰富且容易上手的，所以使用了 Ubuntu Server + MATE 桌面环境。</span>

---
# -1️⃣ 硬件进门指南（零基础必读）

> 动手前先看这章！以下都是"物理操作"——不需要懂 Linux 也能照做。

## 🔑 如何进入 BIOS（UEFI 设置）

**本机（CUBE i10-WL）进 BIOS 的方法是：开机时按 ESC 键（按住不松手；也可开机后，当屏幕亮起时一直连按 ESC）**

| 操作 | 说明 |
|---|---|
| **关机状态** | 按住 **ESC 键不松手**，然后按一下**电源键**开机（也可开机后**当屏幕亮起时一直连按 ESC**）|
| **看到画面后** | 当屏幕亮起时一直连按 **ESC**，直到**"酷比魔方"的 logo 下出现提示**，即可进入 BIOS 设置界面 |
| **提示** | 部分批次可能需按 **Del 或 F2**，但本机实测为 **ESC** |

> ⚠️ 平板类设备的 BIOS 进入方式和笔记本不同，**没有** F2/Del 快捷键提示，只能盲按 ESC。若一次没进，关机重试，**ESC 要在按电源键前就按住**；也可开机后**当屏幕亮起时一直连按 ESC**，直到**"酷比魔方"的 logo 下出现提示**。

**在 BIOS 里需要做的**：
- **禁用 Secure Boot（安全启动）**——否则无法引导第三方系统。
- **USB 启动设为优先**（或从 Boot From File 手动选择）。
- **关闭 Fast Boot**（如有该选项）——否则可能跳过 USB 检测。

## 💾 制作 Ventoy 启动盘

> 一个 U 盘同时搞定"装 Linux"和"进 PE 维护"，启动时在 Ventoy 菜单里自由切换。

| 软件 | 说明 |
|---|---|
| **Ventoy**（推荐）| 启动盘主方案：直接引导 U 盘里的各种 ISO（系统安装镜像 / PE 镜像）|
| **WePE** | 微 PE，功能全、自带 DiskGenius，官网 wepe.com.cn 下载；需用其安装包的"生成 ISO"功能导出 **Win_PE.iso** |

**推荐做法（一个 U 盘通吃）**：
1. 准备一个 **≥8GB** 的 U 盘（会清空数据），用 Ventoy 制作启动盘。
2. 将以下 ISO 直接拷入 Ventoy 启动目录（U 盘根目录或任意子目录，建议单独建一个 ISO 文件夹）：
   - **Ubuntu-Server 26.04 LTS.iso** —— 目标系统安装镜像
   - **Win_PE.iso** —— 微 PE，用于备份 / 分区 / 应急维护
3. 开机从 U 盘启动进入 Ventoy 菜单，按需选择要启动的 ISO，随时切换。

> ⚠️ **重要：PE 的 ISO 必须是 32 位的**（WePE 生成 ISO 时选 32 位版）。本机是 **32 位 UEFI**，**64 位的 WinPE 无法启动，会蓝屏**。

> 💡 **DiskGenius 查看 Linux 分区**：Windows 默认不识别 ext4 文件系统，但 **DiskGenius 专业模式可以直接浏览 ext4**——在 DG 左侧选中分区，右侧即可看到 Linux 目录结构（无需挂载）。

---
# 0️⃣ 重装前的数据备份（PE 环境）

> ⚠️ **不要跳过这一步！** 在动手重装之前，务必用 PE 盘启动，备份个人数据。

### 推荐工具
- **DiskGenius**（PE 自带）：用于分区管理、文件备份。
- **Dism++**（可选）：更可靠的 Windows 系统备份工具。

### 备份内容（至少包括）
| 路径 | 说明 |
|---|---|
| `C:\Users\用户名\Desktop` | 桌面文件 |
| `C:\Users\用户名\Documents` | 文档 |
| `C:\Users\用户名\Downloads` | 下载内容 |
| `C:\Users\用户名\AppData\Local\Google\Chrome\User Data\Default\Bookmarks` | 浏览器收藏夹 |
| `C:\Users\用户名\Desktop\.minecraft\servers.dat` | Minecraft 服务器列表（如有）|

### 推荐做法
- **用 DiskGenius 做全盘镜像（`.pmfx`）**：即使重装失败，也能完整恢复到原 Windows 状态。
- **单独备份个人文件夹**：方便在 Linux 下直接复制回 `~/` 目录。

---
# 0️⃣.5 安装失败先别急着重装！（应急判断）

> 🧩 **如果 Ubuntu Server 安装到一半后提示安装失败或崩溃，不要着急重装系统！**

**操作流程**：

1. 进入 **PE 环境**，用 **DiskGenius（DG）** 查看分区状态。
2. 即使分区标记为**"已损坏"**，只要**主要系统文件还存在**（如 `/usr`、`/etc`、`/boot` 等目录完整），就有极大概率可以直接启动。
3. 无需重装——**直接手动配置 GRUB 引导**（见第四阶段），让 32 位 UEFI 启动 64 位的 Ubuntu Server。

**原因**：安装器崩溃通常发生在**收尾阶段**（配置 grub、创建用户等），此时核心系统文件其实已经解压完成。分区显示"损坏"往往只是引导信息没写完整，文件系统本身完好。

**实际案例**：本手册所基于的这台 CUBE i10-WL，安装 Ubuntu Server 26.04 时安装到一半崩溃，PE 下 DG 显示分区"已损坏"，但主要系统文件都在——**手动 GRUB 引导后成功进入系统**，无需重装。

### 📂 如何判断 Linux 主要文件系统是否完整（最低限度启动标准）

在 PE 的 DiskGenius 里浏览根分区，**如果以下目录基本齐全，系统就大概率能启动**：

| 目录 | 作用 | 缺失后果 |
|---|---|---|
| `/boot` | 内核（vmlinuz）和 initrd | ❌ 无内核，无法引导 |
| `/usr` | 系统主体（命令、库、应用，Ubuntu 已合并 /bin /sbin /lib 到 /usr）| ❌ 无法进入用户空间 |
| `/etc` | 配置文件（fstab、passwd、systemd 等）| ⚠️ 配置丢失，可能无法正常启动 |
| `/var` | 运行时数据、日志、包管理状态 | ⚠️ 可重建，但 apt 状态会丢失 |
| `/home` | 用户主目录 | ⚠️ 不影响启动，但用户数据丢失 |

> 💡 **核心判断**：只要 **`/boot`（有 vmlinuz + initrd）+ `/usr` + `/etc` 完整**，就具备了启动 Linux 的最低条件——剩下的（`/var`、`/home` 等）即使缺失或损坏，也可以在启动后重建或修复。

> ⚠️ **注意**：现代 Ubuntu 中 `/bin`、`/sbin`、`/lib` 都是指向 `/usr` 下的**符号链接**，所以检查 `/usr` 即可；若这些是独立目录（旧式布局），则需分别确认。


---
# ⚠️ 安装前置须知（必读）

## 0️⃣ 提前准备外置网卡驱动（重要！）

> ⚠️ **如果您只有这一台设备**，请务必在 Windows 环境下（或其他设备上）**提前下载外置网卡所需的 Linux 驱动**，以免插入外接网卡时发现没驱动、无法联网。

**推荐使用本手册同款外置网卡**：

| 项目 | 信息 |
|---|---|
| **型号** | 水星（Mercury）MW150US 免驱版 |
| **芯片** | Realtek RTL8188GU |
| **驱动** | `rtl8xxxu`（Linux 内核自带）|
| **固件** | `rtl8710bufw_UMC.bin`（需从其他设备提取，见第七阶段）|
| **规格** | 802.11n（WiFi 4）、仅 2.4GHz、USB 2.0 |

**提前准备**：在 Windows 下可正常联网时，先从其他 Ubuntu 设备或网络获取 `rtl8710bufw_UMC.bin` 固件文件，存放到 U 盘/PE 盘中备用（详细安装见第七阶段）。

---
## 1️⃣ 这台机器的"奇葩"之处：64 位处理器 + 32 位 UEFI

| 项目 | 实际情况 |
|---|---|
| **CPU** | Intel Atom Z3735F（**64 位** x86_64）|
| **UEFI 固件** | **仅 32 位**（i386-efi，BIOS 2015-11-30）|
| **后果 1** | **64 位 Windows 无法启动**（UEFI 引导器不兼容）|
| **后果 2** | 标准 64 位 GRUB（grubx64.efi）无法引导 |
| **解法** | 只能引导 **32 位 EFI 文件**（bootia32.efi）+ 64 位 Linux 内核 |

**关键原理**：UEFI 固件只认 32 位 EFI 可执行文件（.efi），但 Linux 内核本身是 64 位的——**引导器（32位）负责加载内核（64位）**，所以 64 位 Linux 可以正常跑，只是引导链必须用 32 位 EFI 文件。

**系统选择**：由于 64 位 Windows 无法启动，最终选择 **Ubuntu Server 26.04 LTS**（纯命令行环境），后续手动加入 **MATE 桌面环境** 作为日常使用界面。

---
## 2️⃣ 如何用 Ventoy 启动 Ubuntu ISO（安装系统）

### bootia32.efi 的两种来源（关键区分，不要搞混）

| 阶段 | 使用的 bootia32.efi | 来源 | 作用 |
|---|---|---|---|
| **进入 Ventoy** | Ventoy 自带的 | Ventoy U 盘内 `/EFI/BOOT/bootia32.efi` | 加载 Ventoy 本体，显示 ISO 选择菜单 |
| **启动已安装的系统** | 网上下载的 GRUB 版 | GitHub 开源项目（如 lamadotcare/bootia32-efi）| 引导硬盘上的 Ubuntu（加载内核、initrd）|

> ⚠️ **两者用途完全不同，不要搞混**：
> - 进 Ventoy **不需要**网上的文件，用 Ventoy 自带的就够了
> - 网上的 GRUB 版 bootia32.efi 是给**硬盘系统引导**用的，不是给 Ventoy 用的

**为什么用 Ventoy 自带的也能进？**

- Ventoy 为了兼容性，官方已内置 32 位引导文件，只是默认名称是 bootx64.efi（或放在特定路径）。
- 这台机器的 BIOS 自动扫描时只会尝试 64 位文件（卡死），但只要在 **Boot From File** 中手动指定路径，指向这个自带的 32 位文件，它就能正常加载 Ventoy 菜单。
- 网上下载的 bootia32.efi 是 **GRUB 引导器**，主要用于**系统安装完成后**引导硬盘上的 Ubuntu，而不是用来启动 Ventoy。

> 💡 **bootia32.efi 工作原理**：bootia32.efi 本身只是一个 EFI 可执行文件，它的具体行为取决于它内部加载的配置（如 grub.cfg）。Ventoy 自带的版本会加载 Ventoy 本体；而 GRUB 版会读取 grub.cfg 并引导硬盘上的 Linux 内核。

**正确的操作逻辑链**：

1. U 盘自带 bootia32.efi（Ventoy 内置）→ 手动从 Boot From File 选中 → 进入 Ventoy 菜单 → 选择 Ubuntu ISO 安装系统。
2. 网上下载的 GRUB 版 bootia32.efi → 系统安装完成后，替换硬盘 ESP 分区中的引导文件 → 用于引导硬盘上的 Ubuntu 系统（而不是 U 盘里的 Ventoy）。

**📥 获取 GRUB 版 bootia32.efi（引导硬盘系统用）**

以下两个 GitHub 仓库都是专为 Bay Trail 这类 32 位 UEFI 设备准备的：

| 仓库 | 说明 | 维护状态 |
|---|---|---|
| [lamadotcare/bootia32-efi](https://github.com/lamadotcare/bootia32-efi) | 专为 IA32 UEFI 设备准备的 EFI 引导文件，支持 Bay Trail（Intel Silvermont 架构）| ✅ 仍在维护，**推荐** |
| [hirotakaster/baytail-bootia32.efi](https://github.com/hirotakaster/baytail-bootia32.efi) | Bay Trail 设备 64 位 Linux + 32 位 UEFI 引导文件 | ⚠️ 2015 年后未更新 |

**直接下载链接**（可能因仓库更新而失效）：

- `https://github.com/lamadotcare/bootia32-efi/blob/main/bootia32.efi`
- `https://github.com/hirotakaster/baytail-bootia32.efi/raw/master/bootia32.efi`

**使用方法**：下载 bootia32.efi 后放入启动 U 盘的 `EFI/BOOT/` 目录（或系统 ESP 分区的 `EFI/BOOT/`），用于引导硬盘上的 Ubuntu。

### 🔌 Ventoy 启动盘的「正确姿势」

- 首次安装时，插 U 盘后 BIOS 可能仍无法识别，需确认 U 盘是 **GPT 分区表**，并在 BIOS 中**禁用安全启动（Secure Boot）**。
- 若 Boot From File 中看不到 U 盘，需在 BIOS 中将 **USB 启动设为优先**，或**关闭 Fast Boot**。

---
# 第一阶段：紧急启动（GRUB 未修复时）

> 🧩 **这是正常现象，不是装坏了！** 安装完第一次重启**必进 grub> 提示符**（因为 32 位 UEFI 的 GRUB 引导链还没配好），需要手动输入命令才能进系统。

```bash
# 在 grub> 提示符下执行
# 第一步：查看有哪些分区（逐个 ls 确认）
ls

# 第二步：确认哪个分区是根分区（能看到 vmlinuz 和 initrd 的就是）
ls (hd0,gpt1)/boot/   # 没有 vmlinuz 就试下一个
ls (hd0,gpt2)/boot/   # ✓ 看到 vmlinuz-* 说明这是根分区
ls (hd0,gpt3)/boot/   # 若上面都不是，继续试

# 第三步：设置根分区（用实际找到的分区号）
set root=(hd0,gpt2)

# 第四步：手动引导内核（root= 参数对应实际设备）
linux /boot/vmlinuz root=/dev/mmcblk1p2 ro init=/bin/bash
initrd /boot/initrd.img
boot
```

进入后需手动挂载根分区为读写：`mount -o remount,rw /`

---
# 第二阶段：创建用户 & 恢复模式

```bash
# 在 root shell 中执行
useradd -m -s /bin/bash 用户名
passwd 用户名
usermod -aG sudo 用户名
```

> 🧩 **实际背景（本手册案例）**：安装崩溃时**用户可能并没有成功创建**——本手册的这台机器就是如此：安装器在创建用户的步骤前就崩溃了，系统里只有 root，且**没有设置过 root 密码（默认空/禁用）**。

> **恢复模式下的 root 访问**：通过第一阶段的手动 GRUB 命令（`linux ... init=/bin/bash`）进入**单用户恢复模式**后，可以直接获得 **root shell（无需密码）**——因为单用户模式不经过登录认证。在这个 shell 里执行上面的命令创建用户即可。

> ⚠️ **注意**：Ubuntu 默认 root 密码是**锁定/禁用的**（正常登录无法用 root），但**单用户恢复模式绕过登录认证**，直接以 root 身份进入。创建好普通用户并加入 sudo 组后，日常就用普通用户 + sudo 操作。


---
# 第三阶段：软件源修复（在线源恢复）

> 📡 **首次安装系统的网络建议**：安装 Ubuntu Server 时网络配置是"边装边配"，
> 建议**先跳过网络配置**，装完再调 WiFi（因为系统一开始可能没网卡驱动，连不上）。
> 等装完系统、进入桌面后，再用 nmcli 或 netplan 连接 WiFi，不容易卡在安装过程。

> ⚠️ **版本判断**：系统显示"Ubuntu 26.04"但实际 apt 源用 noble(24.04)。
> 以 `/etc/os-release` 的 `VERSION_CODENAME` 为准，不要只看显示版本。

```bash
# 备份原有源
sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak

# 写入清华源（noble 与系统实际匹配）
sudo tee /etc/apt/sources.list <<'EOF'
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ noble main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ noble-updates main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ noble-backports main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ noble-security main restricted universe multiverse
EOF

# 更新源（若 IPv6 卡住，强制 IPv4）
sudo apt -o Acquire::ForceIPv4=true update

# 持久化强制 IPv4
echo 'Acquire::ForceIPv4 "true";' | sudo tee /etc/apt/apt.conf.d/99force-ipv4
```

### 🧹 微软源残留处理

> Edge 和 VS Code 的 .deb 包会自动注入微软源，可能导致 apt update 反复报错。

```bash
# 若 apt update 报错与 packages.microsoft.com 相关
sudo rm /etc/apt/sources.list.d/microsoft-edge.sources
sudo rm /etc/apt/sources.list.d/vscode.sources
sudo apt update
```

### 📡 软件源配置的「备案」

- **若清华源崩了**：可换**中科大源**（`mirrors.ustc.edu.cn`）或**官方源**（`archive.ubuntu.com`）。
- **若 apt update 卡在 0%**：按 `Ctrl+C` 中断，然后用 `sudo apt -o Acquire::ForceIPv4=true update` 强制 IPv4 更新。

---
# 第四阶段：修复 32 位 UEFI 引导

> **Bay Trail 必备**：eMMC 上的 ESP 是 32 位 EFI，标准 grubx64.efi 无法引导
> （原理与 Ventoy 引导详见文档开头【安装前置须知】）

```bash
# 生成自定义 bootia32.efi（GRUB 版，用于引导硬盘系统）
sudo grub-mkimage -o /boot/efi/EFI/BOOT/bootia32.efi \
    -O i386-efi -p /EFI/BOOT \
    part_gpt fat ext2 normal search chain configfile \
    linux initrd gzio xzio lzopio efi_gop

# 生成 GRUB 配置文件并同步到 ESP 分区
sudo update-grub
sudo cp /boot/grub/grub.cfg /boot/efi/EFI/BOOT/grub.cfg
```

### 📝 grub.cfg 的「位置双保险」

> 某些 BIOS 可能默认读取 `/boot/efi/EFI/ubuntu/grub.cfg` 而不是 `/boot/efi/EFI/BOOT/grub.cfg`。
> **建议在两个位置都放一份**，避免启动时找不到：

```bash
sudo cp /boot/grub/grub.cfg /boot/efi/EFI/BOOT/grub.cfg
sudo cp /boot/grub/grub.cfg /boot/efi/EFI/ubuntu/grub.cfg   # 双保险
# 或建立软链接
sudo ln -sf /boot/efi/EFI/BOOT/grub.cfg /boot/efi/EFI/ubuntu/grub.cfg
```

---
# 第五阶段：修复 GRUB 字体乱码

```bash
# 复制字体文件到 ESP 分区
sudo cp /usr/share/grub/unicode.pf2 /boot/efi/EFI/BOOT/

# 在 /etc/default/grub 中添加
GRUB_FONT=/boot/efi/EFI/BOOT/unicode.pf2
GRUB_TERMINAL_OUTPUT=gfxterm

# 更新并同步
sudo update-grub
sudo cp /boot/grub/grub.cfg /boot/efi/EFI/BOOT/grub.cfg
```

---
# 第六阶段：固化 eMMC 驱动到 initramfs

```bash
echo "mmc_block" | sudo tee -a /etc/initramfs-tools/modules
echo "sdhci" | sudo tee -a /etc/initramfs-tools/modules
echo "sdhci-pci" | sudo tee -a /etc/initramfs-tools/modules
sudo update-initramfs -u -k all
```

---
# 第七阶段：屏蔽内置网卡（RTL8723BS）

> 内置网卡刷 Linux 后无法握手 WPA2，仅能连无密码 WiFi。禁用后改用外接 USB 网卡。

```bash
sudo tee /etc/modprobe.d/blacklist-r8723bs.conf <<'EOF'
blacklist r8723bs
blacklist rtl8723bs
EOF
sudo update-initramfs -u
```

---
### 外接网卡驱动修复（RTL8188GU）

> 禁用内置网卡后，需用外接 USB 网卡联网。本机实测为水星 MW150US（RTL8188GU，USB ID `0bda:b711`）。

**问题现象**：
- 插上网卡后 `lsusb` 显示 `0bda:b711`（RTL8188GU），但 `ip a` 看不到网卡接口。
- 驱动 `rtl8xxxu` 已加载，但**缺少固件**导致设备无法完成初始化。

**修复方法**：

#### 1. 从其他 Ubuntu 设备提取固件
```bash
# 在可正常使用该网卡的设备上执行（例如从另一台 Ubuntu 机器）
ls -l /lib/firmware/rtlwifi/rtl8710bufw_UMC.bin
# 若存在，用 scp 或 U 盘复制到目标设备
```

#### 2. 放到目标设备并加载驱动
```bash
sudo mkdir -p /lib/firmware/rtlwifi
sudo cp /path/to/rtl8710bufw_UMC.bin /lib/firmware/rtlwifi/
sudo chmod 644 /lib/firmware/rtlwifi/rtl8710bufw_UMC.bin

# 卸载并重新加载驱动
sudo modprobe -r rtl8xxxu
sudo modprobe rtl8xxxu
sudo ip link set wlx24698e1d4acb up   # 接口名可能不同，用 ip a 确认
```

#### 3. 验证
```bash
ip a show wlx*   # 应出现 inet 地址
nmcli dev wifi list   # 应能看到附近 WiFi
```

> 💡 **固件来源补充**：若无法从其他设备提取固件，可尝试在联网环境下从 Ubuntu 官方软件源安装 `firmware-realtek` 包：
> ```bash
> sudo apt install firmware-realtek
> ```
> ⚠️ 注意：该包**可能不包含 RTL8188GU 的固件**，仍需验证（`ls /lib/firmware/rtlwifi/rtl8710bufw_UMC.bin`）。


---
# 第八阶段：屏蔽 systemd 等待 wlan0 + 加速启动

```bash
# 屏蔽 systemd 等待 wlan0 设备
sudo systemctl mask sys-subsystem-net-devices-wlan0.device

# 调整 systemd 启动超时（默认 90 秒太长，缩短到 10 秒加速启动）
sudo sed -i 's/^#DefaultTimeoutStartSec=.*/DefaultTimeoutStartSec=10/' /etc/systemd/system.conf
sudo systemctl daemon-reexec
```

---
# 第九 & 十阶段（合并）：GRUB 内核参数

> 两阶段都在改 `GRUB_CMDLINE_LINUX_DEFAULT`，可一次完成：
> - `usbcore.autosuspend=-1`：禁用 USB 自动省电（防外接网卡掉线）
> - `iosf_mbi_use_pci_ops=1`：修复 Bay Trail I²C 锁死（与触屏 stuck 同根因）

```bash
# 编辑 /etc/default/grub
sudo sed -i 's/^GRUB_CMDLINE_LINUX_DEFAULT=.*/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash usbcore.autosuspend=-1 iosf_mbi_use_pci_ops=1"/' /etc/default/grub

# 更新并同步（只需一次）
sudo update-grub
sudo cp /boot/grub/grub.cfg /boot/efi/EFI/BOOT/grub.cfg
```

---
# 第十一阶段：配置 ZRAM + 交换文件

```bash
# 编辑 /etc/default/zramswap
PERCENT=75
PRIORITY=100
ALGORITHM=lz4

# 重启 ZRAM
sudo systemctl restart zramswap

# 创建 512MB 交换文件
sudo swapoff /swap.img
sudo dd if=/dev/zero of=/swap.img bs=1M count=512
sudo mkswap /swap.img
sudo swapon /swap.img
```

> 💡 **为什么是 75% 和 512MB**：2GB 内存下，ZRAM 比例设为 75%（约 1.3GB）可在压缩效率与物理内存占用之间取得平衡；512MB 交换文件作为 ZRAM 的后备，仅在 ZRAM 接近满载时使用，避免 eMMC 频繁写入。

---
# 第十二阶段：触屏修复（Silead GSL1680）【完整方案】

> 修复包含 4 个环节，缺一不可：

## 12.1 安装固件

```bash
# 固件来自 gsl-firmware 项目（CUBE i10 官方提取）
sudo mkdir -p /lib/firmware/silead
sudo cp mssl1680.fw /lib/firmware/silead/mssl1680.fw
```

> ⚠️ **固件格式坑**：fwtool 默认生成的带 "GSLX1680" 头格式**不是**内核驱动需要的格式。
> 必须用 `fwtool -x` 导出为纯 (offset, val) 格式（38808 字节，8 的倍数），否则驱动报 `Firmware load error -121`。

> ✅ **省事做法**：gsl-firmware 仓库（或本手册配套的分享包）中**已转换好的 mssl1680.fw**，**下载后直接放入 `/lib/firmware/silead/` 即可，无需自行转换**。
> 只有从原始 Windows 驱动提取时才需要 fwtool：

```bash
# 仅当需要从原始固件自行转换时（一般用不到）：
./fwtool -c SileadTouch.fw -3 -m 1680 -w 1366 -h 768 -t 10 silead_ts.fw
./fwtool -x export_plain.fw silead_ts.fw   # 导出内核格式
sudo cp export_plain.fw /lib/firmware/silead/mssl1680.fw
```

## 12.2 编译并安装属性注入内核模块

> CUBE i10 不在内核 DMI quirk 表（touchscreen_dmi.c）中，需要自定义模块注入两个关键属性：
> - `silead,stuck-controller-bug`：解决 BIOS 导致的芯片卡死（否则固件加载 -121）
> - `touchscreen-size-x/y = 1972/1514`：芯片真实坐标范围（不是屏幕 1366x768！）

```bash
# silead_fix.c 源码
cat > silead_fix.c <<'EOF'
#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/i2c.h>
#include <linux/property.h>
#include <linux/device.h>

extern int device_create_managed_software_node(struct device *dev,
				const struct property_entry *properties,
				const struct software_node *parent);

static const struct property_entry silead_props[] = {
	PROPERTY_ENTRY_BOOL("silead,stuck-controller-bug"),
	PROPERTY_ENTRY_U32("touchscreen-size-x", 1972),
	PROPERTY_ENTRY_U32("touchscreen-size-y", 1514),
	{ }
};

static int __init silead_fix_init(void)
{
	struct device *dev;
	int ret;

	dev = bus_find_device_by_name(&i2c_bus_type, NULL, "i2c-MSSL1680:00");
	if (!dev) {
		pr_err("silead_fix: device not found\n");
		return -ENODEV;
	}
	ret = device_create_managed_software_node(dev, silead_props, NULL);
	if (ret) {
		pr_err("silead_fix: failed: %d\n", ret);
		put_device(dev);
		return ret;
	}
	put_device(dev);
	pr_info("silead_fix: props injected (1972x1514)\n");
	return 0;
}

static void __exit silead_fix_exit(void) { }
module_init(silead_fix_init);
module_exit(silead_fix_exit);
MODULE_LICENSE("GPL");
EOF

# Makefile
cat > Makefile <<'EOF'
obj-m += silead_fix.o
all:
	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) modules
clean:
	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) clean
EOF

# 编译（内核用 gcc-15 构建，需 gcc-14+ 支持 -fmin-function-alignment）
# 安装编译工具链（零基础务必执行，缺一步都会编译失败）
sudo apt install -y build-essential gcc-14 linux-headers-$(uname -r)

# 注意：直接 make 报 "No such file or directory" = 缺 linux-headers
# 报 "gcc: command not found" = 缺 build-essential
make CC=gcc-14
```

## 12.3 安装模块并配置自动加载

```bash
# 安装到系统模块目录
sudo mkdir -p /lib/modules/$(uname -r)/extra
sudo cp silead_fix.ko /lib/modules/$(uname -r)/extra/
sudo depmod -a

# 配置 softdep：确保 silead_fix 先于 silead 加载
sudo tee /etc/modprobe.d/silead-fix.conf <<'EOF'
softdep silead pre: silead_fix
EOF

# 加载测试
sudo modprobe silead
# 验证：dmesg 应显示 stuck workaround 生效 + 固件 build 正常
dmesg | grep -i silead
# 验证坐标范围（应为 0-1971 / 0-1513）
sudo evemu-describe /dev/input/eventX | grep Max
```

> 🧩 **内核升级后注意**：未来升级内核后，`silead_fix.ko` 会失效（模块目录路径变了），
> **需重新编译**：
> ```bash
> cd silead_fix源码目录
> make clean && make CC=gcc-14
> sudo cp silead_fix.ko /lib/modules/$(uname -r)/extra/
> sudo depmod -a
> sudo modprobe -r silead && sudo modprobe silead
> ```

## 12.4 登录后校准（X11）

> 修复后坐标**原生正确**（1366x768 全屏精确映射），**无需 xinput 校准矩阵**！
> 只需确保矩阵为恒等（防止旧配置残留）：

```bash
# 动态查找设备 ID 并确保恒等矩阵
DEV_ID=$(xinput list | grep silead_ts | grep -oE 'id=[0-9]+' | head -1 | cut -d= -f2)
xinput set-prop $DEV_ID 'libinput Calibration Matrix' 1.0 0.0 0.0 0.0 1.0 0.0 0.0 0.0 1.0
```

> 🔧 **若因残留配置导致触摸偏移**（一次性排查脚本）：
> ```bash
> # 先找到设备名
> xinput list | grep -i touch
> # 再强制设置恒等矩阵
> xinput set-prop "<设备名>" 'libinput Calibration Matrix' 1.0 0.0 0.0 0.0 1.0 0.0 0.0 0.0 1.0
> ```

> 登录自动执行：加入 `~/.xprofile`：
> `~/.config/touchscreen-calibrate.sh &`

---
# 第十三阶段：浏览器内存优化（Edge / Firefox）

> 2GB 内存下，浏览器是最主要的内存消耗来源。以下设置可显著降低内存占用。

### Edge
- 启用 **"使用标签页休眠功能节省资源"**（`edge://settings/system`）。
- 安装 **uBlock Origin** 拦截广告和追踪器。
- 限制同时打开的标签页数量（建议不超过 3-5 个）。

### Firefox
- 启用 **"自动卸载不活跃标签页"**（`about:preferences` → 性能 → 取消勾选"使用推荐的性能设置" → 勾选"自动卸载不活跃标签页"）。
- 安装 **uBlock Origin**。

---
# 第十四阶段：WiFi / 网络常用维护



```bash
# 查看网络状态
nmcli dev wifi list
ip a show wlx...

# 外接网卡掉线排查
dmesg | grep -i usb | tail
# 确认 usbcore.autosuspend 已生效
cat /sys/module/usbcore/parameters/autosuspend   # 应显示 -1

# 查看内核日志中的 USB/网卡/触屏相关错误
sudo dmesg | grep -iE "usb|wlx|rtl8xxxu|silead|error" | tail -30
```

### 网络连接管理（nm-connection-editor）

> 如果 MATE 自带的 WiFi 列表显示不全，可以用此工具管理已有连接。

```bash
# 安装（如果未安装）
sudo apt install network-manager-gnome -y

# 启动
nm-connection-editor
```

此工具可查看、编辑、删除已保存的 WiFi 连接，适合在 nm-applet 无法正常工作时使用。

---
# 第十五阶段：系统时间校准（NTP）

> 若系统时间不正确，可能导致 `apt update` 证书验证失败、网页证书报错等问题。

```bash
# 查看当前时间状态
timedatectl status

# 启用 NTP 自动同步
sudo timedatectl set-ntp true

# 若 NTP 服务未运行，手动安装并启动
sudo apt install systemd-timesyncd -y
sudo systemctl enable systemd-timesyncd
sudo systemctl start systemd-timesyncd

# 手动设置时区（示例：北京时间）
sudo timedatectl set-timezone Asia/Shanghai
```

---
# 第十六阶段：蓝牙音频 AAC 支持（可选）

```bash
# 启用 AAC 编码（需第三方 PPA）
sudo add-apt-repository ppa:aglasgall/pipewire-extra-bt-codecs
sudo apt update
sudo apt install pipewire pipewire-pulse libspa-0.2-bluetooth -y
systemctl --user restart pipewire pipewire-pulse
```

---
# 第十七阶段：Flatpak 网络劫持排查

### 问题现象
- `flatpak install` 报 SSL 错误或卡住。
- `curl -v http://dl.flathub.org/repo/summary.idx` 返回 `Location: https://baidu.com`。

### 原因
网络运营商对 HTTP 明文请求进行了劫持，重定向到广告或恶意站点。

### 解决
1. **改用 HTTPS 源**（不要用 HTTP）：
   ```bash
   flatpak remote-delete flathub
   flatpak remote-add --user --no-gpg-verify flathub https://dl.flathub.org/repo/
   ```

2. 如果 HTTPS 也被劫持，更换 DNS（如 114.114.114.114 或 8.8.8.8）。
3. 使用国内镜像源（如中科大或清华镜像）：
   ```bash
   flatpak remote-delete flathub
   flatpak remote-add --user --no-gpg-verify flathub https://mirrors.ustc.edu.cn/flathub/
   ```

---
# 第十八阶段：tty2 自动启动 zhcon（中文终端）

> 个性化配置：tty1 保留默认（可 startx 启动桌面），tty2 自动进入 zhcon 中文终端并显示 MOTD。

### 配置 `~/.bashrc`
```bash
# 获取当前 tty 编号
TTY_NUM=$(tty | grep -oE "[0-9]+$")

# 在 tty2 自动启动 zhcon（使用 exec）
if [[ "$(tty)" == "/dev/tty2" && -z "$ZHCON_RUNNING" ]]; then
    export ZHCON_RUNNING=1
    export ZHCON_MOTD_NEEDED=1
    exec zhcon --utf8
fi

# 进入 zhcon 后显示 MOTD
if [[ -n "$ZHCON_MOTD_NEEDED" ]]; then
    run-parts /etc/update-motd.d/
    unset ZHCON_MOTD_NEEDED
fi
```

**效果**：
- tty1：保留默认，可 startx 启动桌面。
- tty2：自动进入 zhcon，退出后回到登录提示符。

> 💡 **zhcon 中文输入前提**：
> 确保 `LANG=zh_CN.UTF-8` 且 **未设置 `LC_ALL=C`**（后者会强制使用 ASCII 编码，导致中文输入失效）。
> 可通过 `unset LC_ALL` 临时解除。

---
# 第十九阶段：电池状态查看（日常维护）

```bash
# 查看电池详细信息（电量、电压、充电功率、剩余时间）
upower -i /org/freedesktop/UPower/devices/battery_BAT0

# 快速查看电量和状态
upower -i $(upower -e | grep BAT) | grep -E "percentage|state|time to empty"
```

💡 **充电功率解读**：

- `energy-rate` 显示的是**净充电功率**（输入功率 - 系统功耗）。
- 若该值接近 0 或为负，说明系统功耗已接近充电器输入上限，充电会很慢。
- 关机充电可排除系统功耗干扰，验证充电器和线材的实际能力。

> 💡 **电池容量校准（BMS 学习）**：若系统读取的 `energy-full` 与实际电池容量偏差较大，可进行一次**完整充放电循环（100% → 0% → 100%）**，让 BMS 重新学习容量曲线。
> ⚠️ **仅更换新电池后的操作**：新电池首次使用建议做 1-2 次完整充放电循环，让 BMS 学习新电池的真实容量（`energy-full-design` 与 `energy-full` 会逐渐趋于一致）。

---
# 📋 常见问题（FAQ）

## 🖥️ GRUB 修复后启动黑屏

部分设备在 GRUB 修复后，启动时可能出现**黑屏（但能听到系统在运行/电源指示灯亮）**——这是视频输出未初始化。可在 linux 行添加参数解决：

```bash
# 临时（在 grub> 手动输入时）：
linux /boot/vmlinuz root=/dev/mmcblk1p2 ro nomodeset
# 或 video=LVDS-1:d 指定输出

# 永久（编辑 /etc/default/grub）：
# GRUB_CMDLINE_LINUX_DEFAULT 中加入 nomodeset
sudo sed -i 's/^GRUB_CMDLINE_LINUX_DEFAULT=.*/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash nomodeset"/' /etc/default/grub
sudo update-grub
```

> ℹ️ 此情况不常见，遇到再处理即可。此设备无独立显卡，黑屏多与视频输出初始化有关。

## 🪟 GTK4 应用窗口偏移

> 现象：部分 GTK4 应用（如新版本 GNOME 系应用）窗口位置偏移。

**解决**：在 MATE 控制中心 → 窗口 → 取消勾选**"启用软件合成窗口管理器"**。

**副作用**：窗口圆角消失。如需保留圆角，可对特定应用添加 `--disable-csd` 启动参数。

## 🖥️ MATE 桌面图标显示（主文件夹/回收站）

> 桌面默认可能不显示"主文件夹"和"回收站"图标，可手动启用。

### 方法一：通过桌面背景设置（图形界面）

1. 右键点击桌面空白处 → 选择 **"更改桌面背景"**。
2. 在弹出的窗口中，切换到 **"桌面"** 选项卡。
3. 在 **"桌面图标"** 部分，勾选：
   - **"显示主文件夹"**（或 Home）
   - **"显示回收站"**（或 Trash）
4. 点击 **"关闭"**，图标会立即出现在桌面上。

> 如果上述选项不可见，可能需要安装或更新 **caja** 文件管理器。

### 方法二：通过命令行（gsettings）

```bash
# 显示主文件夹
gsettings set org.mate.caja.desktop home-icon-visible true

# 显示回收站
gsettings set org.mate.caja.desktop trash-icon-visible true
```

如果 gsettings 提示键不存在，可尝试：

```bash
dconf write /org/mate/caja/desktop/home-icon-visible true
dconf write /org/mate/caja/desktop/trash-icon-visible true
```

执行后，图标应立刻出现在桌面上。如果未出现，可重启 caja-desktop 进程：

```bash
killall caja-desktop && caja-desktop &
```

### 📁 补充：启用"计算机"图标（可选）

如果需要在桌面上显示"计算机"（即此电脑），可以额外执行：

```bash
gsettings set org.mate.caja.desktop computer-icon-visible true
```

### 💡 注意事项

- 如果使用 `startx` 启动桌面，环境变量 `DISPLAY` 必须正确设置，否则 gsettings 命令可能无法生效（可在终端中先 `export DISPLAY=:0`）。
- 上述设置**永久生效**，即使重启桌面也不会丢失。

---
# 🖥️ 屏幕缩放比例设置脚本（set-scale.sh）

> 本仓库附带一个 **MATE 桌面缩放设置脚本**，方便在 1366x768 屏幕上自定义界面缩放比例。
> 适用于觉得界面太大/太小、想要快速调整显示比例的用户。

## 📥 使用方法

```bash
# 1. 下载脚本
wget https://raw.githubusercontent.com/MAXOUYT/CUBE-i10-WL-Ubuntu-Guide/main/set-scale.sh
# 或直接从仓库页面下载

# 2. 添加执行权限
chmod +x set-scale.sh

# 3. 运行（会询问选择缩放比例）
./set-scale.sh
```

## 🎛️ 可选缩放比例

| 选项 | 效果 | 适合场景 |
|---|---|---|
| **1) 50%** | 界面最小，显示内容最多 | 需要同时看很多内容（编程/文档）|
| **2) 75%** | 推荐，平衡显示与可读性 | 日常使用（当前默认）|
| **3) 100%** | 系统默认大小 | 视力较好 / 触屏操作 |
| **4) AUTO** | 自动适配（恢复默认）| 不确定用什么比例时 |
| **5) 自定义** | 输入任意百分比（如 60/80/120）| 以上都不满意时 |

## ⚙️ 脚本原理

同时设置四个参数实现整体缩放：
- **窗口缩放**（`org.mate.interface window-scaling-factor`）
- **文本缩放**（`org.gnome.desktop.interface text-scaling-factor`）
- **Xft.dpi**（写入 `~/.Xresources`，startx 启动时自动加载）
- **字体大小**（`org.mate.interface font-name`）

> 💡 脚本会自动修复 MATE 的 dconf-service 竞争问题（防止设置写入失败），应用后自动重启桌面环境生效。

## 🕐 什么时候用这个脚本？

- 屏幕上的文字/图标**太大或太小**，想整体缩放时
- 误设了 200% 等过大比例，**想快速恢复**时（选 4=AUTO 或输入正确比例）
- 在 1366x768 屏幕上觉得内容显示不下/显示不满时
- 每次想调整缩放时，**不用进控制面板**（控制面板可能因缩放过大点不到按钮），直接命令行运行本脚本

---
# 📋 许可证声明

| 组件 | 许可证 | 来源 |
|---|---|---|
| silead_fix.c / .ko | GPL v2 | 本项目原创 |
| fwtool / Firmware::Silead | GPL v2 | onitake/gsl-firmware |
| mssl1680.fw 固件 | 专有（Proprietary） | CUBE 官方 Windows 驱动提取 |

> ⚠️ 固件非开源，分享时需标注版权归原厂所有。

> <span style="color:red"><b>⚠️ 免责声明：本仓库所含 mssl1680.fw 固件版权归酷比魔方（CUBE）原厂所有，仅供个人学习与设备修复使用。若您是版权方并希望移除相关内容，请联系我们，我们将立即删除。</b></span>

---
*整合完成：安装前置须知 → 紧急启动 → 系统恢复 → 引导修复 → 驱动/固件 → 触屏完整修复 → 日常维护 → FAQ*