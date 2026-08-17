# 🧰 Assets 实用脚本

本目录存放 CUBE i10-WL 及同类设备常用的**实用脚本**，均经过实测验证。

| 脚本 | 功能 | 适用桌面环境 |
|---|---|---|
| [set-scale.sh](./set-scale.sh) | 屏幕缩放比例设置（50%/75%/100%/AUTO/自定义）| MATE |
| [restore-desktop-icons.sh](./restore-desktop-icons.sh) | 桌面图标恢复工具（主文件夹/回收站/此电脑/网络，支持数字组合选择）| MATE / GNOME / Cinnamon / XFCE |

---

## 🖥️ set-scale.sh — 屏幕缩放设置

> 在 1366x768 等小屏上自定义界面缩放比例（窗口缩放 + GTK 文本缩放 + Xft.dpi + 字体）。

```bash
wget https://raw.githubusercontent.com/MAXOUYT/CUBE-i10-WL-Ubuntu-Guide/main/Assets/set-scale.sh
chmod +x set-scale.sh
./set-scale.sh
```

| 选项 | 效果 |
|---|---|
| 1) 50% | 界面最小，显示内容最多 |
| 2) 75% | 推荐，平衡显示与可读性 |
| 3) 100% | 系统默认大小 |
| 4) AUTO | 自动适配 |
| 5) 自定义 | 输入 30-300 任意百分比 |

---

## 🗂️ restore-desktop-icons.sh — 桌面图标恢复工具

> 当**控制面板中没有对应开关**时，用脚本将「主文件夹」「回收站」「此电脑」「网络」图标恢复到桌面。
> 脚本会**自动检测桌面环境**（MATE/GNOME/Cinnamon/XFCE），并匹配对应的设置接口。

### 使用方法

```bash
# 1. 下载
wget https://raw.githubusercontent.com/MAXOUYT/CUBE-i10-WL-Ubuntu-Guide/main/Assets/restore-desktop-icons.sh
chmod +x restore-desktop-icons.sh

# 2. 交互模式：输入数字组合选择要恢复的图标（回车 = 全部）
./restore-desktop-icons.sh
```

### 数字组合选择

| 数字 | 图标 |
|---|---|
| 1 | 主文件夹 (Home) |
| 2 | 回收站 (Trash) |
| 3 | 此电脑 (Computer) |
| 4 | 网络 (Network) |

支持多种输入格式：`123`、`1 2 3`、`1,3`、`1、2`，直接回车 = 全部恢复。

### 其他用法

```bash
./restore-desktop-icons.sh 123        # 直接恢复 1+2+3
./restore-desktop-icons.sh 1,3        # 只恢复主文件夹 + 此电脑
./restore-desktop-icons.sh --hide 12  # 隐藏模式（隐藏主文件夹 + 回收站）
./restore-desktop-icons.sh --list     # 仅检测桌面环境（不做任何修改）
./restore-desktop-icons.sh --help     # 查看帮助
```

### 桌面环境自动检测

检测优先级（从高到低）：

1. `XDG_CURRENT_DESKTOP` 环境变量（标准，登录管理器会设置）
2. `DESKTOP_SESSION` / `GDMSESSION` 环境变量
3. **进程回退**：`pgrep` 查找 mate-session / gnome-session / cinnamon-session / plasmashell / xfce4-session / lxqt-session（覆盖 startx / 手动启动会话，如 i10）
4. 命令回退：`command -v` 检测已安装的会话命令

### 各桌面环境对应设置接口

| 桌面环境 | 设置接口 | 说明 |
|---|---|---|
| MATE | `org.mate.caja.desktop` | home/trash/computer/network-icon-visible |
| GNOME (新版) | `org.gnome.shell.extensions.ding` | show-home/show-trash/show-drives（DING 扩展）|
| GNOME (旧版) | `org.gnome.nautilus.desktop` | home/trash/computer/network-icon-visible |
| Cinnamon | `org.nemo.desktop` | home/trash/computer/network-icon-visible |
| XFCE | `xfconf-query` (xfdesktop) | /desktop-icons/file-icons |

> ⚠️ KDE / LXQt / Unity 环境的桌面图标由桌面部件/配置管理，脚本会检测并给出手动操作指引（暂不直接修改）。

### 图标不刷新怎么办

```bash
# MATE: 重启文件管理器
caja -r

# GNOME: 重启 Shell（Alt+F2 → r）
# XFCE: 重载桌面
xfdesktop --reload
```
