#!/bin/bash
# ============================================================
#  restore-desktop-icons.sh — 桌面图标恢复工具
#  功能: 将「主文件夹 / 回收站 / 此电脑 / 网络」等图标恢复到桌面
#        适用于控制面板中没有对应开关的桌面环境
#  用法:
#    ./restore-desktop-icons.sh           # 交互式: 输入数字组合选择
#    ./restore-desktop-icons.sh 123       # 直接恢复 1+2+3
#    ./restore-desktop-icons.sh 1 3       # 空格分隔也可以
#    ./restore-desktop-icons.sh --list    # 仅检测桌面环境(不改动)
#    ./restore-desktop-icons.sh --hide    # 隐藏模式(反向, 输入数字隐藏)
#  桌面环境: 自动检测 MATE / GNOME / Cinnamon / XFCE / KDE / LXQt
#  兼容: Ubuntu 20.04+ / Debian 11+ (依赖 gsettings 或 xfconf-query)
# ============================================================

# ---------- 0. 检测桌面环境 ----------
# 优先级: XDG_CURRENT_DESKTOP > DESKTOP_SESSION/GDMSESSION > 进程回退
detect_desktop() {
    local de=""

    # 1) XDG_CURRENT_DESKTOP (标准, 登录管理器会设置)
    case "${XDG_CURRENT_DESKTOP:-}" in
        *MATE*)       de="MATE" ;;
        *GNOME*)      de="GNOME" ;;
        *Cinnamon*)   de="Cinnamon" ;;
        *KDE*)        de="KDE" ;;
        *XFCE*)       de="XFCE" ;;
        *LXQt*)       de="LXQt" ;;
        *Unity*)      de="Unity" ;;
    esac
    [ -n "$de" ] && { echo "$de"; return; }

    # 2) DESKTOP_SESSION / GDMSESSION
    case "${DESKTOP_SESSION:-}${GDMSESSION:-}" in
        *mate*)       de="MATE" ;;
        *gnome*)      de="GNOME" ;;
        *cinnamon*)   de="Cinnamon" ;;
        *plasma*|*kde*) de="KDE" ;;
        *xfce*)       de="XFCE" ;;
        *lxqt*)       de="LXQt" ;;
        *ubuntu*)     de="Unity" ;;
    esac
    [ -n "$de" ] && { echo "$de"; return; }

    # 3) 进程回退 (startx / 手动启动的会话没有上述变量, 如 i10)
    for proc in "mate-session:MATE" "gnome-session:GNOME" "cinnamon-session:Cinnamon" \
                "plasmashell:KDE" "xfce4-session:XFCE" "lxqt-session:LXQt" "unity-session:Unity"; do
        local name="${proc%%:*}" val="${proc##*:}"
        if pgrep -x "$name" >/dev/null 2>&1 || pgrep -f "$name" >/dev/null 2>&1; then
            echo "$val"; return
        fi
    done

    # 4) 命令回退 (已安装的会话命令)
    for cmd in "mate-session:MATE" "gnome-session:GNOME" "cinnamon-session:Cinnamon" \
               "plasmashell:KDE" "xfce4-session:XFCE" "lxqt-session:LXQt"; do
        local c="${cmd%%:*}" v="${cmd##*:}"
        if command -v "$c" >/dev/null 2>&1; then
            echo "$v"; return
        fi
    done

    echo "未知"
}

# ---------- 1. 按桌面环境恢复/隐藏图标 ----------
# 用法: set_icon <环境> <图标id> <true|false>
# 图标id: 1=主文件夹 2=回收站 3=此电脑 4=网络
set_icon() {
    local DE="$1" id="$2" val="$3" cmd=""
    case "$DE" in
        MATE)  # org.mate.caja.desktop
            case "$id" in
                1) cmd="gsettings set org.mate.caja.desktop home-icon-visible $val" ;;
                2) cmd="gsettings set org.mate.caja.desktop trash-icon-visible $val" ;;
                3) cmd="gsettings set org.mate.caja.desktop computer-icon-visible $val" ;;
                4) cmd="gsettings set org.mate.caja.desktop network-icon-visible $val" ;;
            esac
            ;;
        GNOME)
            # 新版 GNOME(40+) 用 DING 扩展, 旧版用 nautilus
            if gsettings list-keys org.gnome.shell.extensions.ding >/dev/null 2>&1; then
                case "$id" in
                    1) cmd="gsettings set org.gnome.shell.extensions.ding show-home $val" ;;
                    2) cmd="gsettings set org.gnome.shell.extensions.ding show-trash $val" ;;
                    3) cmd="gsettings set org.gnome.shell.extensions.ding show-drives $val" ;;  # 近似"此电脑"
                    4) cmd="gsettings set org.gnome.shell.extensions.ding show-drives $val" ;;
                esac
            else
                case "$id" in
                    1) cmd="gsettings set org.gnome.nautilus.desktop home-icon-visible $val" ;;
                    2) cmd="gsettings set org.gnome.nautilus.desktop trash-icon-visible $val" ;;
                    3) cmd="gsettings set org.gnome.nautilus.desktop computer-icon-visible $val" ;;
                    4) cmd="gsettings set org.gnome.nautilus.desktop network-icon-visible $val" ;;
                esac
            fi
            ;;
        Cinnamon)  # org.nemo.desktop
            case "$id" in
                1) cmd="gsettings set org.nemo.desktop home-icon-visible $val" ;;
                2) cmd="gsettings set org.nemo.desktop trash-icon-visible $val" ;;
                3) cmd="gsettings set org.nemo.desktop computer-icon-visible $val" ;;
                4) cmd="gsettings set org.nemo.desktop network-icon-visible $val" ;;
            esac
            ;;
        XFCE)  # xfconf-query (xfdesktop)
            case "$id" in
                1) cmd="xfconf-query -c xfce4-desktop -p /desktop-icons/file-icons -s true" ;;
                2) cmd="xfconf-query -c xfce4-desktop -p /desktop-icons/file-icons -s true" ;;
                3) cmd="xfconf-query -c xfce4-desktop -p /desktop-icons/file-icons -s true" ;;
                4) cmd="xfconf-query -c xfce4-desktop -p /desktop-icons/file-icons -s true" ;;
            esac
            ;;
        *) return 2 ;;  # 不支持的环境
    esac

    if [ -n "$cmd" ]; then
        # shellcheck disable=SC2086
        eval "$cmd" 2>/dev/null
        echo "  ✅ [$DE] 图标 $id -> $val"
    fi
}

