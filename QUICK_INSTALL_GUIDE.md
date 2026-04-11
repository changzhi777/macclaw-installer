# MacTools 快速安装指南

**版本**: V1.0.1
**更新时间**: 2026-04-12

---

## 🚀 快速开始

### 方法 1: 一键安装（推荐）

```bash
curl -fsSL https://raw.githubusercontent.com/changzhi777/mactools/main/quick-install.sh -o quick-install.sh && sudo bash quick-install.sh
```

### 方法 2: 分步执行

```bash
# 1. 下载安装脚本
curl -fsSL https://raw.githubusercontent.com/changzhi777/mactools/main/quick-install.sh -o quick-install.sh

# 2. 查看脚本内容（可选）
cat quick-install.sh

# 3. 执行安装
sudo bash quick-install.sh
```

### 方法 3: 下载后执行

```bash
# 下载
wget https://raw.githubusercontent.com/changzhi777/mactools/main/quick-install.sh

# 或使用 curl
curl -O https://raw.githubusercontent.com/changzhi777/mactools/main/quick-install.sh

# 执行
sudo bash quick-install.sh
```

---

## 📋 系统要求

### 最低要求

- **操作系统**: macOS 12 或更高版本
- **CPU架构**: arm64 (Apple Silicon) 或 x86_64 (Intel)
- **内存**: 至少 16GB
- **磁盘空间**: 至少 20GB 可用空间

### 必需工具

- ✅ Xcode Command Line Tools
- ✅ curl
- ✅ git
- ✅ python3

### 检查 Xcode Tools

```bash
xcode-select -p
```

如果报错，请先安装：

```bash
xcode-select --install
```

---

## ⚙️ 配置选项

### 环境变量配置

可以通过环境变量自定义安装行为：

```bash
# 使用国内镜像源
export CONFIGURE_SOURCES="china"

# 自定义安装目录
export NVM_DIR="/custom/path/.nvm"
export OPENCLAW_INSTALL_DIR="/custom/path/.openclaw"

# 自动确认所有提示
export AUTO_CONFIRM="true"

# 显示详细日志
export LOG_FILE="/custom/path/install.log"
```

### 配置示例

**使用国内镜像加速安装**：

```bash
export CONFIGURE_SOURCES="china"
sudo bash quick-install.sh
```

**自定义安装目录**：

```bash
export NVM_DIR="$HOME/.nvm"
export OPENCLAW_INSTALL_DIR="$HOME/.openclaw"
sudo bash quick-install.sh
```

---

## 🔧 安装组件

### 自动安装的组件

1. **Node.js** (LTS 版本)
   - JavaScript 运行环境
   - 通过 nvm 管理

2. **OpenClaw CLI**
   - AI 开发工具链
   - 通过 npm 全局安装

3. **oMLX**
   - 本地推理引擎
   - 通过 pip3 安装

4. **gemma-4-e4b-it-4bit 模型**
   - 4bit 量化 AI 模型
   - 约 4GB 大小

5. **默认 Agents**
   - main: 主要助手
   - assistant: 辅助助手

6. **常用 Skills**
   - filesystem: 文件系统操作
   - web: 网络访问能力
   - system: 系统信息获取

---

## 📊 安装流程

### 自动化流程

脚本会自动执行以下步骤：

```
1. ✅ 环境检查
   ├─ macOS 版本
   ├─ CPU 架构
   ├─ 内存和磁盘空间
   └─ 必需工具

2. ✅ 配置下载源
   ├─ 自动检测网络
   ├─ 选择最优镜像
   └─ 配置 npm/pip 源

3. ✅ 安装 Node.js
   ├─ 安装 nvm
   └─ 安装 Node.js LTS

4. ✅ 安装 OpenClaw
   └─ 通过 npm 全局安装

5. ✅ 安装 oMLX
   └─ 通过 pip3 安装

6. ✅ 下载 AI 模型
   └─ gemma-4-e4b-it-4bit

7. ✅ 配置集成
   └─ 初始化 OpenClaw

8. ✅ 创建 Agents
   ├─ main agent
   └─ assistant agent

9. ✅ 安装 Skills
   ├─ filesystem
   ├─ web
   └─ system

10. ✅ 启动服务
    ├─ OpenClaw Gateway
    └─ oMLX 服务

11. ✅ 验证安装
    └─ 检查所有组件
```

---

## 🎯 安装后使用

