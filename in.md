# MacTools 安装命令大全

**版本**: V1.0.1
**更新时间**: 2026-04-12

---

## 🚀 快速安装（推荐）

### 方式 1: 快速安装脚本（最简单）

**最小依赖，自动化程度高，适合快速体验**

```bash
curl -fsSL https://raw.githubusercontent.com/changzhi777/mactools/main/quick-install.sh -o quick-install.sh && sudo bash quick-install.sh
```

**特点**：
- ✅ 最小依赖（只需 curl + sh）
- ✅ 单文件，易于理解
- ✅ 全自动安装
- ✅ 可下载后离线执行
- ✅ 自动打开浏览器

**适合人群**：新手用户、快速体验、离线安装

---

### 方式 2: 完整安装脚本（功能全面）

**功能完整，配置丰富，适合生产环境**

**Bash 版本**：
```bash
curl -fsSL https://raw.githubusercontent.com/changzhi777/mactools/main/macclaw-installer/install.sh | sudo bash
```

**POSIX sh 版本**：
```bash
curl -fsSL https://raw.githubusercontent.com/changzhi777/mactools/main/macclaw-installer/install-posix.sh | sudo sh
```

**特点**：
- ✅ 功能完整全面
- ✅ 模块化设计
- ✅ 更多配置选项
- ✅ 更好的错误处理
- ✅ 支持断点续传

**适合人群**：高级用户、生产环境、定制化需求

---

## 📥 分步安装（推荐，更安全）

### 快速安装脚本分步执行

```bash
# 步骤 1: 下载脚本
curl -fsSL https://raw.githubusercontent.com/changzhi777/mactools/main/quick-install.sh -o quick-install.sh

# 步骤 2: 查看脚本内容（可选）
cat quick-install.sh

# 步骤 3: 执行安装
sudo bash quick-install.sh

# 步骤 4: 清理脚本（可选）
rm quick-install.sh
```

### 完整安装脚本分步执行

```bash
# 步骤 1: 下载脚本
curl -fsSL https://raw.githubusercontent.com/changzhi777/mactools/main/macclaw-installer/install.sh -o install.sh

# 步骤 2: 查看脚本内容（可选）
cat install.sh

# 步骤 3: 执行安装
sudo bash install.sh

# 步骤 4: 清理脚本（可选）
rm install.sh
```

---

## ⚙️ 配置选项

### 使用国内镜像加速

**快速安装脚本**：
```bash
export CONFIGURE_SOURCES="china"
sudo bash quick-install.sh
```

**完整安装脚本**：
```bash
export CONFIGURE_SOURCES="china"
curl -fsSL https://raw.githubusercontent.com/changzhi777/mactools/main/macclaw-installer/install.sh | sudo bash
```

### 自定义安装目录

```bash
export NVM_DIR="$HOME/.nvm"
export OPENCLAW_INSTALL_DIR="$HOME/.openclaw"
sudo bash quick-install.sh
```

### 查看所有配置选项

