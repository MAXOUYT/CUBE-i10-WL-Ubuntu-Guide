#!/bin/bash
# ============================================================
# fix-audio-volume.sh - i10 音量映射修复脚本
# 修复：音量条 100% = +12dB 硬件增益导致高音量削波失真
# 原理：Soft-Mixer（软件音量 float 永不削波）+ UCM 默认 0dB + udev 双保险
# 适用：CUBE i10-WL（bytcr_rt5640 / RT5640 codec）
# 用法：bash fix-audio-volume.sh   （UCM/udev 步骤需要 sudo）
# 幂等：可重复运行，已配置项自动跳过
# ============================================================
set -e

echo "=== i10 音量映射修复（Soft-Mixer + 0dB 校准）==="

# ---- 0. 设备检测 ----
if ! grep -q "bytcr_rt5640\|rt5640" /proc/asound/cards 2>/dev/null; then
  echo "⚠️ 未检测到 RT5640 声卡，本脚本仅适用于 CUBE i10-WL（bytcr_rt5640），退出。"
  exit 1
fi
echo "✓ 检测到 RT5640 声卡"

# ---- 1. Soft-Mixer 配置（wireplumber 0.4 lua 格式）----
WPCONF="$HOME/.config/wireplumber/main.lua.d/50-softmixer.lua"
echo ""
echo "[1/4] Soft-Mixer 配置（软件音量控制）"
mkdir -p "$HOME/.config/wireplumber/main.lua.d"
if [ -f "$WPCONF" ] && grep -q "api.alsa.soft-mixer" "$WPCONF"; then
  echo "  ✓ 已存在，跳过: $WPCONF"
else
  cat > "$WPCONF" << 'EOF'
rule = {
  matches = {
    {
      { "device.name", "matches", "alsa_card.platform-bytcr_rt5640" },
    },
  },
  apply_properties = {
    ["api.alsa.soft-mixer"] = true,
  },
}
table.insert(alsa_monitor.rules, rule)
EOF
  echo "  ✓ 已创建: $WPCONF"
fi

# ---- 2. UCM 默认硬件音量 35 → 31（0dB）----
UCM="/usr/share/alsa/ucm2/codecs/rt5640/EnableSeq.conf"
echo ""
echo "[2/4] UCM 默认硬件音量修正（35→31 = 0dB）"
echo "      （WirePlumber 每次启动会应用 UCM 设置，不修正会跳回 +6dB）"
if [ -f "$UCM" ] && grep -q "'Speaker Playback Volume' 31" "$UCM"; then
  echo "  ✓ 已是 0dB，跳过"
else
  sudo cp "$UCM" "$UCM.bak-$(date +%Y%m%d)"
  sudo sed -i "s/'Speaker Playback Volume' 35/'Speaker Playback Volume' 31/" "$UCM"
  echo "  ✓ 已修正（备份: $UCM.bak-$(date +%Y%m%d)）"
fi

# ---- 3. udev 双保险规则 ----
UDEV="/etc/udev/rules.d/99-rt5640-volume.rules"
echo ""
echo "[3/4] udev 双保险规则（声卡出现时固定硬件 0dB）"
if [ -f "$UDEV" ]; then
  echo "  ✓ 已存在，跳过: $UDEV"
else
  sudo tee "$UDEV" > /dev/null << 'EOF'
# RT5640 硬件音量固定 0dB（Soft-Mixer 用软件控制音量，防止 +12dB 硬件增益削波）
SUBSYSTEM=="sound", KERNEL=="controlC*", ATTRS{id}=="rt5640", ACTION=="add", RUN+="/usr/bin/amixer -c 0 sset Speaker 31"
EOF
  echo "  ✓ 已创建: $UDEV"
fi

# ---- 4. 应用 + 重启 ----
echo ""
echo "[4/4] 应用配置并重启音频服务"
amixer -c 0 sset 'Speaker' 31 >/dev/null 2>&1 || sudo amixer -c 0 sset 'Speaker' 31 >/dev/null
systemctl --user restart wireplumber
sleep 2

echo ""
echo "=== 验证 ==="
FLAGS=$(pactl list sinks | grep -E "标记|Flags" | head -1)
BASE=$(pactl list sinks | grep -E "基础音量|Base Volume" | head -1)
SPK=$(amixer -c 0 sget 'Speaker' | grep "Front Left" | head -1)
echo "Sink 标记:   $FLAGS   （应无 HW_VOLUME_CTRL）"
echo "基础音量:    $BASE   （应为 100% / 0dB）"
echo "硬件 Speaker: $SPK  （应为 31 / 0dB）"
if echo "$FLAGS" | grep -q "HW_VOLUME_CTRL"; then
  echo "❌ 配置未生效（仍有硬件音量控制），请检查 wireplumber 版本/配置"
  exit 1
else
  echo "✅ 修复完成！音量条 0-100% 映射 -∞~0dB，100% = 0dB 不再削波"
fi
