# RustDesk 客户端完整配置文件

## 📋 配置文件内容

### 服务器连接信息
```
ID 服务器: 64.118.135.134
中继服务器: 64.118.135.134
密钥: JaHrtjMM+p1IVyMmLacSF5H7VxpV7Zgw9NgGrRPkYVE=
```

---

## 🖥️ 各平台配置文件

### Windows 配置

**文件位置：**
```
C:\Users\你的用户名\AppData\Roaming\RustDesk\config\RustDesk.toml
```

**快速打开方法：**
1. 按 `Win + R`
2. 输入：`%APPDATA%\RustDesk\config`
3. 点击确定
4. 用记事本打开 `RustDesk.toml`

**配置内容：**
```toml
[servers]
[[servers.servers]]
id = "64.118.135.134"
relay = "64.118.135.134"
key = "JaHrtjMM+p1IVyMmLacSF5H7VxpV7Zgw9NgGrRPkYVE="

[options]
always-use-relay = false
```

---

### Mac/Linux 配置

**文件位置：**
```
~/.config/RustDesk/config/RustDesk.toml
```

**完整路径：**
```
/home/你的用户名/.config/RustDesk/config/RustDesk.toml
```

**配置内容：**
```toml
[servers]
[[servers.servers]]
id = "64.118.135.134"
relay = "64.118.135.134"
key = "JaHrtjMM+p1IVyMmLacSF5H7VxpV7Zgw9NgGrRPkYVE="

[options]
always-use-relay = false
```

---

## 🚀 一键配置脚本

### Windows PowerShell 配置脚本

```powershell
# ============================================
# RustDesk 客户端自动配置脚本 (Windows)
# ============================================

# 1. 创建配置目录
Write-Host "📁 创建配置目录..."
New-Item -ItemType Directory -Force -Path "$env:APPDATA\RustDesk\config" | Out-Null

# 2. 备份现有配置
$configFile = "$env:APPDATA\RustDesk\config\RustDesk.toml"
if (Test-Path $configFile) {
    $backupFile = "$configFile.backup.$(Get-Date -Format 'yyyyMMdd_HHmmss')"
    Copy-Item $configFile $backupFile
    Write-Host "📦 已备份原配置: $backupFile"
}

# 3. 创建新配置
Write-Host "📝 创建配置文件..."
@"
[servers]
[[servers.servers]]
id = "64.118.135.134"
relay = "64.118.135.134"
key = "JaHrtjMM+p1IVyMmLacSF5H7VxpV7Zgw9NgGrRPkYVE="

[options]
always-use-relay = false
"@ | Out-File -FilePath $configFile -Encoding utf8

Write-Host "✅ 配置文件已创建"

# 4. 显示配置内容
Write-Host ""
Write-Host "📋 配置内容："
Get-Content $configFile

# 5. 清除缓存
Write-Host ""
Write-Host "🧹 清除客户端缓存..."
$cacheDir = "$env:APPDATA\RustDesk\cache"
if (Test-Path $cacheDir) {
    Remove-Item -Recurse -Force "$cacheDir\*" -ErrorAction SilentlyContinue
    Write-Host "✅ 缓存已清除"
}

# 6. 重启 RustDesk
Write-Host ""
Write-Host "🔄 重启 RustDesk..."
Stop-Process -Name rustdesk -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 2
Start-Process "C:\Program Files\RustDesk\rustdesk.exe"

Write-Host ""
Write-Host "✅ 配置完成！"
Write-Host "📝 请等待 30 秒观察 RustDesk 状态"
Write-Host ""
Write-Host "🔍 验证方法："
Write-Host "  1. 打开 RustDesk"
Write-Host "  2. 查看是否显示 ID 号码"
Write-Host "  3. 检查连接状态是否显示'在线'"
```

**使用方法：**
1. 打开 PowerShell（管理员权限）
2. 复制上面的脚本
3. 粘贴到 PowerShell 并执行

---

### Mac/Linux 配置脚本

