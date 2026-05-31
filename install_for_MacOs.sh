#!/bin/bash
# install_mac.sh - macOS 安装脚本
# 使用方法：chmod +x install_mac.sh && ./install_mac.sh

set -e  # 遇到错误立即退出

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${CYAN}========================================${NC}"
echo -e "${CYAN}   nbtransh 翻译器 - macOS 安装脚本${NC}"
echo -e "${CYAN}========================================${NC}"
echo ""

# 检测芯片架构
ARCH=$(uname -m)
if [ "$ARCH" = "arm64" ]; then
    echo -e "${GREEN}✓ 检测到 Apple Silicon (M1/M2/M3) 芯片${NC}"
else
    echo -e "${GREEN}✓ 检测到 Intel 芯片${NC}"
fi
echo ""

# 1. 检查 Command Line Tools
echo -e "[1/6] 检查 Xcode Command Line Tools..."

if ! xcode-select -p &>/dev/null; then
    echo -e "${YELLOW}⚠ Xcode Command Line Tools 未安装，正在安装...${NC}"
    xcode-select --install
    echo -e "${YELLOW}请等待安装完成，然后重新运行此脚本${NC}"
    exit 0
else
    echo -e "${GREEN}✓ Xcode Command Line Tools 已安装${NC}"
fi
echo ""

# 2. 检查/安装 Homebrew
echo -e "[2/6] 检查 Homebrew..."

if ! command -v brew &>/dev/null; then
    echo -e "${YELLOW}⚠ Homebrew 未安装，正在安装...${NC}"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # 根据芯片架构设置 PATH
    if [ "$ARCH" = "arm64" ]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        echo 'eval "$(/usr/local/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/usr/local/bin/brew shellenv)"
    fi
    echo -e "${GREEN}✓ Homebrew 安装完成${NC}"
else
    echo -e "${GREEN}✓ Homebrew 已安装${NC}"
fi
echo ""

# 3. 安装 Python
echo -e "[3/6] 检查 Python..."

if ! command -v python3 &>/dev/null; then
    echo -e "${YELLOW}⚠ Python 未安装，正在安装...${NC}"
    brew install python@3.13
else
    PY_VERSION=$(python3 --version)
    echo -e "${GREEN}✓ 已找到: $PY_VERSION${NC}"
fi
echo ""

# 4. 安装 pip 依赖
echo -e "[4/6] 安装 Python 依赖包..."

# 升级 pip
pip3 install --upgrade pip -q

# 依赖列表
PACKAGES=("translate" "rich" "lxml" "beautifulsoup4" "requests")

for pkg in "${PACKAGES[@]}"; do
    echo -e "  正在安装 ${YELLOW}$pkg${NC}..."
    pip3 install "$pkg" -q
done

echo -e "${GREEN}✓ 所有依赖安装完成${NC}"
echo ""

# 5. 克隆仓库
echo -e "[5/6] 下载 nbtransh..."

REPO_PATH="$HOME/nbtransh"

if [ -d "$REPO_PATH" ]; then
    echo -e "${YELLOW}⚠ 目录已存在，删除旧版本...${NC}"
    rm -rf "$REPO_PATH"
fi

git clone https://github.com/tc0512/nbtransh.git "$REPO_PATH"

if [ $? -ne 0 ]; then
    echo -e "${RED}✗ 克隆失败，请检查网络${NC}"
    exit 1
fi

echo -e "${GREEN}✓ 下载完成${NC}"
echo ""

# 6. 创建启动脚本
echo -e "[6/6] 创建快捷启动..."

# 创建可执行启动脚本
cat > "$REPO_PATH/run.sh" << EOF
#!/bin/bash
cd "$REPO_PATH"
python3 nbtransh.py
EOF

chmod +x "$REPO_PATH/run.sh"

# 创建桌面快捷方式（软链接）
ln -sf "$REPO_PATH/run.sh" "$HOME/Desktop/nbtransh"

echo -e "${GREEN}✓ 快捷方式已创建: 桌面上的 nbtransh${NC}"
echo ""

# 7. 添加到 PATH（可选）
echo -e "[可选] 是否添加到系统 PATH，以便在任何位置运行 nbtransh？(y/n)"
read -r ADD_TO_PATH

if [ "$ADD_TO_PATH" = "y" ] || [ "$ADD_TO_PATH" = "Y" ]; then
    SHELL_CONFIG="$HOME/.zshrc"
    if [ ! -f "$SHELL_CONFIG" ]; then
        SHELL_CONFIG="$HOME/.bashrc"
    fi
    
    echo "alias nbtransh='cd $REPO_PATH && python3 nbtransh.py'" >> "$SHELL_CONFIG"
    echo -e "${GREEN}✓ 已添加别名，请运行 'source $SHELL_CONFIG' 生效${NC}"
fi

echo ""
echo -e "${CYAN}========================================${NC}"
echo -e "${GREEN}   ✓ 安装完成！${NC}"
echo -e "${CYAN}========================================${NC}"
echo -e "工作目录: ${YELLOW}$REPO_PATH${NC}"
echo ""
echo -e "运行方式:"
echo -e "  1. 双击桌面上的 ${YELLOW}nbtransh${NC}"
echo -e "  2. 终端执行: ${YELLOW}$REPO_PATH/run.sh${NC}"
echo -e "  3. 终端执行: ${YELLOW}cd $REPO_PATH && python3 nbtransh.py${NC}"
echo ""
echo -e "${CYAN}========================================${NC}"
