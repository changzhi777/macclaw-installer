# RustDesk 安装成功验证完整指南

## 🎯 快速验证清单

### ✅ 服务器端验证（已完成）
- [x] Docker 环境正常
- [x] 容器运行正常（2/2）
- [x] 端口监听正常（6/6）
- [x] 密钥对已生成
- [x] 防火墙规则已配置
- [x] 服务日志无错误
- [x] 网络连通正常

**服务器信息：**
```
IP 地址: 64.118.135.134
ID 服务器端口: 21116
中继服务器端口: 21117
公钥: JaHrtjMM+p1IVyMmLacSF5H7VxpV7Zgw9NgGrRPkYVE=
```

---

## 🖥️ 客户端验证步骤

### 方法 1：使用自动化验证脚本

**运行快速配置：**
```bash
bash /tmp/rustdesk_quick_config.sh
```

### 方法 2：手动验证

#### 第 1 步：配置客户端

**图形界面配置：**
1. 打开 RustDesk
2. 点击设置 ⚙️
3. 选择"网络"
4. 配置 ID 服务器：
   ```
   ID 服务器: 64.118.135.134
   密钥: JaHrtjMM+p1IVyMmLacSF5H7VxpV7Zgw9NgGrRPkYVE=
   ```
5. 保存并重启 RustDesk

**配置文件方式：**
```bash
# 创建配置目录
mkdir -p ~/.config/RustDesk/config

# 创建配置文件
cat > ~/.config/RustDesk/config/RustDesk.toml << 'EOF'
[servers]
[[servers.servers]]
id = "64.118.135.134"
relay = "64.118.135.134"
key = "JaHrtjMM+p1IVyMmLacSF5H7VxpV7Zgw9NgGrRPkYVE="
EOF

# 重启 RustDesk
pkill rustdesk && rustdesk &
```

#### 第 2 步：验证客户端连接

**视觉验证：**
- [ ] RustDesk 启动后显示新的 ID
- [ ] 状态显示"在线"（绿色圆点）
- [ ] 没有连接错误提示

**技术验证：**
```bash
# 查看日志
tail -f ~/.config/RustDesk/logs/rustdesk.log

# 测试服务器连通性
ping 64.118.135.134

# 测试端口连接
telnet 64.118.135.134 21116
# 或
nc -zv 64.118.135.134 21116
```

#### 第 3 步：功能测试

**单设备测试：**
1. 配置完成后，记录显示的 ID 号
2. 检查 ID 是否与之前不同
3. 查看连接状态

**双设备测试（推荐）：**
1. 在两台设备上配置相同的服务器
2. 在设备 A 上查看 ID
3. 在设备 B 上输入设备 A 的 ID
4. 点击连接
5. 设置密码并测试远程控制

---

## 🔍 详细验证方法

### 1. 服务器连通性测试

**从本地电脑测试：**
```bash
# 测试服务器可达性
ping 64.118.135.134

# 测试 ID 服务器端口
telnet 64.118.135.134 21116

# 测试中继服务器端口
telnet 64.118.135.134 21117

# 使用 nc 测试（推荐）
nc -zv 64.118.135.134 21116
nc -zv 64.118.135.134 21117
```

**预期结果：**
```
✅ ping: 收到回复
✅ telnet/nc: 连接成功 (Connection to ... succeeded [0])
```

### 2. 客户端配置验证

**检查配置文件：**
```bash
# Linux/Mac
cat ~/.config/RustDesk/config/RustDesk.toml

# Windows
type %APPDATA%\RustDesk\config\RustDesk.toml
```

**预期内容：**
```toml
[servers]
[[servers.servers]]
id = "64.118.135.134"
relay = "64.118.135.134"
key = "JaHrtjMM+p1IVyMmLacSF5H7VxpV7Zgw9NgGrRPkYVE="
```

### 3. RustDesk 日志验证

**查看日志：**
```bash
# Linux/Mac
tail -f ~/.config/RustDesk/logs/rustdesk.log

# Windows
Get-Content "$env:APPDATA\RustDesk\logs\rustdesk.log" -Tail 20 -Wait
```

**查找关键信息：**
```
✅ "Connected to ID server"
✅ "Registered successfully"
✅ "Connection established"

❌ "Connection refused"
❌ "Key verification failed"
❌ "Timeout"
```

### 4. 网络抓包验证（高级）

**使用 tcpdump：**
```bash
# 在服务器上抓包
ssh root@64.118.135.134
tcpdump -i any port 21116 -nn

# 应该看到来自客户端的连接尝试
```

**使用 Wireshark：**
1. 启动 Wireshark
2. 选择网络接口
3. 设置过滤器：`tcp.port == 21116 || udp.port == 21116`
4. 开始捕获
5. 启动 RustDesk 客户端

---

## 📊 验证结果判断

### ✅ 成功标志

