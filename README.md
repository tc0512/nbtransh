# nbtransh
python交互式翻译器

## 下载
### Windows PowerShell
```powershell
curl -O https://github.com/tc0512/nbtransh/releases/download/v0.1.0/install_for_windows.ps1
# 方法1：右键 PowerShell 以管理员身份运行，然后执行
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
.\install_for_windows.ps1
```
### Linux
```bash
curl -fsSL https://github.com/tc0512/nbtransh/releases/download/v0.1.0/install_for_linux.sh | bash
```
### MacOs
```zsh
curl -O https://github.com/tc0512/nbtransh/releases/download/v0.1.0/install_for_MacOs.sh
./install_for_MacOs.sh
```
### Termux on Android
```bash
curl -fsSL https://github.com/tc0512/nbtransh/releases/download/v0.1.0/install_for_termux_on_android.sh
```

## 使用方法
### 基本信息
`license`显示开源许可证
`?`输出帮助信息
### 命令格式
文本 --当前语言\>目标语言
e.g.
In[1]: Hello world! --en\>zh
你好，世界。
### 语言标签
| 语言 | 标签 |
|-----|-----|
| `zh` | 简体中文 |
| `en` | 英语 |
| `zh-TW` | 繁体中文 |
| `yve` | 粤语 |
| `ko` | 韩语 |
| `fr` | 法语 |
| `es` | 西班牙语 |
| `it` | 意大利语 |
| `nl` | 荷兰语 |
| `tr` | 土耳其语 |
| `hi` | 印地语 |
| `th` | 泰语 |
| `el` | 希腊语 |
| `sv` | 瑞典语 |
| `fi` | 芬兰语 |
| `cs` | 捷克语 |
| `ro` | 罗马语 |
| `ja` | 日语 |

## 注意事项
翻译来自境外第三方服务器, 请注意甄别
