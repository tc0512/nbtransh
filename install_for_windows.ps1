# install.ps1 - Windows PowerShell 安装脚本
# 使用方法：在 PowerShell 中执行 `.\install.ps1`

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   nbtransh 翻译器 - Windows 安装脚本" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 设置错误时停止
$ErrorActionPreference = "Stop"

# 1. 检查 Python
Write-Host "[1/4] 检查 Python 环境..." -ForegroundColor Green
try {
    $pyVersion = python --version 2>&1
    Write-Host "      ✓ 已找到: $pyVersion" -ForegroundColor Green
} catch {
    Write-Host "      ✗ 未找到 Python!" -ForegroundColor Red
    Write-Host "      请从 https://www.python.org/downloads/ 安装 Python"
    Write-Host "      安装时请勾选 'Add Python to PATH'"
    pause
    exit 1
}

# 2. 检查 pip
Write-Host "[2/4] 检查 pip..." -ForegroundColor Green
try {
    $pipVersion = pip --version 2>&1
    Write-Host "      ✓ 已找到 pip" -ForegroundColor Green
} catch {
    Write-Host "      ✗ pip 未找到，正在修复..." -ForegroundColor Yellow
    python -m ensurepip
}

# 3. 安装 Python 依赖
Write-Host "[3/4] 安装 Python 依赖..." -ForegroundColor Green
$packages = @("translate", "rich", "lxml", "beautifulsoup4", "requests")
foreach ($pkg in $packages) {
    Write-Host "      正在安装 $pkg ..." -ForegroundColor Yellow
    pip install $pkg -i https://pypi.tuna.tsinghua.edu.cn/simple/
}
Write-Host "      ✓ 所有依赖安装完成" -ForegroundColor Green

# 4. 克隆仓库
Write-Host "[4/4] 下载 nbtransh..." -ForegroundColor Green
$repoPath = "$env:USERPROFILE\nbtransh"
if (Test-Path $repoPath) {
    Write-Host "      目录已存在，删除旧版本..." -ForegroundColor Yellow
    Remove-Item -Recurse -Force $repoPath
}
git clone https://github.com/tc0512/nbtransh.git $repoPath
if ($LASTEXITCODE -ne 0) {
    Write-Host "      ✗ 克隆失败，请检查网络" -ForegroundColor Red
    pause
    exit 1
}
Write-Host "      ✓ 下载完成" -ForegroundColor Green

# 5. 创建启动脚本
Write-Host "[5/5] 创建快捷启动..." -ForegroundColor Green
$batchPath = "$env:USERPROFILE\Desktop\nbtransh.bat"
$batchContent = "@echo off`ncd /d $repoPath`npython nbtransh.py`npause"
Set-Content -Path $batchPath -Value $batchContent
Write-Host "      ✓ 桌面快捷方式已创建: nbtransh.bat" -ForegroundColor Green

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   ✓ 安装完成！" -ForegroundColor Green
Write-Host "   工作目录: $repoPath" -ForegroundColor Yellow
Write-Host "   运行方式: 双击桌面上的 nbtransh.bat" -ForegroundColor Yellow
Write-Host "           或在终端执行: cd $repoPath && python nbtransh.py" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan
pause