# ---------- 2. 解析用户输入 ----------
# 支持: 123 / 1 2 3 / 1,2,3 / 1、2、3  直接回车=全部
parse_input() {
    local raw="$1"
    # 去除非数字字符(保留 1-4), 去重
    local cleaned=$(echo "$raw" | tr -cd '1-4')
    local seen=""
    local out=""
    for ((i=0; i<${#cleaned}; i++)); do
        local ch="${cleaned:$i:1}"
        case "$seen" in
            *"$ch"*) ;;
            *) seen="$seen$ch"; out="$out$ch" ;;
        esac
    done
    echo "$out"
}

# ---------- 3. 主流程 ----------
MODE="show"   # show | hide | list
ARGS=""
for a in "$@"; do
    case "$a" in
        --list) MODE="list" ;;
        --hide) MODE="hide" ;;
        --help|-h)
            head -16 "$0" | grep '^#' | sed 's/^# *//'
            exit 0 ;;
        *) ARGS="$ARGS$a" ;;
    esac
done

DE=$(detect_desktop)
echo "=============================================="
echo "  🖥️  桌面图标恢复工具"
echo "  检测到桌面环境: $DE"
echo "=============================================="

if [ "$MODE" = "list" ]; then
    echo "  (仅检测模式, 未做任何修改)"
    echo "  XDG_CURRENT_DESKTOP=${XDG_CURRENT_DESKTOP:-<空>}"
    echo "  DESKTOP_SESSION=${DESKTOP_SESSION:-<空>}"
    echo "  GDMSESSION=${GDMSESSION:-<空>}"
    exit 0
fi

case "$DE" in
    MATE|GNOME|Cinnamon|XFCE)
        : ;;  # 支持
    KDE|LXQt|Unity)
        echo "⚠️  $DE 环境的桌面图标由桌面部件/配置管理, 本脚本暂不完全支持。"
        echo "   KDE: 系统设置 → 桌面行为 → 桌面图标 (或桌面部件 Desktop Icons)"
        echo "   LXQt: 桌面右键 → 桌面设置 → 图标"
        exit 1 ;;
    *)
        echo "❌ 无法识别的桌面环境, 请手动设置或检查 XDG_CURRENT_DESKTOP。"
        exit 1 ;;
esac

ACTION_TEXT="恢复"
[ "$MODE" = "hide" ] && ACTION_TEXT="隐藏"

# 直接传参(如 123)则跳过交互
if [ -n "$ARGS" ]; then
    SELECTION=$(parse_input "$ARGS")
    if [ -z "$SELECTION" ]; then
        echo "❌ 无效参数: $ARGS (请用 1-4 组合)"
        exit 1
    fi
else
    echo ""
    echo "  可选图标 (输入数字组合, 回车=全部):"
    echo "    1 = 主文件夹 (Home)"
    echo "    2 = 回收站   (Trash)"
    echo "    3 = 此电脑   (Computer)"
    echo "    4 = 网络     (Network)"
    echo "  ------------------------------------------"
    read -p "  请输入编号组合 [如 123 / 1 3 / 回车=全部]: " INPUT
    if [ -z "$INPUT" ]; then
        SELECTION="1234"
    else
        SELECTION=$(parse_input "$INPUT")
        if [ -z "$SELECTION" ]; then
            echo "❌ 无效输入: $INPUT (仅接受 1-4)"
            exit 1
        fi
    fi
fi

VAL="true"
[ "$MODE" = "hide" ] && VAL="false"

echo ""
echo "  >> 执行 $ACTION_TEXT: 图标 $(echo "$SELECTION" | sed 's/./& /g')"
echo ""
for ((i=0; i<${#SELECTION}; i++)); do
    id="${SELECTION:$i:1}"
    set_icon "$DE" "$id" "$VAL"
done

echo ""
echo "=============================================="
echo "  ✅ 完成! 若桌面图标未立即刷新:"
echo "     MATE:   按 F5 或运行 'caja -r' (重启文件管理器)"
echo "     GNOME:  按 Alt+F2 输入 'r' 重启 Shell"
echo "     XFCE:   运行 'xfdesktop --reload'"
echo "=============================================="
