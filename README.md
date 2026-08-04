# nbtransh
python交互式翻译器

## 下载
### Windows PowerShell
```powershell
curl -O https://github.com/tc0512/nbtransh/releases/download/v1.1.0/install_for_windows.ps1
# 右键 PowerShell 以管理员身份运行，然后执行
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
.\install_for_windows.ps1
```
### Linux
```bash
curl -fsSL https://github.com/tc0512/nbtransh/releases/download/v1.1.0/install_for_linux.sh | bash
```
### MacOs
```zsh
curl -O https://github.com/tc0512/nbtransh/releases/download/v1.1.0/install_for_MacOs.sh
./install_for_MacOs.sh
```
### Termux on Android
```bash
curl -fsSL https://github.com/tc0512/nbtransh/releases/download/v1.1.0/install_for_termux_on_android.sh | bash
```
### iOS
1. App Store下载UTM
2. 访问链接下载Ubuntu纯命令行iso
```text
https://ubuntu.com/download/server/thank-you?version=26.04&architecture=arm64&lts=true
```
3. 打开UTM, 点加号, 点新建, 选择模拟, 操作系统Linux, 选择Ubuntu, 分配4GB的RAM, 选择你下载的iso文件
4. 启动虚拟机, 一路点下一步
5. 安装完成后重启进入系统
6. 运行Linux的安装脚本

## 使用方法
### 基本信息
`license`显示开源许可证
`?`输出帮助信息
### 命令格式
文本 --当前语言\>目标语言
e.g.
In[1]: Hello world! --en\>zh
你好，世界。
### 字典
```%dictionary generate``` 生成字典文件 (json) 
```%dictionary add <单词> <语言> <翻译>``` 为词典添加单词
```%dictionary list``` 列出所有字典中记录的单词
```dictionary show <单词>``` 列出某个单词对应的所有翻译
```dictionary remove <单词>``` 删除某个单词
```dictionary clear``` 清空字典
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
| `ru` | 俄语 |
| `de` | 德语 |
| `pt` | 葡萄牙语 |
### 历史记录
`%history` 或 `%hist`
### 设置
```%set list``` 查看已有设置
```%set provider <API服务器>``` 更改API
```%set auto_target_lang <目标语言>``` 更改默认目标语言
```%set theme simple/IPython``` 主题设置: 朴素风格/IPython
```%set max_history_length <最大历史长度>``` 最大历史长度

## 注意事项
默认源翻译来自境外第三方服务器, 请注意甄别
