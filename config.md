# MacTools 安装配置文件

**版本**: V1.0.1
**更新时间**: 2026-04-12

---

## 📋 安装组件配置

### 必装组件

| 组件 | 版本 | 说明 | 是否必须 |
|------|------|------|----------|
| Node.js | LTS (v20.x/v22.x) | JavaScript 运行环境 | ✅ 是 |
| OpenClaw CLI | Latest | AI 开发工具链 | ✅ 是 |
| oMLX | Latest | 本地推理引擎 | ✅ 是 |
| gemma-4-e4b-it-4bit | 4bit量化 | AI 模型（约4GB） | ✅ 是 |

### 可选组件

| 组件 | 说明 | 是否默认安装 |
|------|------|--------------|
| 默认 Agents | main, assistant | ✅ 是 |
| 常用 Skills | 开发工具集 | ✅ 是 |

---

## 🌐 下载源配置

### 官方源（默认）

```bash
# Node.js
NODEJS_DOWNLOAD_URL="https://nodejs.org/dist"

# npm
NPM_REGISTRY="https://registry.npmjs.org"

# OpenClaw
OPENCLAW_REPO="https://github.com/IoTchange/openclaw"

# oMLX
OMLX_REPO="https://github.com/iotfusion-ai/omlx"

# AI 模型
MODEL_SOURCE="huggingface"
MODEL_REPO="google/gemma-2-2b-it"
```

### 国内镜像源（可选）

```bash
# Node.js
NODEJS_MIRROR="https://npmmirror.com/mirrors/node"

# npm
NPM_REGISTRY="https://registry.npmmirror.com"

# pip
PIP_INDEX_URL="https://pypi.tuna.tsinghua.edu.cn/simple"

# ModelScope (Hugging Face 镜像)
MODEL_SOURCE="modelscope"
MODEL_REPO="AI-ModelScope/gemma-2-2b-it"
```

---

## 📂 安装路径配置

### 默认路径

```bash
# Node.js (通过 nvm)
NVM_DIR="$HOME/.nvm"
NODEJS_INSTALL_DIR="$NVM_DIR/versions/node"

# OpenClaw
OPENCLAW_INSTALL_DIR="$HOME/.openclaw"
OPENCLAW_BIN_DIR="$OPENCLAW_INSTALL_DIR/bin"

# oMLX
OMLX_INSTALL_DIR="/Applications/oMLX.app"
OMLX_DATA_DIR="$HOME/.omlx"

# AI 模型
MODEL_CACHE_DIR="$HOME/.omlx/models"
MODEL_DOWNLOAD_DIR="$MODEL_CACHE_DIR/gemma-4-e4b-it-4bit"

# 配置文件
CONFIG_DIR="$HOME/.macclaw-installer"
STATE_FILE="$CONFIG_DIR/state.json"
LOG_FILE="$HOME/macclaw-install.log"
```

---

## ⚙️ 安装选项配置

### 自动化选项

```bash
# 是否自动确认所有提示
AUTO_CONFIRM="true"

# 是否自动选择所有组件
AUTO_SELECT_ALL="true"

# 是否跳过交互式选择
SKIP_INTERACTIVE="true"

# 是否显示详细日志
VERBOSE_LOGGING="true"
```

### 网络选项

```bash
# 下载超时（秒）
DOWNLOAD_TIMEOUT=300

# 重试次数
MAX_RETRIES=3

# 是否使用代理
USE_PROXY="false"
PROXY_URL=""
```

---

## 🔧 系统要求配置

### 最低要求

```bash
# macOS 版本
MIN_MACOS_VERSION="12.0"

# 内存（GB）
MIN_MEMORY_GB=16

# 磁盘空间（GB）
MIN_DISK_GB=20

# CPU 架构
SUPPORTED_ARCHS="arm64 x86_64"
```

### 必需工具

```bash
# Xcode Command Line Tools
REQUIRED_COMMANDS=("git" "clang" "make" "curl" "python3")
```

---

## 📊 安装流程配置

### 安装步骤

```bash
# 1. 环境检查
CHECK_ENVIRONMENT="true"

# 2. 配置下载源
CONFIGURE_SOURCES="auto"  # auto | china | official

# 3. 安装 Node.js
INSTALL_NODEJS="true"

# 4. 安装 OpenClaw
INSTALL_OPENCLAW="true"

# 5. 安装 oMLX
INSTALL_OMLX="true"

# 6. 下载 AI 模型
DOWNLOAD_MODEL="true"

# 7. 配置集成
CONFIGURE_INTEGRATION="true"

# 8. 创建默认 Agents
CREATE_AGENTS="true"

# 9. 安装 Skills
INSTALL_SKILLS="true"

# 10. 启动服务
START_SERVICES="true"

# 11. 验证安装
VERIFY_INSTALLATION="true"
```

---

## 🎯 后安装配置

### 服务配置

```bash
# OpenClaw Gateway 端口
OPENCLAW_GATEWAY_PORT=18789

# oMLX 服务端口
OMLX_PORT=8008

# 是否自动启动服务
AUTO_START_SERVICES="true"

# 是否设置开机自启
ENABLE_AUTO_START="false"
```

### 默认 Agents 配置

```bash
# 默认创建的 Agents
DEFAULT_AGENTS=(
    "main:主要助手，负责日常任务"
    "assistant:辅助助手，协助主要助手"
)

# Agent 配置路径
AGENTS_CONFIG_DIR="$HOME/.openclaw/agents"
```

### Skills 配置

```bash
# 默认安装的 Skills
DEFAULT_SKILLS=(
    "filesystem:文件系统操作"
    "web:网络访问能力"
    "system:系统信息获取"
)

# Skills 安装路径
SKILLS_INSTALL_DIR="$HOME/.openclaw/skills"
```

---

## 📝 自定义配置

### 环境变量

用户可以通过环境变量自定义安装：

```bash
# 自定义安装目录
export MACCLAW_INSTALL_DIR="/custom/path"

# 选择下载源
export MACCLAW_MIRROR="china"

# 跳过特定组件
export MACCLAW_SKIP_MODEL="true"

# 使用代理
export MACCLAW_PROXY="http://proxy.example.com:8080"
```

### 配置文件优先级

1. 环境变量（最高优先级）
2. 命令行参数
3. 配置文件（config.md）
4. 默认配置（最低优先级）

---

## 🔍 故障排除配置

### 日志级别

```bash
# DEBUG: 详细调试信息
# INFO: 一般信息（默认）
# WARNING: 警告信息
# ERROR: 仅错误信息
LOG_LEVEL="INFO"
```

### 调试模式

```bash
# 启用调试模式
DEBUG_MODE="false"

# 保留临时文件
KEEP_TEMP_FILES="false"

# 显示详细命令
VERBOSE_COMMANDS="false"
```

---

## 📞 支持信息

**项目地址**: https://github.com/changzhi777/mactools
**问题反馈**: https://github.com/changzhi777/mactools/issues
**文档**: https://github.com/changzhi777/mactools/blob/main/README.md

**作者**: 外星动物（常智）
**邮箱**: 14455975@qq.com
**组织**: IoTchange

---

**配置文件版本**: V1.0.1
**最后更新**: 2026-04-12