```bash
#!/bin/bash
#
# RustDesk 客户端自动配置脚本 (Mac/Linux)
#

set -e

echo "🚀 RustDesk 客户端自动配置"
echo "============================"
echo ""

# 服务器配置
ID_SERVER="64.118.135.134"
RELAY_SERVER="64.118.135.134"
SERVER_KEY="JaHrtjMM+p1IVyMmLacSF5H7VxpV7Zgw9NgGrRPkYVE="

# 检测操作系统
OS="$(uname -s)"
case "$OS" in
    Linux*)     CONFIG_DIR="$HOME/.config/RustDesk/config";;
    Darwin*)    CONFIG_DIR="$HOME/.config/RustDesk/config";;
    *)          echo "❌ 不支持的操作系统"; exit 1;;
esac

echo "🖥️  操作系统: $OS"
echo "📁 配置目录: $CONFIG_DIR"
echo ""

# 1. 创建配置目录
echo "📁 创建配置目录..."
mkdir -p "$CONFIG_DIR"

# 2. 备份现有配置
CONFIG_FILE="$CONFIG_DIR/RustDesk.toml"
if [ -f "$CONFIG_FILE" ]; then
    BACKUP_FILE="$CONFIG_FILE.backup.$(date +%Y%m%d_%H%M%S)"
    cp "$CONFIG_FILE" "$BACKUP_FILE"
    echo "📦 已备份原配置: $BACKUP_FILE"
fi

# 3. 创建新配置
echo "📝 创建配置文件..."
cat > "$CONFIG_FILE" << EOF
[servers]
[[servers.servers]]
id = "$ID_SERVER"
relay = "$RELAY_SERVER"
key = "$SERVER_KEY"

[options]
always-use-relay = false
EOF

echo "✅ 配置文件已创建"

# 4. 设置权限
chmod 644 "$CONFIG_FILE"

# 5. 显示配置
echo ""
echo "📋 配置内容："
cat "$CONFIG_FILE"

# 6. 清除缓存
echo ""
echo "🧹 清除客户端缓存..."
CACHE_DIR="$HOME/.config/RustDesk/cache"
if [ -d "$CACHE_DIR" ]; then
    rm -rf "$CACHE_DIR"/*
    echo "✅ 缓存已清除"
fi

# 7. 重启 RustDesk
echo ""
echo "🔄 重启 RustDesk..."
if pgrep -x rustdesk > /dev/null; then
    pkill rustdesk
    sleep 2
fi

# 根据不同系统启动
if [[ "$OS" == "Darwin" ]]; then
    open /Applications/RustDesk.app 2>/dev/null || rustdesk &
else
    rustdesk &
fi

echo ""
echo "✅ 配置完成！"
echo "📝 请等待 30 秒观察 RustDesk 状态"
echo ""
echo "🔍 验证方法："
echo "  1. 打开 RustDesk"
echo "  2. 查看是否显示 ID 号码"
echo "  3. 检查连接状态是否显示'在线'"
```

**使用方法：**
```bash
# 1. 保存脚本到文件
nano ~/configure_rustdesk.sh

# 2. 粘贴上面的脚本内容

# 3. 保存并退出（Ctrl+X, Y, Enter）

# 4. 执行脚本
bash ~/configure_rustdesk.sh
```

---

## 📝 图形界面配置步骤

### Windows/Mac/Linux 通用步骤

#### 第 1 步：打开 RustDesk

启动 RustDesk 应用程序

#### 第 2 步：进入设置

**方法 1：**
- 点击右上角的 **⚙️ 设置图标**

**方法 2：**
- 点击右上角的 **三条横线菜单**
- 选择 **设置**

#### 第 3 步：配置网络

1. 在左侧菜单中选择 **网络** 或 **Network**
2. 找到 **ID 服务器** 部分

#### 第 4 步：填入服务器信息

```
┌─────────────────────────────────────────┐
│  ID 服务器                                │
│  ┌─────────────────────────────────────┐ │
│  │ 64.118.135.134                      │ │
│  └─────────────────────────────────────┘ │
│                                           │
│  密钥                                     │
│  ┌─────────────────────────────────────┐ │
│  │ JaHrtjMM+p1IVyMmLacSF5H7VxpV7Zgw9NgGrRPkYVE= │ │
│  └─────────────────────────────────────┘ │
│                                           │
│          [取消]        [确定]              │
└─────────────────────────────────────────┘
```

**重要提示：**
- 确保 ID 服务器是：`64.118.135.134`（不要加端口号）
- 密钥必须完整，以 `=` 结尾
- 不要有多余的空格或换行

#### 第 5 步：保存并重启

1. 点击 **确定** 保存设置
2. **完全退出** RustDesk（包括系统托盘）
3. 重新启动 RustDesk

---

## 📱 移动端配置

### Android 配置

1. **打开 RustDesk 应用**
2. **点击右上角 ⋮ 菜单**
3. **选择"设置"**
4. **找到"ID 服务器"**
5. **输入配置：**
   ```
   ID 服务器: 64.118.135.134
   密钥: JaHrtjMM+p1IVyMmLacSF5H7VxpV7Zgw9NgGrRPkYVE=
   ```
6. **保存并重启应用**

### iOS 配置

1. **打开 RustDesk 应用**
2. **点击右上角 ⋮ 菜单**
3. **选择"设置"**
4. **找到"ID 服务器"**
5. **输入配置：**
   ```
   ID 服务器: 64.118.135.134
   密钥: JaHrtjMM+p1IVyMmLacSF5H7VxpV7Zgw9NgGrRPkYVE=
   ```
6. **保存并重启应用**

---

## ✅ 配置验证

### 验证步骤

#### 1. 配置文件验证

**Windows PowerShell：**
```powershell
# 查看配置文件
Get-Content "$env:APPDATA\RustDesk\config\RustDesk.toml"
```

**Mac/Linux 终端：**
```bash
# 查看配置文件
cat ~/.config/RustDesk/config/RustDesk.toml
```

**应该看到：**
```toml
[servers]
[[servers.servers]]
id = "64.118.135.134"
relay = "64.118.135.134"
key = "JaHrtjMM+p1IVyMmLacSF5H7VxpV7Zgw9NgGrRPkYVE="
```

#### 2. 网络连接验证