**服务器端：**
- ✅ 容器状态显示 "Up X minutes"
- ✅ 端口全部监听
- ✅ 日志显示 "Start" 和 "Listening"
- ✅ 没有错误日志

**客户端：**
- ✅ 显示新的 ID 号
- ✅ 状态显示"在线"
- ✅ 日志显示连接成功
- ✅ 可以看到其他在线设备（如果有）

### ❌ 失败标志

**常见问题：**

| 症状 | 可能原因 | 解决方法 |
|------|----------|----------|
| ID 不显示 | 服务器连接失败 | 检查网络和防火墙 |
| 密钥验证失败 | 密钥配置错误 | 重新复制完整密钥 |
| 无法连接其他设备 | 端口未开放 | 检查防火墙规则 |
| 频繁断线 | 网络不稳定 | 检查网络质量 |

---

## 🛠️ 故障排查流程

### 第 1 层：基础检查

```bash
# 1. 确认服务器运行
ssh root@64.118.135.134 "docker ps | grep rustdesk"

# 2. 确认端口监听
ssh root@64.118.135.134 "ss -tlnp | grep 21116"

# 3. 测试网络连通性
ping 64.118.135.134
```

### 第 2 层：配置检查

```bash
# 1. 验证配置文件
cat ~/.config/RustDesk/config/RustDesk.toml

# 2. 检查密钥完整性
echo "JaHrtjMM+p1IVyMmLacSF5H7VxpV7Zgw9NgGrRPkYVE=" | wc -c
# 应该显示 44

# 3. 查看详细日志
RUSTDESK_RUST_LOG=debug rustdesk
```

### 第 3 层：高级诊断

```bash
# 1. 网络抓包
tcpdump -i any port 21116 -w rustdesk.pcap

# 2. DNS 解析测试
nslookup 64.118.135.134

# 3. 路由跟踪
traceroute 64.118.135.134
```

---

## 📱 移动端验证

### Android 验证

1. **配置应用**
   - 打开 RustDesk 应用
   - 进入设置
   - 配置 ID 服务器

2. **验证连接**
   - 查看是否显示 ID
   - 检查连接状态
   - 测试远程连接

### iOS 验证

1. **配置应用**
   - 打开 RustDesk 应用
   - 进入设置
   - 配置服务器信息

2. **验证连接**
   - 检查 ID 显示
   - 测试连接功能

---

## 🎯 完整验证流程

### 日常快速检查（1 分钟）

```bash
# 1. 检查服务器状态
ssh root@64.118.135.134 "docker ps --filter 'name=rustdesk' --format '{{.Names}}: {{.Status}}'"

# 2. 检查客户端连接
# 打开 RustDesk，查看 ID 和状态

# 3. 快速连接测试
# 尝试连接已知设备
```

### 完整验证流程（5 分钟）

1. **服务器端验证**
   ```bash
   ssh root@64.118.135.134
   cd ~/rustdesk-server-installer
   docker compose ps
   docker logs --tail 20 rustdesk-hbbs
   ```

2. **网络连通性验证**
   ```bash
   ping 64.118.135.134
   nc -zv 64.118.135.134 21116
   nc -zv 64.118.135.134 21117
   ```

3. **客户端配置验证**
   ```bash
   cat ~/.config/RustDesk/config/RustDesk.toml
   ```

4. **功能验证**
   - 打开 RustDesk
   - 查看 ID 显示
   - 测试远程连接

---

## 📞 获取帮助

**验证失败时：**

1. **查看详细日志**
   ```bash
   # 服务器日志
   ssh root@64.118.135.134 "docker logs rustdesk-hbbs --tail 50"
   
   # 客户端日志
   tail -f ~/.config/RustDesk/logs/rustdesk.log
   ```

2. **重新配置**
   ```bash
   # 清除客户端配置
   rm -rf ~/.config/RustDesk/config/RustDesk.toml
   
   # 重新配置
   bash /tmp/rustdesk_quick_config.sh
   ```

3. **联系支持**
   - GitHub Issues
   - Discord 社区
   - 官方文档

---

## ✅ 验证完成检查表

**服务器端：**
- [x] 容器运行正常
- [x] 端口全部监听
- [x] 密钥已生成
- [x] 防火墙已配置
- [x] 日志无错误

**客户端：**
- [ ] 配置文件正确
- [ ] ID 显示正常
- [ ] 连接状态在线
- [ ] 可以连接其他设备

**功能测试：**
- [ ] 单设备启动正常
- [ ] 双设备连接成功
- [ ] 远程控制功能正常
- [ ] 文件传输功能正常（如需要）

---

## 🎉 验证成功！

如果以上所有检查都通过，恭喜您！

**RustDesk Server OSS 部署成功！**

**您的自建远程桌面服务现在已经可以使用了！**

---

**下一步：**
1. 在所有需要远程控制的设备上配置客户端
2. 测试远程桌面连接功能
3. 根据需要调整性能参数
4. 定期检查服务器状态和日志