### 访问 Web UI

安装完成后，浏览器会自动打开：

```
http://127.0.0.1:18789/
```

### 常用命令

**Agent 管理**：
```bash
# 列出所有 Agents
openclaw agents list

# 查看 Agent 配置
openclaw agents config main

# 与 Agent 对话
openclaw agents run main --prompt "你好"
```

**测试推理**：
```bash
# 使用默认模型
openclaw infer model run --model omlx/gemma-4-e4b-it-4bit --prompt "你好"

# 交互式对话
openclaw infer chat --model omlx/gemma-4-e4b-it-4bit
```

**服务管理**：
```bash
# 查看服务状态
openclaw gateway status

# 重启服务
openclaw gateway restart

# 停止服务
openclaw gateway stop

# 查看日志
tail -f ~/macclaw-install.log
```

---

## 🔍 故障排除

### 常见问题

**1. Xcode Command Line Tools 未安装**

```bash
# 安装 Xcode Tools
xcode-select --install

# 等待安装完成后重新运行安装脚本
```

**2. 网络连接问题**

```bash
# 使用国内镜像源
export CONFIGURE_SOURCES="china"
sudo bash quick-install.sh
```

**3. 权限不足**

```bash
# 使用 sudo 运行
sudo bash quick-install.sh
```

**4. 磁盘空间不足**

```bash
# 检查可用空间
df -h /

# 清理磁盘空间
# 至少需要 20GB 可用空间
```

**5. 端口被占用**

```bash
# 检查端口占用
lsof -i :18789  # OpenClaw Gateway
lsof -i :8008   # oMLX

# 停止占用端口的进程
kill -9 <PID>
```

### 查看日志

```bash
# 查看完整安装日志
cat ~/macclaw-install.log

# 查看最后 50 行
tail -50 ~/macclaw-install.log

# 实时监控日志
tail -f ~/macclaw-install.log
```

### 重新安装

```bash
# 清理旧安装
rm -rf ~/.nvm
rm -rf ~/.openclaw
rm -rf ~/.omlx
rm -rf ~/.macclaw-installer

# 重新运行安装
sudo bash quick-install.sh
```

---

## 📊 与完整安装脚本的区别

### 快速安装脚本 (quick-install.sh)

**特点**：
- ✅ 最小依赖（只需 curl + sh）
- ✅ 单文件，易于理解
- ✅ 自动化程度高
- ✅ 适合快速体验
- ✅ 可下载后离线执行

**适用场景**：
- 快速体验和测试
- 离线安装环境
- 简单部署需求
- 学习和理解安装流程

### 完整安装脚本 (install.sh)

**特点**：
- ✅ 功能完整全面
- ✅ 模块化设计
- ✅ 更多配置选项
- ✅ 更好的错误处理
- ✅ 支持断点续传

**适用场景**：
- 生产环境部署
- 需要详细配置
- 复杂安装需求
- 长期使用维护

---

## 🎨 高级配置

### 自定义安装组件

编辑 `quick-install.sh`，注释掉不需要的组件：

```bash
# 跳过模型下载（如果已有模型）
# download_model

# 跳过 Skills 安装
# install_skills
```

### 修改配置参数

在脚本开头修改配置：

```bash
# 修改服务端口
OPENCLAW_GATEWAY_PORT=18080
OMLX_PORT=8009

# 修改安装路径
NVM_DIR="$HOME/.nvm"
OPENCLAW_INSTALL_DIR="$HOME/.openclaw"
```

### 使用代理

```bash
export http_proxy="http://proxy.example.com:8080"
export https_proxy="http://proxy.example.com:8080"
sudo bash quick-install.sh
```

---

## 📞 获取帮助

**项目地址**: https://github.com/changzhi777/mactools
**问题反馈**: https://github.com/changzhi777/mactools/issues
**配置文件**: config.md
**完整文档**: README.md

**作者**: 外星动物（常智）
**邮箱**: 14455975@qq.com
**组织**: IoTchange

---

## 🔄 更新日志

### V1.0.1 (2026-04-12)

- ✅ 初始版本发布
- ✅ 支持快速安装 OpenClaw + oMLX
- ✅ 自动配置国内镜像源
- ✅ 最小依赖设计
- ✅ 完整的错误处理

---

**🎉 享受使用 MacTools！**

**如有问题，请查看 config.md 或提交 Issue。**