**在终端/命令提示符中运行：**
```bash
# 测试服务器连通性
ping 64.118.135.134

# 测试端口连接
nc -zv 64.118.135.134 21116
```

**预期结果：**
```
✅ ping: 收到回复
✅ nc: Connection to 64.118.135.134 21116 port [tcp/*] succeeded!
```

#### 3. RustDesk 客户端验证

**打开 RustDesk 后检查：**
- [ ] 是否显示 ID 号码（不再是"正在接入"）
- [ ] 状态显示"在线"（绿色圆点）
- [ ] 可以看到其他设备（如果有）
- [ ] 没有错误提示

---

## 🔧 常见配置问题修复

### 问题 1：配置后仍显示"正在接入"

**解决方法：**
1. 确认配置文件保存成功
2. 完全退出 RustDesk（包括系统托盘）
3. 清除缓存：
   ```bash
   # Mac/Linux
   rm -rf ~/.config/RustDesk/cache/*
   
   # Windows
   Remove-Item -Recurse -Force "$env:APPDATA\RustDesk\cache\*"
   ```
4. 重新启动 RustDesk
5. 等待至少 30 秒

### 问题 2：密钥验证失败

**解决方法：**
1. 确保密钥长度是 44 个字符
2. 确保没有多余空格
3. 重新复制密钥：
   ```
   JaHrtjMM+p1IVyMmLacSF5H7VxpV7Zgw9NgGrRPkYVE=
   ```
4. 检查密钥以 `=` 结尾

### 问题 3：无法保存配置

**解决方法：**
1. 以管理员身份运行 RustDesk
2. 检查配置文件权限：
   ```bash
   # Mac/Linux
   ls -la ~/.config/RustDesk/config/RustDesk.toml
   
   # Windows
   (Get-Item "$env:APPDATA\RustDesk\config\RustDesk.toml").Mode
   ```
3. 手动创建配置文件

---

## 📋 完整配置检查清单

### 配置前检查
- [ ] RustDesk 客户端已安装
- [ ] 服务器运行正常（已确认）
- [ ] 网络连接正常
- [ ] 知道服务器 IP 和密钥

### 配置步骤
- [ ] 打开 RustDesk 设置
- [ ] 进入网络配置
- [ ] 输入服务器地址：64.118.135.134
- [ ] 输入密钥：JaHrtjMM+p1IVyMmLacSF5H7VxpV7Zgw9NgGrRPkYVE=
- [ ] 保存配置
- [ ] 完全退出 RustDesk
- [ ] 重新启动 RustDesk

### 配置后验证
- [ ] 等待 30 秒
- [ ] 查看 ID 是否显示
- [ ] 检查连接状态
- [ ] 测试远程连接（如果有两台设备）

---

## 🎯 快速配置命令

### Windows 一键配置

```powershell
# 打开 PowerShell（管理员），运行以下命令：

# 创建配置
New-Item -ItemType Directory -Force -Path "$env:APPDATA\RustDesk\config" | Out-Null
@"
[servers]
[[servers.servers]]
id = "64.118.135.134"
relay = "64.118.135.134"
key = "JaHrtjMM+p1IVyMmLacSF5H7VxpV7Zgw9NgGrRPkYVE="
"@ | Out-File -FilePath "$env:APPDATA\RustDesk\config\RustDesk.toml" -Encoding utf8

# 清除缓存
Remove-Item -Recurse -Force "$env:APPDATA\RustDesk\cache\*" -ErrorAction SilentlyContinue

# 重启
Stop-Process -Name rustdesk -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 2
Start-Process "C:\Program Files\RustDesk\rustdesk.exe"
```

### Mac/Linux 一键配置

```bash
# 打开终端，运行以下命令：

# 创建配置
mkdir -p ~/.config/RustDesk/config
cat > ~/.config/RustDesk/config/RustDesk.toml << 'EOF'
[servers]
[[servers.servers]]
id = "64.118.135.134"
relay = "64.118.135.134"
key = "JaHrtjMM+p1IVyMmLacSF5H7VxpV7Zgw9NgGrRPkYVE="
EOF

# 清除缓存
rm -rf ~/.config/RustDesk/cache/*

# 重启
pkill rustdesk && sleep 2 && rustdesk &
```

---

## 📞 需要帮助？

如果配置后仍然有问题，请提供以下信息：

1. **操作系统**：Windows/Mac/Linux/Android/iOS
2. **RustDesk 版本**：在设置 → 关于中查看
3. **当前状态**：显示什么信息
4. **错误提示**：是否有错误消息
5. **等待时间**：配置后等待了多久

---

## ✅ 配置完成标志

配置成功后，您应该看到：

✅ **RustDesk 主界面**
- 显示 ID 号码（如：123 456 789）
- 状态显示"在线"或绿色圆点
- 没有"正在接入RustDesk网络..."提示

✅ **设置验证**
- 在设置 → 关于中可以看到连接信息
- ID 服务器显示：64.118.135.134

✅ **功能可用**
- 可以看到其他在线设备（如果有）
- 可以进行远程连接测试

---

**配置完成后，您的 RustDesk 将使用自建服务器，流量完全自主控制！** 🎉
