#!/bin/bash
# ============================================================
#  CUBE i10-WL MATE 桌面缩放比例设置脚本
#  用法: ./set-scale.sh
#  功能: 选择缩放比例 (50%/75%/100%/AUTO/自定义), 应用后自动重启桌面
#  原理: 同时设置 MATE 窗口缩放 + GTK 文本缩放 + Xft.dpi + 字体
# ============================================================

# ---------- 0. 环境准备 ----------
if [ -z "$DISPLAY" ]; then
    export DISPLAY=:0
fi
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u)/bus"

# 修复已知坑: 多个 dconf-service 竞争导致 gsettings 写入被丢弃
DCOUNT=$(pgrep -c dconf-service 2>/dev/null || echo 0)
if [ "$DCOUNT" -gt 1 ]; then
    echo "⚠️ 检测到 $DCOUNT 个 dconf-service, 清理多余进程..."
    for pid in $(pgrep dconf-service | tail -n +2); do
        kill "$pid" 2>/dev/null || true
    done
    sleep 1
fi

# ---------- 1. 选择缩放比例 ----------
echo ""
echo "========================================"
echo "   CUBE i10-WL MATE 桌面缩放设置"
echo "========================================"
echo "  1) 50%   (最小, 显示内容最多)"
echo "  2) 75%   (推荐)"
echo "  3) 100%  (默认)"
echo "  4) AUTO  (自动适配, 系统默认)"
echo "  5) 自定义输入"
echo "----------------------------------------"
read -p "  请选择 [1-5]: " CHOICE

case "$CHOICE" in
    1) PCT=50 ;;
    2) PCT=75 ;;
    3) PCT=100 ;;
    4) PCT=AUTO ;;
    5)
        read -p "  请输入缩放百分比 (如 60 / 80 / 120): " PCT
        if ! echo "$PCT" | grep -qE '^[0-9]+$'; then
            echo "❌ 无效输入: $PCT"
            exit 1
        fi
        if [ "$PCT" -lt 30 ] || [ "$PCT" -gt 300 ]; then
            echo "⚠️ 范围建议 30-300, 输入 $PCT% 继续..."
        fi
        ;;
    *)
        echo "❌ 无效选项: $CHOICE"
        exit 1
        ;;
esac

# ---------- 2. 计算各设置值 ----------
if [ "$PCT" = "AUTO" ]; then
    # AUTO: 恢复系统默认 (window-scaling=0 自动, 文本 100%, dpi 96)
    WINDOW_SCALE=0
    TEXT_SCALE=1.0
    XFT_DPI=96
    FONT_SIZE=11
    echo ""
    echo ">> 选择: AUTO (自动适配)"
else
    # 窗口缩放: 非100%都设为1 (MATE只支持整数缩放, 细调交给文本缩放+dpi)
    WINDOW_SCALE=1
    # 文本缩放 = 百分比/100
    TEXT_SCALE=$(python3 -c "print('%.2f' % ($PCT/100.0))")
    # Xft.dpi = 96 * 百分比/100 (96 是标准 100% DPI)
    XFT_DPI=$(python3 -c "print(int(round(96*$PCT/100.0)))")
    # 字体大小 = 11 * 百分比/100, 最小 6
    FONT_SIZE=$(python3 -c "print(max(6, int(11*$PCT/100.0 + 0.5)))")
    echo ""
    echo ">> 选择: $PCT%  (文本缩放 $TEXT_SCALE, DPI $XFT_DPI, 字体 $FONT_SIZE)"
fi

# ---------- 3. 应用设置 ----------
echo ""
echo "[1/4] 写入 gsettings..."

# 备份当前 dconf
cp ~/.config/dconf/user ~/.config/dconf/user.backup 2>/dev/null && echo "  ✅ dconf 已备份 (user.backup)"

# 窗口缩放
gsettings set org.mate.interface window-scaling-factor "$WINDOW_SCALE" 2>/dev/null
echo "  ✅ window-scaling-factor = $WINDOW_SCALE"

# 文本缩放
gsettings set org.gnome.desktop.interface text-scaling-factor "$TEXT_SCALE" 2>/dev/null
echo "  ✅ text-scaling-factor = $TEXT_SCALE"

# 字体
gsettings set org.mate.interface font-name "Ubuntu $FONT_SIZE" 2>/dev/null
echo "  ✅ font-name = Ubuntu $FONT_SIZE"

echo "[2/4] 写入 Xft.dpi..."
# 更新 ~/.Xresources (startx 启动时自动加载)
if [ -f ~/.Xresources ]; then
    sed -i '/Xft\.dpi/d' ~/.Xresources
fi
echo "Xft.dpi: $XFT_DPI" >> ~/.Xresources
echo "  ✅ ~/.Xresources: Xft.dpi = $XFT_DPI"

# 应用到当前 X 会话
xrdb -remove Xft.dpi 2>/dev/null || true
echo "Xft.dpi: $XFT_DPI" | xrdb -merge 2>/dev/null || true
echo "  ✅ 当前会话已应用"

echo "[3/4] 验证设置..."
echo -n "  window-scaling: "; gsettings get org.mate.interface window-scaling-factor
echo -n "  text-scaling:   "; gsettings get org.gnome.desktop.interface text-scaling-factor
echo -n "  font:           "; gsettings get org.mate.interface font-name
echo -n "  Xft.dpi:        "; xrdb -query 2>/dev/null | grep -i dpi

# ---------- 4. 自动重启桌面环境 ----------
echo ""
echo "[4/4] 重启桌面环境..."
echo "  正在注销并重新登录, 请稍候..."
sleep 2

# 触发 MATE 注销 (保留 X 服务器, 重新登录)
if command -v mate-session-save >/dev/null 2>&1; then
    mate-session-save --logout >/dev/null 2>&1 || true
else
    pkill -TERM mate-session 2>/dev/null || true
fi

echo ""
echo "========================================"
echo "  ✅ 设置完成! 桌面即将重启"
echo "  缩放比例: $PCT%"
echo "  若登录后无变化, 请手动注销重登一次"
echo "========================================"
