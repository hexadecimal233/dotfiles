#!/bin/bash
set -euo pipefail

# 定义配置目录和文件路径
CONFIG_DIR="$HOME/.config/chezmoi"
CONFIG_FILE="$CONFIG_DIR/chezmoi.toml"

# 创建配置目录（如果不存在）
mkdir -p "$CONFIG_DIR"

# 获取当前工作目录的绝对路径
CURRENT_DIR=$(pwd -P)

# 写入配置（覆盖已有文件）
echo "sourceDir = \"$CURRENT_DIR\"" > "$CONFIG_FILE"

echo "✓ Set chezmoi sourceDir 为: $CURRENT_DIR"