详细配置说明请查看：
- **快速安装**: [QUICK_INSTALL_GUIDE.md](https://github.com/changzhi777/mactools/blob/main/QUICK_INSTALL_GUIDE.md)
- **完整配置**: [config.md](https://github.com/changzhi777/mactools/blob/main/config.md)

---

## ⚠️ 重要提示

### URL 注意事项

**✅ 正确的 URL**（无空格）：
```
https://raw.githubusercontent.com/changzhi777/mactools/main/macclaw-installer/install.sh
https://raw.githubusercontent.com/changzhi777/mactools/main/quick-install.sh
```

**❌ 错误的 URL**（有空格）：
```
https://raw.githubusercontent.com/changzhi777/mactools/main/macclaw -installer/install.sh
                                                                          ↑ 这里不能有空格！
```

### 关键点

- `macclaw-installer` 是一个完整的单词
- `quick-install` 也是一个完整的单词
- 中间没有空格
- 使用连字符 `-` 连接

### 复制粘贴技巧

1. **完整复制整行命令**（包括 `curl` 和 `| sudo bash`）
2. **直接粘贴到终端**
3. **按回车执行**
4. **输入密码**（如果需要）

---

## 📋 安装前检查

### 系统要求

- **操作系统**: macOS 12 或更高版本
- **CPU架构**: arm64 (Apple Silicon) 或 x86_64 (Intel)
- **内存**: 至少 16GB
- **磁盘空间**: 至少 20GB 可用空间

### 必需工具

- ✅ Xcode Command Line Tools
- ✅ curl（下载脚本）
- ✅ git（克隆仓库）
- ✅ python3（安装 oMLX）

### 检查 Xcode Tools

```bash
xcode-select -p
```

如果返回路径，说明已安装。如果报错，请先安装：

```bash
xcode-select --install
```

安装完成后，重新运行安装命令。

---

## 🔧 不同安装方式对比

| 特性 | 快速安装 | 完整安装 |
|------|----------|----------|
| **依赖** | 最小（curl + sh） | 完整（bash + 库文件） |
| **大小** | 15KB 单文件 | 模块化多文件 |
| **配置** | 基础配置 | 丰富配置选项 |
| **交互** | 全自动 | 可选择组件 |
| **错误处理** | 基础 | 高级 |
| **断点续传** | 不支持 | 支持 |
| **适合人群** | 新手、快速体验 | 高级用户、生产环境 |
| **离线执行** | 支持 | 支持 |

---

## 📦 安装组件

### 自动安装的组件

所有安装方式都会自动安装以下组件：

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

## 🛠️ 安装后验证

### 检查 Node.js

```bash
node --version
npm --version
```

### 检查 OpenClaw

```bash
openclaw --version
```

### 检查服务状态

```bash
openclaw gateway status
```

### 访问 Web UI

安装完成后，浏览器会自动打开：

```
http://127.0.0.1:18789/
```

如果未自动打开，手动访问：

```bash
open http://127.0.0.1:18789/
```

---

## 🎯 常用命令

### Agent 管理

```bash
# 列出所有 Agents
openclaw agents list

# 查看 Agent 配置
openclaw agents config main

# 与 Agent 对话
openclaw agents run main --prompt "你好"
```

### 测试推理

```bash
# 使用默认模型
openclaw infer model run --model omlx/gemma-4-e4b-it-4bit --prompt "你好"

# 交互式对话
openclaw infer chat --model omlx/gemma-4-e4b-it-4bit
```

### 服务管理

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
xcode-select --install
```

**2. 网络连接问题**

```bash
# 使用国内镜像
export CONFIGURE_SOURCES="china"
sudo bash quick-install.sh
```

**3. 权限不足**

```bash
# 使用 sudo
sudo bash quick-install.sh
```

**4. 磁盘空间不足**

```bash
# 检查可用空间
df -h /

# 至少需要 20GB
```

**5. 端口被占用**

```bash
# 检查端口
lsof -i :18789  # OpenClaw Gateway
lsof -i :8008   # oMLX
```

### 查看日志

```bash
# 安装日志
cat ~/macclaw-install.log

# 实时监控
tail -f ~/macclaw-install.log
```

### 重新安装

```bash
# 清理旧安装
rm -rf ~/.nvm
rm -rf ~/.openclaw
rm -rf ~/.omlx
rm -rf ~/.macclaw-installer

# 重新安装
sudo bash quick-install.sh
```

---

## 📚 相关文档

### 配置文件

- **config.md** - 完整的配置参数说明
- **QUICK_INSTALL_GUIDE.md** - 快速安装详细指南
- **README.md** - 项目总体介绍

### 技术文档

- **PIPEMODE_FIX.md** - 管道模式修复说明
- **INSTALLATION_INTERRUPT_FIX.md** - 安装中断问题修复
- **ENVIRONMENT_CHECK_IMPROVEMENT.md** - 环境检查改进说明
- **POSIX_COMPATIBILITY.md** - POSIX 兼容性说明

---

## 🔄 更新日志

### V1.0.1 (2026-04-12)

**新增**：
- ✅ 快速安装脚本（quick-install.sh）
- ✅ 配置文件系统（config.md）
- ✅ 安装中断问题修复
- ✅ 管道模式阻塞问题修复
- ✅ POSIX 兼容性改进
- ✅ 基础环境检查增强

**优化**：
- ✅ 自动检测网络选择镜像源
- ✅ 改进错误处理和日志记录
- ✅ 优化安装流程和用户体验

---

## 📞 获取帮助

**项目地址**: https://github.com/changzhi777/mactools

**问题反馈**: https://github.com/changzhi777/mactools/issues

**文档中心**: https://github.com/changzhi777/mactools/blob/main/README.md

**作者**: 外星动物（常智）
**邮箱**: 14455975@qq.com
**组织**: IoTchange

---

## 🎉 选择建议

### 我是新手，想要最简单的方式

👉 **使用快速安装脚本**：
```bash
curl -fsSL https://raw.githubusercontent.com/changzhi777/mactools/main/quick-install.sh -o quick-install.sh && sudo bash quick-install.sh
```

### 我是高级用户，需要更多配置

👉 **使用完整安装脚本**：
```bash
curl -fsSL https://raw.githubusercontent.com/changzhi777/mactools/main/macclaw-installer/install.sh | sudo bash
```

### 我想离线安装

👉 **先下载，再执行**：
```bash
# 下载
curl -O https://raw.githubusercontent.com/changzhi777/mactools/main/quick-install.sh

# 离线执行
sudo bash quick-install.sh
```

### 我想先了解再安装

👉 **查看文档**：
1. 阅读 [QUICK_INSTALL_GUIDE.md](https://github.com/changzhi777/mactools/blob/main/QUICK_INSTALL_GUIDE.md)
2. 查看 [config.md](https://github.com/changzhi777/mactools/blob/main/config.md)
3. 选择合适的安装方式

---

**🎉 享受使用 MacTools！**

**如有问题，请查看文档或提交 Issue。**
