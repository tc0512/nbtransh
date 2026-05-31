#!/bin/bash
echo -e "\033nnbtransh installer for Linux\033[0m"
echo ""
echo -e "\033[33mVerifying environment...\033[0m"
if command -v apt >/dev/null 2>&1; then
    echo "✓ Detected: Linux"
else
    echo "::error::This script is not support this platform"
fi
echo -e "\033[33m[1/4] Install packages in isolated environment\033[0m"
if command -v python >/dev/null 2>&1; then
    echo "Python is already installed"
else
    echo "Python is not installed,so install it"
    apt update -y &>/dev/null
    apt install -y python3 python3-pip python3-venv python-is-python3 2>/dev/null 1>/dev/null
fi
if command -v git >/dev/null 2>&1; then
    echo "git is already installed"
else
    echo "git is not installed,so install it"
    apt update -y &>/dev/null
    apt install -y git 2>/dev/null 1>/dev/null
fi
echo -e "\033[33m[2/4] Install runtime dependencies\033[0m"
if pip show translate &>/dev/null; then
    echo "translate is already installed"
else
    echo "translate is not installed,so install it"
    pip install -i https://pypi.tuna.tsinghua.edu.cn/simple/ translate
fi
if pip show rich &>/dev/null; then
    echo "rich is already installed"
else
    echo "rich is not installed,so install it"
    pip install -i https://pypi.tuna.tsinghua.edu.cn/simple/ rich
fi
echo -e "\033[33m[3/4] Clone repository\033[0m"
cd ~
rm -rf nbtransh
git clone https://github.com/tc0512/nbtransh.git
rm nbtransh/*.sh
echo -e "\033[33m[4/4] Set alias to launch faster\033[0m"
echo "alias nbtransh='python $HOME/nbtransh/nbtransh.py'" >> .bashrc
echo -e "\033[33mAll done!\033[0m"
echo "· The nbtransh work directory is $HOME/nbtransh"
echo "  Please donot remove it."
echo "· To source the alias,run 'source ~/.bashrc'"
