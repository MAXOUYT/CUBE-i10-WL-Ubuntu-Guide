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
- [第二十阶段：桌面工具推荐（压缩/文本/办公/蓝牙）](#第二十阶段桌面工具推荐压缩文本办公蓝牙)
  - [🖥️ MATE 桌面环境安装说明（非常规安装）](#️-mate-桌面环境安装说明非常规安装)
  - [📱 现代软件推荐（GTK4）](#-现代软件推荐gtk4)
- [第二十一阶段：软件安装与包管理建议](#第二十一阶段软件安装与包管理建议)
- [第二十二阶段：外放（板载声卡）未修复说明](#第二十二阶段外放板载声卡未修复说明)
- [📋 常见问题（FAQ）](#-常见问题faq)
  - [🖥️ MATE 桌面图标显示（主文件夹/回收站）](#️-mate-桌面图标显示主文件夹回收站)
- [📋 许可证声明](#-许可证声明)

---
# 📖 关于本手册

> <img src="https://img.shields.io/badge/%E2%9A%A0%EF%B8%8F%20%E7%89%88%E6%9D%83%E5%A3%B0%E6%98%8E-%E5%9B%BA%E4%BB%B6%E5%BD%92%E9%85%B7%E6%AF%94%E9%AD%94%E6%96%B9(CUBE)%E5%8E%9F%E5%8E%82%E6%89%80%E6%9C%89-red?style=for-the-badge" alt="版权声明"><br>
> <img src="https://img.shields.io/badge/%E7%94%A8%E9%80%94-%E4%BB%85%E4%BE%9B%E4%B8%AA%E4%BA%BA%E5%AD%A6%E4%B9%A0%E4%B8%8E%E8%AE%BE%E5%A4%87%E4%BF%AE%E5%A4%8D-darkred?style=for-the-badge" alt="用途"><br>
> <img src="https://img.shields.io/badge/%E7%89%88%E6%9D%83%E6%96%B9-%E8%AF%B7%E8%81%94%E7%B3%BB%E6%88%91%E4%BB%AC%E7%AB%8B%E5%8D%B3%E5%88%A0%E9%99%A4-red?style=for-the-badge" alt="版权方">

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

### 🧩 BIOS 完整操作指南（Boot Manager / SCU 详解）

> 📋 本节为 i10-W 的 BIOS 操作完整指南，基于实际排查经验整理。

#### 🔑 如何进入 BIOS？

- **进入启动菜单**：开机时连续点按 ESC 键。
- **进入 BIOS 设置界面（SCU）**：在启动菜单中，选择 **SCU** 即可进入真正的 BIOS 高级设置。

> ⚠️ **强烈建议使用有线键盘**。现代高性能无线键鼠在 BIOS 下可能因 USB 轮询率不兼容导致按键失灵（例如无线键盘的 ESC 或回车键无反应）。实测有线键盘最稳妥。

#### 📋 按下 ESC 后进入的界面是什么？

这是 **启动管理器（Boot Manager）**，用于临时选择本次从哪个设备启动，**不修改 BIOS 永久设置**。

#### 🔘 启动菜单各选项功能

| 选项 | 功能 |
|---|---|
| **Continue** | 正常启动系统 |
| **Boot Manager** | 选择启动设备（U盘、硬盘等）|
| **Device Management** | 查看硬件 ID，一般用不上 |
| **Boot From File** | 手动选择引导文件，我们当时通过此入口加载了 `/EFI/BOOT/bootia32.efi`，成功绕过 BIOS 限制 |
| **Secure Boot Option** | 安全启动设置入口（但不如 SCU 里全面）|
| **SCU** | 真正的 BIOS 高级设置界面 |

#### ⚙️ 真正的 BIOS 界面（SCU）关键设置

进入 SCU 后，顶部有多个选项卡，调整过的核心设置如下：

**主画面**

- 可在此修正系统时间（原 CMOS 电池没电导致时间重置）

**进阶（Advanced）**

- **Legacy USB Support → Enabled**（开启），否则 USB 键盘在 BIOS 下可能无法使用。

**开机（Boot）**

- **EFI 裝置為先 → 停用**（最关键的一步，强制使用传统引导模式）
- **USB 開機 → 啟用**
- **Windows® 8 Fast Boot → 停用**（老设备开此功能易导致 USB 失灵）

**安全（Security）**

- **Secure Boot → Disabled**（禁用）
- 对于 Insyde BIOS，有时需要先设置一个管理员密码（Set Supervisor Password），才能修改 Secure Boot 的开关。设置密码后，Secure Boot 选项才会变为可编辑状态。

**为什么必须禁用 Secure Boot？**

- 安装的是**第三方操作系统（Ubuntu）**，不是预装的 Windows。Secure Boot 开启时会阻止未签名的引导程序（如 bootia32.efi）和内核加载。
- 能成功引导 64 位 Linux，Secure Boot 大概率已经被禁用。如果不确定，进去确认一下即可。

**操作系统（OS Configuration / OS Selection）**

- **OS Configuration**（或类似名称的选项）→ 选择 **winOS and Ubuntu**
- 这个选项告诉 BIOS 你将使用哪种操作系统。我们当时在 SCU 的"进阶"或"主画面"选项卡中找到了它，并将其从默认的 **winOS and Android** 改为了 **winOS and Ubuntu**。

**为什么需要改这个？**

- 这台设备原厂是 Windows + Android 双系统，BIOS 默认配置为 Android 模式。
- 改为 winOS and Ubuntu 后，BIOS 会为 Linux 内核提供更匹配的 **ACPI（电源管理）**和硬件初始化参数，能有效避免装完系统后出现睡死、无法关机、电池电量不显示等问题。

**离开（Exit）**

- 调整完所有设置后，按 **F10** 保存并退出。

#### ⌨️ 快捷键提示

| 按键 | 功能 |
|---|---|
| **F1** | 帮助 |
| **ESC** | 返回上一级 |
| **F5 / F6** | 调整数值（如启动顺序）|
| **Enter** | 选择/确认 |
| **F9** | 恢复默认设置 |
| **F10** | 保存并退出 |

#### 🧠 为什么是这些设置？

当时遇到的死结是：**BIOS 是 32 位 UEFI，但想装 64 位 Linux**。默认的 **EFI 裝置為先** 会让 BIOS 只认 64 位引导文件（bootx64.efi），导致卡死。将该项**停用**后，BIOS 会尝试传统引导方式，配合 **Boot From File** 手动加载 32 位引导文件（bootia32.efi），最终成功引导 64 位系统。

而 **Secure Boot 的禁用**，则确保了未签名的 bootia32.efi 和 Linux 内核能够被系统接受并加载。操作系统选项改为 **winOS and Ubuntu** 则进一步优化了 BIOS 对 Linux 的电源管理和硬件支持，避免出现挂起/休眠异常、电池电量读取错误等问题。

> 💡 如果用无线键盘操作无效，**果断换有线键盘**——这是最省时间的做法。

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

- Ventoy 为了兼容性，官方已内置 32 位引导文件 **`bootia32.efi`**（位于 `/EFI/BOOT/` 目录）。注意：**`bootx64.efi` 是 64 位引导文件，用它启动无法进入 Ventoy 菜单**——这台 32 位 UEFI 机器必须用 bootia32.efi。
- 这台机器的 BIOS 自动扫描时只会尝试 64 位文件（卡死），但只要在 **Boot From File** 中手动指定路径，指向这个自带的 32 位 `bootia32.efi`，它就能正常加载 Ventoy 菜单。
- 网上下载的 bootia32.efi 是 **GRUB 引导器**，主要用于**系统安装完成后**引导硬盘上的 Ubuntu，而不是用来启动 Ventoy。

> 🔧 **避免卡死的操作建议**：
> 1. 可以**先进入启动管理器（Boot Manager）后，再接入 U 盘**，避免 BIOS 自动扫描时卡在 64 位文件上。
> 2. **更好的做法**：将 64 位的 `bootx64.efi` 移出 Ventoy U 盘的 `/EFI/BOOT/` 目录（最好不要让它存在于 U 盘里），这样 BIOS 扫描时找不到 64 位文件，就不会出现卡死情况。
> 3. **兜底方案**：如果系统没有进入 Ventoy 菜单，再从 **Boot From File** 中选中 `bootia32.efi` 启动 Ventoy 菜单。

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

> 📦 触屏驱动修复包（含脚本/固件/双参数配置）见：**[触屏驱动及校准配置说明](触屏驱动及校准配置/README.md)** ← 点击跳转独立页面

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
- 安装 **uBlock Origin 或 AdGuard** 拦截广告和追踪器。
- 限制同时打开的标签页数量（建议不超过 3-5 个）。

### Firefox
- 启用 **"自动卸载不活跃标签页"**（`about:preferences` → 性能 → 取消勾选"使用推荐的性能设置" → 勾选"自动卸载不活跃标签页"）。
- 安装 **uBlock Origin 或 AdGuard**。

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
# 第二十阶段：桌面工具推荐（压缩/文本/办公/蓝牙）

> 针对 2GB 内存的 Bay Trail 设备，推荐轻量级桌面工具，替代启动缓慢的大型软件。
> 以下方案按推荐度排序，标注"已实测"的均已在 CUBE i10-WL 上验证通过。

---

## 🖥️ MATE 桌面环境安装说明（非常规安装）

> ⚠️ 由于 Ubuntu 26.04 的软件源中 MATE 元包存在依赖冲突，无法通过常规方式直接安装完整的 MATE 桌面。本文档采用分步安装核心组件的方式，因此最终桌面环境**缺少部分默认预装软件**（如文本编辑器、归档管理器等），需要手动补充。

### 🧠 为什么不能直接安装 ubuntu-mate-desktop？

```bash
# 以下命令会失败（依赖冲突）
sudo apt install ubuntu-mate-desktop
```

**失败原因**：

- ubuntu-mate-desktop 元包依赖大量组件，其中部分包与 Ubuntu 26.04 的系统库版本不兼容。
- 关键冲突包括 **bzip2、python3-gi、dbus-x11** 等核心依赖。

### ✅ 实际成功安装方式

**第一步：使用 aptitude 解决依赖并安装核心组件**

```bash
sudo apt install aptitude -y
sudo aptitude install mate-desktop-environment-core
```

在 aptitude 交互式解决依赖时，选择降级少数冲突库的方案（通常默认即可），安装 MATE 核心桌面环境。

若 aptitude 方案不可用，可尝试直接安装核心组件（可能缺少部分功能）：

```bash
sudo apt install mate-desktop mate-session-manager mate-panel mate-terminal caja marco -y
```

**第二步：安装显示管理器（可选，本文档使用 startx 启动）**

```bash
sudo apt install lightdm -y   # 可选，本文档最终使用 startx 启动桌面
```

**第三步：配置 startx 启动桌面**

```bash
echo "exec mate-session" > ~/.xinitrc
```

之后在 TTY 中输入 `startx` 即可启动 MATE 桌面。

### 📦 桌面环境安装后缺少的软件（需手动补充）

由于安装的是"核心组件"而非完整元包，以下软件需手动安装：

| 类别 | 缺失软件 | 推荐替代方案 |
|---|---|---|
| 文本编辑器 | pluma（MATE 默认）| CorePad（Flatpak，已实测）或 pluma |
| 归档管理器 | engrampa（MATE 默认）| ark（APT，已实测）或命令行工具 |
| 系统监视器 | mate-system-monitor | 已安装 htop、btop（可选）或 Resources（Flatpak）|
| 截图工具 | mate-screenshot | gnome-screenshot 或 flameshot |
| 计算器 | mate-calc | gnome-calculator 或 qalculate-gtk |

### 🔧 补充安装推荐（已实测可用的配置）

```bash
# 文本编辑器（已实测）
flatpak install flathub org.cubocore.CorePad

# 归档管理器（已实测）
sudo apt install ark -y

# 系统监视器（已实测）
flatpak install flathub net.nokyan.Resources

# 截图工具（可选）
sudo apt install gnome-screenshot -y

# 计算器（可选）
sudo apt install gnome-calculator -y
```

### 📋 验证桌面环境是否完整

安装完成后，可通过以下命令检查常用桌面组件是否已就绪：

```bash
# 检查 MATE 核心组件
mate-session --version
caja --version

# 检查已安装的桌面应用
ls /usr/share/applications/ | grep -E "pluma|engrampa|mate-terminal|caja"
```

### 💡 为什么采用这种方式安装？

- 常规 ubuntu-mate-desktop 无法安装（依赖冲突）。
- mate-desktop-environment-core 是最小化安装，只包含桌面核心，不包含任何"额外"的应用程序。
- 这符合 2GB 内存设备的轻量化需求，避免了安装大量不需要的预装软件。
- 用户可以根据实际需要选择性补充软件，而不是被强制安装一堆用不上的工具。

---

## 🗂️ 压缩包管理器

### ✅ 方案一：ark（KDE 解压工具，已实测可用）

```bash
sudo apt install ark -y
```

- **优点**：依赖较少，在 MATE 下运行稳定，支持常见格式（zip、tar、7z、rar 等）。
- **实测状态**：已在 CUBE i10-WL 上验证通过。

### 🟡 方案二：命令行解压（最轻量，无需图形界面）

如果图形工具安装失败或不需要图形界面，可用命令行：

```bash
# 安装必要工具（大部分已预装）
sudo apt install unzip p7zip-full unrar -y

# 常用解压命令
unzip file.zip          # 解压 .zip
tar -xzf file.tar.gz    # 解压 .tar.gz
tar -xjf file.tar.bz2   # 解压 .tar.bz2
unrar x file.rar        # 解压 .rar
7z x file.7z            # 解压 .7z
```

### ⚠️ 备选方案（可能因依赖问题无法安装）

以下工具在 Ubuntu 26.04 上可能因 bzip2 依赖冲突而无法安装，仅作记录：

- file-roller（GNOME 归档管理器）
- engrampa（MATE 归档管理器）
- xarchiver

> 如果上述工具安装失败，直接使用**方案一（ark）**或**方案二（命令行）**即可。

## 📄 文本查看器/编辑器（轻量级）

用于快速打开 .txt 等纯文本文件，替代启动缓慢的 LibreOffice。

### ✅ 方案一：CorePad（已实测可用，Flatpak）

```bash
flatpak install flathub org.cubocore.CorePad
```

- **优点**：轻量、启动快、支持语法高亮、界面现代。
- **实测状态**：已在 CUBE i10-WL 上验证通过，设置为默认文本编辑器后双击 .txt 文件即可快速打开。

### 🟡 备选方案（其他 Flatpak 轻量编辑器）

```bash
# Mousepad（Xfce 默认编辑器，极轻量）
flatpak install flathub org.xfce.mousepad

# Janus（Leafpad 继承者，极简）
flatpak install flathub dev.pantheum.janus
```

### 📦 系统自带方案（已预装或轻量）

- **Pluma**：MATE 默认文本编辑器（`sudo apt install pluma`），启动速度尚可。
- **Nano**：命令行文本编辑器（已预装），适合快速编辑配置文件。

## 📄 办公套件（LibreOffice）

> MATE 桌面环境下，LibreOffice 是推荐使用的办公套件。由于 2GB 内存设备的限制，安装方式**推荐优先使用 Flatpak 版本**（已实测通过），以避免与系统 Python 版本的依赖冲突。

### ✅ 方案一：Flatpak 版（推荐，已实测可用）

```bash
flatpak install flathub org.libreoffice.LibreOffice
```

- **优点**：自带运行环境，不受系统 Python 版本影响，已在 CUBE i10-WL 上验证通过。
- **启动方式**：在 MATE 菜单中找到 LibreOffice 组件，或终端运行 `flatpak run org.libreoffice.LibreOffice`。
- **首次启动**：可能需要 10-20 秒初始化，属于正常现象。

### ⚠️ 方案二：APT 版（可能因依赖冲突无法安装）

```bash
sudo apt install libreoffice -y
```

- **已知问题**：在 Ubuntu 26.04 上，libreoffice 依赖 python3-uno，而 python3-uno 需要 python3 (< 3.13)，但系统默认 Python 版本为 3.13+，可能导致安装失败。
- **如果遇到依赖错误**：直接使用方案一（Flatpak 版）。

### ⚙️ 性能优化建议（2GB 内存设备）

LibreOffice 在低内存设备上可能运行较慢，可通过以下设置改善：

1. **关闭动画效果**：
   - 打开 LibreOffice → 工具 → 选项 → 视图。
   - 取消勾选 **"使用动画"** 和 **"平滑滚动"**。
2. **调整 Java 内存分配**（如果启用 Java）：
   - 工具 → 选项 → 高级 → Java 选项。
   - 将 Java 运行时内存限制设为 **256MB 或更低**。
3. **禁用自动更新检查**：
   - 工具 → 选项 → 在线更新 → 取消勾选 **"自动检查更新"**。

### 📋 轻量级替代方案（可选）

如果 LibreOffice 仍然感觉沉重，可考虑以下轻量级办公套件：

| 名称 | 适用场景 | 安装命令 |
|---|---|---|
| **AbiWord** | 轻量级文字处理 | `sudo apt install abiword -y` |
| **Gnumeric** | 轻量级电子表格 | `sudo apt install gnumeric -y` |

> 这些工具功能较精简，但启动速度更快，适合低配设备。

## 📱 现代软件推荐（GTK4）

> 💡 如果你希望在 Bay Trail 这类老设备上获得接近 Ubuntu Desktop 26.04 的现代软件体验，可以尝试以下方案。这些软件已在本文档的测试设备上验证通过（2GB 内存 + Bay Trail 平台），但需注意渲染性能可能略有下降。

### ✅ 推荐安装的现代软件

| 软件 | 功能 | 安装方式 | 说明 |
|---|---|---|---|
| **Resources** | 系统资源监视器（与 Ubuntu Desktop 26.04 一致）| Flatpak | 基于 GTK4 + libadwaita，界面现代（GPU/电池数据有平台限制，见下）|
| **Ptyxis** | 终端模拟器（与 Ubuntu Desktop 26.04 一致）| Flatpak | 基于 GTK4 + libadwaita，GNOME 默认终端 |

```bash
# 安装 Resources
flatpak install flathub net.nokyan.Resources

# 安装 Ptyxis
flatpak install flathub app.devsuite.Ptyxis
```

### ⚠️ 已知问题：GTK4 "隐形墙"现象

由于 Resources 和 Ptyxis 均基于 GTK4 构建，在 MATE 桌面环境（使用 Marco 窗口管理器）下运行时，可能会遇到窗口顶部出现 **"隐形墙"**（约 10-20 像素的不可见区域），导致窗口拖动时鼠标位置偏移。

**原因**：

- GTK4 应用默认使用客户端装饰（CSD，Client-Side Decoration），而 MATE 的 Marco 窗口管理器也提供自己的窗口边框。
- 两者叠加导致窗口布局计算出现偏移。

**解决方法**：

- **最简单有效**：将窗口最大化（点击右上角最大化按钮），然后还原（再次点击最大化按钮），偏移问题即可消失。
- 如果问题频繁出现，可在 **MATE 控制中心 → 窗口 → 取消勾选"启用软件合成窗口管理器"**。但此操作会导致所有窗口的圆角消失。

### 📊 性能说明

| 软件 | 资源占用（空闲状态）| 备注 |
|---|---|---|
| **Resources** | 约 150-250MB 内存 | 实时监控时 CPU 占用约 3-5% |
| **Ptyxis** | 约 50-100MB 内存 | 打开多个标签页时内存略有增加 |

> 在 2GB 内存设备上，同时运行这俩软件加上浏览器时需注意内存使用，建议在需要系统监控或终端操作时单独使用。

### 📋 补充说明

- 如果上述应用启动缓慢，可尝试清理 Flatpak 缓存：`flatpak uninstall --unused`。
- 若 Ptyxis 动画卡顿明显，可在 `~/.config/ptyxis/` 中调整渲染设置，或切换回 mate-terminal 作为备选。

### ⚠️ 已知限制（Bay Trail 平台）

**GPU 计数器不可用**：

- Resources 的 GPU 监控功能并非完整——Bay Trail（Z3735F）这类老平台的 GPU **缺少性能计数器**，所有相关的性能监测软件（Resources、btop、htop 的 GPU 模块等）**都无法读取 GPU 数据**。这是硬件限制，非软件问题。

**电池数据部分不可用**：

- 若为新电池，只能读取**部分数据**。
- **不可用**：电池健康（health）、设计容量（energy-full-design）、制造商、型号名称——这些属性取决于电池厂商是否写入固件数据。
- **可用**：电池使用/充电功耗数据、电池设备属性、电池容量、状态（是否充电）。

> 💡 电池数据详情见[第十九阶段：电池状态查看](#第十九阶段电池状态查看日常维护)。

### 🔧 备选方案：使用系统原生软件

如果 GTK4 应用在您的设备上性能不佳，可退回使用 MATE 自带的软件：

- **系统监视器**：mate-system-monitor（系统自带，轻量）
- **终端**：mate-terminal（系统自带，基于 GTK3，资源占用更低）

> 它们虽然在视觉上不如 GTK4 应用现代，但在 Bay Trail 平台上的运行更流畅。

## 🐦 蓝牙管理器

用于在 MATE 桌面下配对和管理蓝牙设备（耳机、音箱等）。

### ✅ 方案一：Bluejay（已实测可用，Flatpak）

```bash
flatpak install flathub io.github.ebonjaeger.bluejay
```

- **优点**：界面简洁直观，支持扫描、配对、连接、信任/阻止设备。
- **实测状态**：已在 CUBE i10-WL 上验证通过，连接蓝牙音箱正常。
- **权限说明**：首次运行后如需授予权限，可在终端执行 `flatpak run io.github.ebonjaeger.bluejay` 启动。

### 🟡 备选方案（其他蓝牙管理器）

```bash
# BudsLink（专注于蓝牙耳机）
flatpak install flathub io.github.maniacx.BudsLink

# Overskride（蓝牙 + OBEX 客户端，功能更强，但需手动安装）
# 项目地址：https://github.com/Overskride/Overskride
```

### 📦 命令行方案（最可靠，不受图形界面依赖影响）

如果图形工具无法扫描到设备，可用 bluetoothctl 命令：

```bash
bluetoothctl
power on
scan on          # 扫描设备
pair <MAC地址>   # 配对
connect <MAC地址>
trust <MAC地址>
exit
```

### 🐧 蓝牙排查经验总结（基于实际排查过程）

#### ✅ 当前状态

- 蓝牙硬件（hci0）可正常识别，服务默认启用。
- 图形化管理工具通过 Flatpak 版 Bluejay 实现，功能完整（扫描、配对、连接、信任）。
- AAC 编码支持需通过第三方 PPA 额外安装（详见手册第十六阶段）。

#### ❌ 可能遇到的问题及原因

1. **图形工具无法安装**
   - blueman、gnome-control-center 因 Python 版本依赖冲突（python3 < 3.13）无法通过 APT 安装。
   - **解决**：优先使用 Flatpak 版 Bluejay（`io.github.ebonjaeger.bluejay`）。
2. **蓝牙服务未启动**
   - 执行 `sudo systemctl status bluetooth` 检查，若未运行则 `sudo systemctl start bluetooth`。
3. **设备被锁定（rfkill）**
   - `rfkill list` 显示 `Soft blocked: yes` 时，执行 `sudo rfkill unblock bluetooth`。
4. **扫描不到设备**
   - 先确认 `bluetoothctl scan on` 能否扫描到，能则说明硬件正常，问题在图形工具权限。
   - Flatpak 应用需确保已授予蓝牙权限（Bluejay 默认已申请，无需额外配置）。
5. **音频编码只有 SBC**
   - 系统默认不包含 AAC/aptX 编码器，需通过 pipewire-extra-bt-codecs PPA 手动安装 AAC 支持（见手册第十六阶段）。

#### 🔧 建议排查顺序

1. 检查服务状态：`sudo systemctl status bluetooth`
2. 检查硬件锁定：`rfkill list`
3. 命令行测试：`bluetoothctl scan on`
4. 图形工具：Flatpak 安装 Bluejay
5. 音频编码：按需安装 AAC 支持（非必需）

#### 💡 特别提醒

- **声卡问题与蓝牙无关**：系统显示"虚拟输出"是板载声卡未驱动，不影响蓝牙音频（蓝牙设备会单独显示）。
- **磁吸散热器干扰**：磁吸散热器可能触发霍尔传感器休眠，导致蓝牙断连（详见 FAQ）。
- **Flatpak 网络劫持**：若 `flatpak install` 卡住，检查 HTTP 请求是否被劫持（详见手册第十七阶段）。

---
# 第二十一阶段：软件安装与包管理建议

## 📦 包管理使用建议

### 优先级原则

| 优先级 | 方案 | 适用场景 |
|---|---|---|
| **首选** | apt | 系统组件、轻量工具、依赖简单的软件 |
| **次选** | flatpak | 图形应用、依赖复杂或与系统版本冲突的软件 |
| **万不得已** | snap | 仅当 apt 和 flatpak 均无法安装时使用 |

**原因**：

- snap 包在 Bay Trail 这类老设备上流畅度明显下降，且占用更多磁盘空间和内存。
- flatpak 虽然也占用额外空间，但启动速度和资源占用通常优于 snap。
- apt 与系统集成度最高，资源占用最少，优先使用。

### 🧹 清理命令

```bash
# APT 清理
sudo apt autoremove          # 移除不需要的依赖包
sudo apt clean               # 清理本地软件包缓存
sudo apt autoclean           # 清理过时的缓存包

# Flatpak 清理
flatpak uninstall --unused   # 移除不再需要的运行时
flatpak repair               # 修复并清理损坏的 Flatpak 数据
```

### 💡 软件安装示例

```bash
# 优先尝试 apt
sudo apt install <软件名>

# 遇到依赖错误时，尝试 flatpak
flatpak install flathub <应用ID>

# 万不得已时，才考虑 snap
sudo snap install <软件名>
```

---
# 第二十二阶段：外放（板载声卡）未修复说明

> 📌 关于外放（板载声卡）的当前状态与排查建议。**未来会持续对设备进行排查，本文档将不断更新**，并声明问题属于**硬件原因**（缺少驱动无法通信、焊盘脱落等）还是**系统依赖问题**。

## 现状

目前这台设备的外放（板载声卡）尚未修复，系统仅显示**"虚拟输出"**，无法通过内置扬声器或 3.5mm 耳机孔发声。

## 不确定的原因

1. **硬件可能损伤**：早期曾自行重新焊接扬声器端子（纠正原厂左右声道反接），可能因操作不当导致焊盘脱落或芯片受损。但当时焊接的是扬声器端子焊盘，未碰声卡芯片本身，且 Windows 下曾识别为"未知设备"，说明芯片可能仍在通信。
2. **系统软件问题**：Linux 下板载声卡（常见型号 ALC5640 / RT5640）的驱动需依赖 ACPI、固件、DSP 等多个层面，在 Bay Trail 平台上经常出现 ACPI 表缺失或 I²C 通信失败，导致驱动无法完成初始化。

## 排查方向（由易到难）

### 🔧 软件层面（优先尝试）

**1. 检查 ALSA 声卡列表**

```bash
aplay -l
cat /proc/asound/cards
```

> 若只显示 HDMI 音频，说明板载声卡未被注册。

**2. 手动加载声卡驱动模块**

```bash
sudo modprobe snd_soc_sst_bytcr_rt5640
sudo modprobe snd_soc_sst_cht_bsw_rt5645
sudo modprobe snd_soc_skl
```

观察 `dmesg | tail` 是否有错误（如 i2c timeout、acpi device not found）。

**3. 检查固件是否缺失**

```bash
ls /lib/firmware/intel/ | grep -i "sof\|sst"
```

确保 firmware-sof-signed 已安装：`sudo apt install firmware-sof-signed`。

**4. 添加内核参数**（若驱动无法绑定 ACPI 设备）

在 `/etc/default/grub` 的 `GRUB_CMDLINE_LINUX_DEFAULT` 中添加：

```
snd_soc_sst_bytcr_rt5640.acpi_device_name=10EC5640
```

然后 `sudo update-grub` 并重启。

**5. 尝试强制指定 quirk**（若模块支持）

```bash
sudo modprobe -r snd_soc_sst_bytcr_rt5640
sudo modprobe snd_soc_sst_bytcr_rt5640 quirk=0x4004
```

**6. 检查 I²C 通信**

```bash
sudo dmesg | grep -i i2c | grep -i error
```

> 若出现 timeout 或 -EIO，可能引脚接触不良或芯片供电异常。

### 🩺 硬件检测（确认是否物理损坏）

- **插入 USB 声卡测试**：若系统能正常识别且发声正常，则说明系统音频栈正常，问题在板载声卡本身（硬件或固件）。
- **检查焊点**：使用放大镜检查扬声器端子焊点是否虚焊、脱落或短路。
- **测量通断**：用万用表测量声卡芯片相关引脚与主控之间的通路（需电路图，操作风险高）。

## 备选方案（绕过板载声卡）

- **USB 声卡**：即插即用，无需驱动，音质稳定。
- **蓝牙音箱/耳机**：若蓝牙已配置（见第十六阶段），可通过蓝牙输出音频。
- **HDMI 音频**：若使用 HDMI 外接显示器，可通过 HDMI 输出音频（已在 `aplay -l` 中显示）。

## 最终说明

- 本手册不保证软件修复一定成功，若尝试上述软件方案后仍无效，大概率是硬件原因，建议接受现状或使用替代方案。
- 若后续有用户成功修复，欢迎贡献修复方法。
- **持续更新声明**：未来会持续对设备进行排查，本文档将不断更新，并明确标注问题属于硬件原因还是系统依赖问题。

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

> <img src="https://img.shields.io/badge/%E2%9A%A0%EF%B8%8F%20%E7%89%88%E6%9D%83%E5%A3%B0%E6%98%8E-%E5%9B%BA%E4%BB%B6%E5%BD%92%E9%85%B7%E6%AF%94%E9%AD%94%E6%96%B9(CUBE)%E5%8E%9F%E5%8E%82%E6%89%80%E6%9C%89-red?style=for-the-badge" alt="版权声明"><br>
> <img src="https://img.shields.io/badge/%E7%94%A8%E9%80%94-%E4%BB%85%E4%BE%9B%E4%B8%AA%E4%BA%BA%E5%AD%A6%E4%B9%A0%E4%B8%8E%E8%AE%BE%E5%A4%87%E4%BF%AE%E5%A4%8D-darkred?style=for-the-badge" alt="用途"><br>
> <img src="https://img.shields.io/badge/%E7%89%88%E6%9D%83%E6%96%B9-%E8%AF%B7%E8%81%94%E7%B3%BB%E6%88%91%E4%BB%AC%E7%AB%8B%E5%8D%B3%E5%88%A0%E9%99%A4-red?style=for-the-badge" alt="版权方">

---
*整合完成：安装前置须知 → 紧急启动 → 系统恢复 → 引导修复 → 驱动/固件 → 触屏完整修复 → 日常维护 → FAQ*