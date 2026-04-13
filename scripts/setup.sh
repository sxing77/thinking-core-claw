#!/bin/bash
# thinking-core 一键安装脚本
# 用法: bash setup.sh

set -e

echo "🍔 安装 thinking-core 思考推理核心能力..."

WORKSPACE="${WORKSPACE:-$HOME/.openclaw/workspace}"
SKILL_DIR="$WORKSPACE/skills/quality-gate"

# 获取脚本所在目录（支持从任意目录运行）
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CORE_DIR="$SCRIPT_DIR"

echo "📁 workspace: $WORKSPACE"
echo "📁 安装目录: $SKILL_DIR"

# 1. 安装 checklists
echo "📦 安装 checklists..."
mkdir -p "$SKILL_DIR/checklists"
cp -r "$CORE_DIR/checklists/"* "$SKILL_DIR/checklists/"

# 2. 安装 SKILL.md（如果不存在才复制）
if [ ! -f "$SKILL_DIR/SKILL.md" ]; then
    cp "$CORE_DIR/SKILL.md" "$SKILL_DIR/"
else
    echo "⚠️ $SKILL_DIR/SKILL.md 已存在，跳过"
fi

# 3. 安装 AGENTS.md（如果不存在）
if [ ! -f "$WORKSPACE/AGENTS.md" ]; then
    cp "$CORE_DIR/AGENTS.md" "$WORKSPACE/AGENTS.md"
    echo "✅ AGENTS.md 已安装"
else
    echo "⚠️ AGENTS.md 已存在，跳过（建议手动合并 thinking-core/AGENTS.md 到现有文件）"
fi

# 4. 安装 SOUL.md（如果不存在）
if [ ! -f "$WORKSPACE/SOUL.md" ]; then
    cp "$CORE_DIR/SOUL.md" "$WORKSPACE/SOUL.md"
    echo "✅ SOUL.md 已安装"
else
    echo "⚠️ SOUL.md 已存在，跳过（建议手动合并 thinking-core/SOUL.md 到现有文件）"
fi

# 5. 创建日志目录
mkdir -p "$SKILL_DIR/logs"
echo "✅ 日志目录已创建: $SKILL_DIR/logs"

echo ""
echo "✅ 安装完成！"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "重启 OpenClaw 后生效："
echo "  openclaw gateway restart"
echo ""
echo "安装清单："
echo "  ✅ checklists/    — 五张质检清单"
echo "  ✅ SKILL.md      — skill 定义"
echo "  ✅ AGENTS.md     $([ ! -f "$WORKSPACE/AGENTS.md" ] && echo "(新建)" || echo "(已存在，跳过)")"
echo "  ✅ SOUL.md       $([ ! -f "$WORKSPACE/SOUL.md" ] && echo "(新建)" || echo "(已存在，跳过)")"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
