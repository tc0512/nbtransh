# install.ps1 - Windows PowerShell 安装脚本
# 使用方法：在 PowerShell 中执行 `.\install.ps1`

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   nbtransh 翻译器 - Windows 安装脚本" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$ErrorActionPreference = "Stop"

# 1. 检查 Python
Write-Host "[1/6] 检查 Python 环境..." -ForegroundColor Green
try {
    $pyCmd = Get-Command python -ErrorAction Stop
    $pyVersion = & $pyCmd --version 2>&1
    Write-Host "      ✓ 已找到: $pyVersion" -ForegroundColor Green
} catch {
    Write-Host "      ✗ 未找到 Python!" -ForegroundColor Red
    Write-Host "      请从 https://www.python.org/downloads/ 安装 Python"
    Write-Host "      安装时请勾选 'Add Python to PATH'"
    Read-Host "按 Enter 键退出..."
    exit 1
}

# 2. 检查 pip
Write-Host "[2/6] 检查 pip..." -ForegroundColor Green
try {
    $pipCmd = Get-Command pip -ErrorAction Stop
    Write-Host "      ✓ 已找到 pip" -ForegroundColor Green
} catch {
    Write-Host "      ✗ pip 未找到，正在修复..." -ForegroundColor Yellow
    & $pyCmd -m ensurepip
}

# 3. 检查 Git
Write-Host "[3/6] 检查 Git..." -ForegroundColor Green
try {
    $gitCmd = Get-Command git -ErrorAction Stop
    $gitVersion = & $gitCmd --version 2>&1
    Write-Host "      ✓ 已找到: $gitVersion" -ForegroundColor Green
} catch {
    Write-Host "      ✗ 未找到 Git!" -ForegroundColor Red
    Write-Host "      请从 https://git-scm.com/download/win 安装 Git"
    Read-Host "按 Enter 键退出..."
    exit 1
}

# 4. 安装 Python 依赖
Write-Host "[4/6] 安装 Python 依赖..." -ForegroundColor Green
$packages = @("translate", "rich", "lxml", "pyreadline", "requests")
$mirrors = @(
    "https://pypi.tuna.tsinghua.edu.cn/simple/",
    "https://mirrors.aliyun.com/pypi/simple/",
    "https://pypi.org/simple/"
)

foreach ($pkg in $packages) {
    Write-Host "      正在安装 $pkg ..." -ForegroundColor Yellow
    $installed = $false
    foreach ($mirror in $mirrors) {
        try {
            & $pipCmd install $pkg -i $mirror --quiet
            if ($LASTEXITCODE -eq 0) {
                Write-Host "      ✓ $pkg 安装成功" -ForegroundColor Green
                $installed = $true
                break
            }
        } catch {
            # 继续尝试下一个镜像
        }
    }
    if (-not $installed) {
        Write-Host "      ✗ $pkg 安装失败，请检查网络连接" -ForegroundColor Red
        Read-Host "按 Enter 键退出..."
        exit 1
    }
}

# 5. 克隆仓库
Write-Host "[5/6] 下载 nbtransh..." -ForegroundColor Green
$repoPath = "$env:USERPROFILE\nbtransh"
if (Test-Path $repoPath) {
    Write-Host "      目录已存在，删除旧版本..." -ForegroundColor Yellow
    Remove-Item -Recurse -Force $repoPath
}
& $gitCmd clone https://github.com/tc0512/nbtransh.git $repoPath
if ($LASTEXITCODE -ne 0) {
    Write-Host "      ✗ 克隆失败，请检查网络" -ForegroundColor Red
    Read-Host "按 Enter 键退出..."
    exit 1
}
Write-Host "      ✓ 下载完成" -ForegroundColor Green

# 6. 写入默认配置
Write-Host "[6/6] 写入默认配置" -ForegroundColor Green
@"
{
  "provider": "mymemory",
  "theme": "IPython",
  "auto_source_lang": "zh"
  "auto_target_lang": "en",
  "max_history_length": 550
}
"@ > $repoPath/settings.json

# 7. 创建启动脚本（桌面快捷方式）
Write-Host "      创建桌面快捷方式..." -ForegroundColor Yellow
$batchPath = "$env:USERPROFILE\Desktop\nbtransh.bat"
$batchContent = "@echo off`ncd /d `"$repoPath`"`npython nbtransh.py`npause"
Set-Content -Path $batchPath -Value $batchContent -Encoding ASCII
Write-Host "      ✓ 桌面快捷方式已创建: nbtransh.bat" -ForegroundColor Green

# 8. 创建启动脚本（终端快捷方式）
Write-Host "      创建终端启动脚本..." -ForegroundColor Yellow
$ps1Path = "$env:USERPROFILE\Desktop\nbtransh.ps1"
$ps1Content = "cd `"$repoPath`"`npython nbtransh.py`nRead-Host '按 Enter 键退出...'"
Set-Content -Path $ps1Path -Value $ps1Content -Encoding ASCII
Write-Host "      ✓ 终端启动脚本已创建: nbtransh.ps1" -ForegroundColor Green

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   ✓ 安装完成！" -ForegroundColor Green
Write-Host "   工作目录: $repoPath" -ForegroundColor Yellow
Write-Host "   运行方式: " -ForegroundColor Yellow
Write-Host "     1. 双击桌面上的 nbtransh.bat (CMD)" -ForegroundColor Yellow
Write-Host "     2. 双击桌面上的 nbtransh.ps1 (PowerShell)" -ForegroundColor Yellow
Write-Host "     3. 在终端执行: cd $repoPath && python nbtransh.py" -ForegroundColor Yellow
Write-Host ""
Write-Host "   提示: 如果双击 .ps1 文件无法运行，请先执行:" -ForegroundColor Yellow
Write-Host "      Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan
Read-Host "按 Enter 键退出..."
