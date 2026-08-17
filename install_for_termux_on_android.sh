#!/bin/bash
echo -e "\033nnbtransh installer for termux on Android\033[0m"
echo ""
echo -e "\033[32mVerifying environment...\033[0m"
if command -v pkg >/dev/null 2>&1; then
    echo "✓ Detected: Termux on Android"
else
    echo "::error::This script is not support this platform"
    exit 1
fi
echo -e "\033[32m[1/4] Install packages in isolated environment\033[0m"
if command -v python >/dev/null 2>&1; then
    echo "Python is already installed"
else
    echo "Python is not installed,so install it"
    pkg update -y &>/dev/null
    pkg install -y python 2>/dev/null 1>/dev/null
fi
if command -v git >/dev/null 2>&1; then
    echo "git is already installed"
else
    echo "git is not installed,so install it"
    pkg update -y &>/dev/null
    pkg install -y git 2>/dev/null 1>/dev/null
fi
echo -e "\033[32m[2/5] Install runtime dependencies\033[0m"
pkg update -y
pkg install -y python-lxml
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
echo -e "\033[32m[3/5] Clone repository\033[0m"
cd ~
rm -rf nbtransh
git clone https://github.com/tc0512/nbtransh.git
rm nbtransh/*.sh
echo -e "\033[32m[4/5] Genetate default configure file\033[0m"
cat > /data/data/com.termux/files/home/nbtransh/settings.json << 'EOF'
{
  "provider": "mymemory",
  "theme": "IPython",
  "auto_target_lang": "en",
  "max_history_length": 550
}
EOF
echo -e "\033[32m[5/5] Create symbolic link to launch faster\033[0m"
ln -s /data/data/com.termux/files/home/nbtransh/nbtransh.py /data/data/com.termux/files/usr/bin/nbtransh
echo -e "\033[32mAll done!\033[0m"
echo "· The nbtransh work directory is /data/data/com.termux/files/home/nbtransh/"
echo "  Please donot remove it."
