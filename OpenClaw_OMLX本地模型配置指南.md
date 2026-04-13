# OpenClaw + OMLX 本地模型配置完整指南

**版本**: V1.0.0
**更新时间**: 2026-04-12
**作者**: 外星动物（常智）
**组织**: IoTchange
**邮箱**: 14455975@qq.com

---

## 📋 目录

- [概述](#概述)
- [系统要求](#系统要求)
- [安装步骤](#安装步骤)
- [配置说明](#配置说明)
- [使用方法](#使用方法)
- [性能对比](#性能对比)
- [故障排除](#故障排除)
- [高级配置](#高级配置)
- [最佳实践](#最佳实践)

---

## 概述

### 什么是 OpenClaw + OMLX？

**OpenClaw** 是一个强大的 AI 开发工具链，支持多种模型提供商。

**OMLX** (oMLX) 是一个本地推理引擎，可以在你的 Mac 上运行 AI 模型，无需将数据发送到云端。

### 组合优势

| 特性 | 云端 API | 本地 OMLX |
|------|----------|-----------|
| **隐私** | ❌ 数据上传 | ✅ 完全本地 |
| **成本** | ❌ 按使用付费 | ✅ 完全免费 |
| **延迟** | ~100ms | ~50ms |
| **可用性** | 依赖网络 | ✅ 随时可用 |
| **定制性** | ❌ 受限于服务商 | ✅ 完全控制 |

### 适用场景

✅ **推荐使用本地模型**：
- 敏感数据处理（代码、文档）
- 频繁的简单对话
- 批量文本处理
- 网络不稳定环境
- 成本敏感项目

❌ **推荐使用云端 API**：
- 复杂推理任务
- 需要最新知识
- 多模态任务
- 超长上下文

---

## 系统要求

### 硬件要求

| 组件 | 最低配置 | 推荐配置 |
|------|----------|----------|
| **芯片** | Apple Silicon M1/M2 | M3/M4 或更高 |
| **内存** | 16GB | 32GB 或更高 |
| **磁盘** | 20GB 可用空间 | 50GB SSD |
| **网络** | 稳定连接（下载模型） | - |

### 软件要求

```bash
# macOS 版本
macOS 12.0 或更高

# 必需工具
- Xcode Command Line Tools
- Python 3.8+
- Node.js (LTS)
```

### 检查系统环境

```bash
# 检查 macOS 版本
sw_vers

# 检查内存
system_profiler SPHardwareDataType | grep Memory

# 检查可用磁盘空间
df -h /

# 检查 Xcode Tools
xcode-select -p
```

---

## 安装步骤

### 方案 1: 使用国内源安装脚本（推荐）

这是最快的方式，所有组件都从国内镜像下载。

```bash
# 1. 下载安装脚本
cd /Users/mac/cz_code/mactools
curl -fsSL https://raw.githubusercontent.com/changzhi777/mactools/main/openclaw-china-installer.sh -o openclaw-china-installer.sh

# 2. 添加执行权限
chmod +x openclaw-china-installer.sh

# 3. 运行安装
sudo bash openclaw-china-installer.sh
```

#### 安装菜单说明

启动后会显示主菜单：

```
╔════════════════════════════════════════════════════════════╗
║       OpenClaw 国内源安装器 V1.0.0                          ║
╚════════════════════════════════════════════════════════════╝

请选择安装模式：

  1) 🚀 快速安装（推荐）
     自动安装所有依赖和 OpenClaw

  2) ⚙️  自定义安装
     选择性安装组件

  3) 📋 查看系统信息
     检查当前环境

  0) 🚪 退出
```

**推荐选择 1（快速安装）**，会自动安装：
- ✅ Node.js (LTS 版本)
- ✅ OpenClaw CLI
- ✅ oMLX 本地推理引擎
- ✅ gemma-4-e4b-it-4bit AI 模型

### 方案 2: 手动分步安装

如果你想更精细地控制安装过程，可以手动安装各个组件。

#### 步骤 1: 安装 Node.js

```bash
# 使用 nvm 安装（推荐）
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash

# 重新加载 shell 配置
source ~/.bashrc  # 或 source ~/.zshrc

# 安装最新 LTS 版本
nvm install --lts
nvm use --lts
```

#### 步骤 2: 安装 OpenClaw

```bash
# 使用国内镜像（推荐）
npm config set registry https://registry.npmmirror.com

# 全局安装 OpenClaw
npm install -g @openclaw/cli

# 验证安装
openclaw --version
```

#### 步骤 3: 安装 OMLX

```bash
# 使用 pip 清华镜像
pip3 install -i https://pypi.tuna.tsinghua.edu.cn/simple omlx

# 或从官网下载应用
# 访问 https://omlx.ai 下载 macOS 应用
```

#### 步骤 4: 下载 AI 模型

```bash
# 使用 OMLX 下载 gemma-4-e4b-it-4bit 模型（约 4GB）
omlx model download gemma-4-e4b-it-4bit

# 查看已下载的模型
omlx model list
```

### 安装验证

```bash
# 1. 检查 OpenClaw 版本
openclaw --version

# 2. 检查 OMLX 服务
omlx --help

# 3. 查看配置文件
cat ~/.openclaw/openclaw.json | jq .

# 4. 测试模型连接
openclaw infer model list
```

---

## 配置说明

### 默认配置结构

安装完成后，OpenClaw 会自动创建配置文件：

**配置文件位置**: `~/.openclaw/openclaw.json`

### 核心配置项

#### 1. OMLX 提供商配置

```json
{
  "models": {
    "providers": {
      "omlx": {
        "baseUrl": "http://127.0.0.1:8008/v1",
        "apiKey": "ak47",
        "api": "openai-completions",
        "models": [
          {
            "id": "gemma-4-e4b-it-4bit",
            "name": "Gemma 4 4B Instruct 4bit",
            "contextWindow": 32768,
            "maxTokens": 4096
          }
        ]
      }
    }
  }
}
```

**配置说明**：
- `baseUrl`: OMLX 服务地址（默认端口 8008）
- `apiKey`: 固定值 `ak47`（OMLX 默认配置）
- `contextWindow`: 上下文窗口大小（32K tokens）
- `maxTokens`: 最大生成 tokens 数

#### 2. 默认模型配置

```json
{
  "agents": {
    "defaults": {
      "models": {
        "omlx/gemma-4-e4b-it-4bit": {
          "alias": "Gemma-Local"
        }
      },
      "model": {
        "primary": "omlx/gemma-4-e4b-it-4bit",
        "fallbacks": [
          "anthropic/claude-sonnet-4-6"
        ]
      }
    }
  }
}
```

**配置说明**：
- `primary`: 主模型（本地 OMLX）
- `fallbacks`: 备用模型（云端 API）
- `alias`: 模型别名（简化调用）

#### 3. 网关配置

```json
{
  "gateway": {
    "mode": "local",
    "port": 18789,
    "auth": {
      "mode": "token",
      "token": "your-token-here"
    }
  }
}
```

### 启动 OMLX 服务

#### 方式 1: 使用 OMLX 应用

```bash
# 1. 打开 OMLX 应用
open /Applications/oMLX.app

# 2. 在应用中启动服务器
# 默认运行在 http://127.0.0.1:8008
```

#### 方式 2: 命令行启动

```bash
# 启动 OMLX 服务器
omlx serve --port 8008

# 后台运行
nohup omlx serve --port 8008 > ~/omlx.log 2>&1 &

# 查看日志
tail -f ~/omlx.log
```

### 验证配置

```bash
# 1. 检查 OMLX 服务状态
curl -s http://127.0.0.1:8008/v1/models \
  -H "Authorization: Bearer ak47" | jq .

# 预期输出：
# {
#   "object": "list",
#   "data": [
#     {
#       "id": "gemma-4-e4b-it-4bit",
#       "object": "model"
#     }
#   ]
# }

# 2. 测试推理
curl -s http://127.0.0.1:8008/v1/chat/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer ak47" \
  -d '{
    "model": "gemma-4-e4b-it-4bit",
    "messages": [{"role": "user", "content": "你好"}],
    "max_tokens": 50
  }' | jq .

# 3. 检查 OpenClaw 配置
openclaw config get models.providers.omlx
```

---

## 使用方法

### 基础使用

#### 1. 交互式对话

```bash
# 使用默认模型（OMLX Gemma）
openclaw agent

# 指定使用 OMLX 模型
openclaw agent --model omlx/gemma-4-e4b-it-4bit

# 使用别名
openclaw agent --model Gemma-Local
```

**对话示例**：
```
> 你好，请介绍一下你自己
> 帮我写一个 Python 脚本，批量重命名文件
> 解释这段代码的作用
> 优化这个函数的性能
```

#### 2. 单次推理

```bash
# 简单推理
openclaw infer model run \
  --model omlx/gemma-4-e4b-it-4bit \
  --prompt "什么是量子计算？"

# 交互式聊天
openclaw infer chat --model omlx/gemma-4-e4b-it-4bit
```

#### 3. 批量处理

```bash
# 创建批处理脚本
cat > batch_process.sh << 'EOF'
#!/bin/bash

# 文件列表
files=("file1.txt" "file2.txt" "file3.txt")

# 批量处理
for file in "${files[@]}"; do
  echo "处理 $file..."
  openclaw infer model run \
    --model omlx/gemma-4-e4b-it-4bit \
    --prompt "$(cat $file)" \
    > "${file%.txt}_processed.txt"
done

echo "批处理完成！"
EOF

chmod +x batch_process.sh
./batch_process.sh
```

### 高级使用

#### 1. 模型切换

```bash
# 查看所有可用模型
openclaw infer model list

# 切换到云端模型（复杂任务）
openclaw agent --model anthropic/claude-sonnet-4-6

# 切换回本地模型
openclaw agent --model omlx/gemma-4-eb-it-4bit
```

#### 2. 自定义配置

```bash
# 方式 1: 使用配置命令
openclaw config set agents.defaults.model.primary omlx/gemma-4-e4b-it-4bit

# 方式 2: 直接编辑配置文件
openclaw config file
# 使用你喜欢的编辑器编辑文件

# 验证配置
openclaw config validate
```

#### 3. 网关管理

```bash
# 启动网关
openclaw gateway start

# 查看网关状态
openclaw gateway status

# 查看网关日志
openclaw gateway logs

# 停止网关
openclaw gateway stop
```

### 实际应用场景

#### 场景 1: 代码审查助手

```bash
# 启动 agent
openclaw agent --model Gemma-Local

# 代码审查对话
> 请审查以下 Python 代码，找出潜在问题：
>
> def process_data(data):
>     result = []
>     for item in data:
>         result.append(item.upper())
>     return result

> 如何优化这段代码的性能？

> 添加错误处理和类型提示
```

#### 场景 2: 文档生成器

```bash
# 创建文档生成脚本
cat > generate_docs.sh << 'EOF'
#!/bin/bash

# 输入代码文件
CODE_FILE=$1

# 生成文档
openclaw infer model run \
  --model omlx/gemma-4-e4b-it-4bit \
  --prompt "为以下代码生成详细的文档说明：\n\n$(cat $CODE_FILE)" \
  > "${CODE_FILE%.md}_docs.md"

echo "文档已生成：${CODE_FILE%.md}_docs.md"
EOF

chmod +x generate_docs.sh

# 使用示例
./generate_docs.sh my_function.py
```

#### 场景 3: 智能搜索助手

```bash
# 创建搜索助手
cat > search_assistant.sh << 'EOF'
#!/bin/bash

QUERY="$1"

# 使用本地模型优化搜索查询
IMPROVED_QUERY=$(openclaw infer model run \
  --model omlx/gemma-4-e4b-it-4bit \
  --prompt "将以下搜索查询优化为更精确的形式：$QUERY" \
  --max-tokens 50)

echo "优化后的查询：$IMPROVED_QUERY"

# 执行搜索（这里使用 echo 作为示例）
# 实际应用中可以调用搜索引擎或数据库
echo "搜索结果：..."
EOF

chmod +x search_assistant.sh

# 使用示例
./search_assistant.sh "python 异常处理最佳实践"
```

---

## 性能对比

### 本地 vs 云端

| 指标 | OMLX Gemma (本地) | Claude Sonnet (云端) |
|------|-------------------|---------------------|
| **首 Token 延迟** | ~200ms | ~100ms |
| **生成速度** | ~50 tok/s | ~80 tok/s |
| **上下文窗口** | 32K | 200K |
| **工具调用** | ❌ 不支持 | ✅ 完全支持 |
| **成本** | 完全免费 | $3/1M tokens |
| **隐私** | ✅ 完全本地 | ❌ 数据上传 |

### 性能优化建议

#### 1. 内存优化

```bash
# 减少上下文窗口（节省内存）
openclaw config set models.providers.omlx.models[0].contextWindow 16384

# 降低最大 tokens
openclaw config set models.providers.omlx.models[0].maxTokens 2048
```

#### 2. 并发处理

```bash
# 启动多个 OMLX 实例（不同端口）
omlx serve --port 8008 &
omlx serve --port 8009 &

# 配置多个提供商
openclaw config set models.providers.omlx2.baseUrl http://127.0.0.1:8009/v1
```

#### 3. 缓存策略

```bash
# 启用响应缓存
openclaw config set agents.defaults.cache.enabled true

# 设置缓存大小
openclaw config set agents.defaults.cache.maxSize 1000
```

---

## 故障排除

### 常见问题

#### 问题 1: OMLX 服务无法启动

**症状**：
```
Error: Cannot connect to OMLX service
```

**解决方案**：
```bash
# 1. 检查 OMLX 进程
ps aux | grep omlx

# 2. 检查端口占用
lsof -i :8008

# 3. 如果端口被占用，杀掉进程
kill -9 <PID>

# 4. 重新启动 OMLX
omlx serve --port 8008
```

#### 问题 2: 模型未找到

**症状**：
```
Error: Model 'gemma-4-e4b-it-4bit' not found
```

**解决方案**：
```bash
# 1. 检查已安装的模型
omlx model list

# 2. 如果模型不存在，下载模型
omlx model download gemma-4-e4b-it-4bit

# 3. 验证模型文件
ls -lh ~/.omlx/models/
```

#### 问题 3: 内存不足

**症状**：
```
Error: Out of memory
```

**解决方案**：
```bash
# 1. 减少上下文窗口
openclaw config set models.providers.omlx.models[0].contextWindow 8192

# 2. 降低最大 tokens
openclaw config set models.providers.omlx.models[0].maxTokens 1024

# 3. 关闭其他应用释放内存

# 4. 重启 OMLX 服务
pkill omlx
omlx serve --port 8008
```

#### 问题 4: 响应速度慢

**症状**：生成速度明显变慢

**解决方案**：
```bash
# 1. 检查系统负载
top -o cpu

# 2. 重启 OMLX 服务
pkill omlx
omlx serve --port 8008

# 3. 检查磁盘空间
df -h /

# 4. 清理缓存
openclaw config set agents.defaults.cache.clear true
```

### 诊断命令

```bash
# 完整系统诊断
openclaw doctor

# 查看详细日志
openclaw gateway logs --level debug

# 测试模型连接
curl -v http://127.0.0.1:8008/v1/models \
  -H "Authorization: Bearer ak47"

# 验证配置文件
openclaw config validate
```

### 日志查看

```bash
# OMLX 服务日志
tail -f ~/omlx.log

# OpenClaw 网关日志
openclaw gateway logs --follow

# Agent 日志
ls -lt ~/.openclaw/logs/
tail -f ~/.openclaw/logs/latest.log
```

---

## 高级配置

### 多模型配置

#### 添加更多本地模型

```bash
# 1. 下载新模型
omlx model download qwen3.5-9b-mlx-lm-mxfp4

# 2. 添加到 OpenClaw 配置
openclaw config set models.providers.omlx.models[1].id qwen3.5-9b-mlx-lm-mxfp4
openclaw config set models.providers.omlx.models[1].name "Qwen 3.5 9B"

# 3. 设置别名
openclaw config set agents.defaults.models.omlx/qwen3.5-9b-mlx-lm-mxfp4.alias Qwen-Local

# 4. 验证配置
openclaw infer model list
```

### 混合使用本地和云端模型

```json
{
  "agents": {
    "defaults": {
      "model": {
        "primary": "omlx/gemma-4-e4b-it-4bit",
        "fallbacks": [
          "anthropic/claude-sonnet-4-6",
          "openai/gpt-4"
        ]
      }
    }
  }
}
```

**工作原理**：
1. 优先使用本地 OMLX 模型
2. 如果本地模型失败，自动切换到 Claude Sonnet
3. 如果云端 API 也失败，尝试 GPT-4

### 自定义模型路由

```bash
# 根据任务类型自动选择模型
cat > smart_router.sh << 'EOF'
#!/bin/bash

TASK_TYPE=$1
PROMPT="$2"

case $TASK_TYPE in
  "simple")
    # 简单任务使用本地模型
    openclaw infer model run \
      --model omlx/gemma-4-e4b-it-4bit \
      --prompt "$PROMPT"
    ;;
  "complex")
    # 复杂任务使用云端模型
    openclaw infer model run \
      --model anthropic/claude-sonnet-4-6 \
      --prompt "$PROMPT"
    ;;
  *)
    echo "Unknown task type: $TASK_TYPE"
    exit 1
    ;;
esac
EOF

chmod +x smart_router.sh

# 使用示例
./smart_router.sh simple "什么是 Python？"
./smart_router.sh complex "设计一个分布式系统的架构"
```

### 自动化脚本

#### 开机自动启动 OMLX

```bash
# 创建启动脚本
cat > ~/start_omlx.sh << 'EOF'
#!/bin/bash

# 等待系统启动完成
sleep 30

# 启动 OMLX 服务
omlx serve --port 8008 > ~/omlx.log 2>&1 &

echo "OMLX 服务已启动"
EOF

chmod +x ~/start_omlx.sh

# 添加到登录项（macOS）
osascript -e 'tell application "System Events" to make login item at end with properties {name:"OMLX", path:"/Users/mac/start_omlx.sh", hidden:false}'
```

#### 定时任务

```bash
# 创建定时任务脚本
cat > ~/daily_backup.sh << 'EOF'
#!/bin/bash

# 备份 OpenClaw 配置
cp ~/.openclaw/openclaw.json ~/.openclaw/backup/openclaw_$(date +%Y%m%d).json

# 清理旧备份（保留最近 7 天）
find ~/.openclaw/backup -name "openclaw_*.json" -mtime +7 -delete

echo "备份完成"
EOF

chmod +x ~/daily_backup.sh

# 添加到 crontab（每天凌晨 2 点执行）
crontab -e
# 添加以下行：
# 0 2 * * * /Users/mac/daily_backup.sh
```

---

## 最佳实践

### 1. 模型选择策略

| 任务类型 | 推荐模型 | 原因 |
|---------|---------|------|
| **简单对话** | OMLX Gemma | 免费、快速 |
| **代码生成** | Claude Sonnet | 质量更高 |
| **文档写作** | OMLX Gemma | 成本低 |
| **复杂推理** | Claude Sonnet | 能力强 |
| **批量处理** | OMLX Gemma | 无 API 费用 |
| **实时应用** | OMLX Gemma | 低延迟 |

### 2. 成本优化

```bash
# 设置使用限制
openclaw config set agents.defaults.limits.maxTokensPerRequest 1000
openclaw config set agents.defaults.limits.maxRequestsPerMinute 60

# 启用缓存
openclaw config set agents.defaults.cache.enabled true

# 优先使用本地模型
openclaw config set agents.defaults.model.primary omlx/gemma-4-e4b-it-4bit
```

### 3. 安全建议

```bash
# 1. 保护配置文件
chmod 600 ~/.openclaw/openclaw.json

# 2. 定期备份
cp ~/.openclaw/openclaw.json ~/.openclaw/openclaw.json.backup

# 3. 使用环境变量存储敏感信息
export OPENCLAW_API_KEY="your-api-key"

# 4. 限制网关访问
openclaw config set gateway.bind loopback
```

### 4. 性能监控

```bash
# 创建性能监控脚本
cat > monitor_performance.sh << 'EOF'
#!/bin/bash

# 监控 OMLX 服务
echo "=== OMLX 服务状态 ==="
curl -s http://127.0.0.1:8008/v1/models \
  -H "Authorization: Bearer ak47" | jq .

# 监控系统资源
echo -e "\n=== 系统资源 ==="
top -l 1 | head -n 10

# 监控 OpenClaw 进程
echo -e "\n=== OpenClaw 进程 ==="
ps aux | grep openclaw | grep -v grep

# 监控日志文件大小
echo -e "\n=== 日志文件大小 ==="
du -sh ~/.openclaw/logs/
EOF

chmod +x monitor_performance.sh

# 定期执行
./monitor_performance.sh
```

### 5. 开发工作流

```bash
# 创建开发工作流脚本
cat > dev_workflow.sh << 'EOF'
#!/bin/bash

# 1. 启动服务
echo "启动 OMLX 服务..."
omlx serve --port 8008 > ~/omlx.log 2>&1 &

# 2. 等待服务就绪
sleep 5

# 3. 验证连接
echo "验证服务连接..."
curl -s http://127.0.0.1:8008/v1/models \
  -H "Authorization: Bearer ak47" | jq .

# 4. 启动 OpenClaw 网关
echo "启动 OpenClaw 网关..."
openclaw gateway start

# 5. 打开控制面板
echo "打开控制面板..."
openclaw dashboard

echo "开发环境就绪！"
EOF

chmod +x dev_workflow.sh

# 每次开发前执行
./dev_workflow.sh
```

---

## 附录

### A. 配置文件完整示例

```json
{
  "gateway": {
    "mode": "local",
    "auth": {
      "mode": "token",
      "token": "your-token-here"
    },
    "port": 18789,
    "bind": "loopback"
  },
  "agents": {
    "defaults": {
      "workspace": "/Users/mac/.openclaw/workspace",
      "models": {
        "omlx/gemma-4-e4b-it-4bit": {
          "alias": "Gemma-Local"
        },
        "anthropic/claude-sonnet-4-6": {
          "alias": "Sonnet"
        }
      },
      "model": {
        "primary": "omlx/gemma-4-e4b-it-4bit",
        "fallbacks": [
          "anthropic/claude-sonnet-4-6"
        ]
      }
    }
  },
  "models": {
    "mode": "merge",
    "providers": {
      "omlx": {
        "baseUrl": "http://127.0.0.1:8008/v1",
        "apiKey": "ak47",
        "api": "openai-completions",
        "models": [
          {
            "id": "gemma-4-e4b-it-4bit",
            "name": "Gemma 4 4B Instruct 4bit",
            "contextWindow": 32768,
            "maxTokens": 4096
          }
        ]
      }
    }
  }
}
```

### B. 常用命令速查表

```bash
# 安装与配置
sudo bash openclaw-china-installer.sh    # 安装
openclaw --version                        # 查看版本
openclaw config file                      # 查看配置文件

# 服务管理
omlx serve --port 8008                    # 启动 OMLX
openclaw gateway start                    # 启动网关
openclaw gateway status                   # 网关状态
openclaw gateway logs                     # 查看日志

# 模型使用
openclaw agent                            # 交互式对话
openclaw agent --model Gemma-Local        # 指定模型
openclaw infer model list                 # 列出模型
openclaw infer model run --prompt "..."   # 单次推理

# 配置管理
openclaw config get <path>                # 获取配置
openclaw config set <path> <value>        # 设置配置
openclaw config validate                  # 验证配置

# 诊断
openclaw doctor                           # 系统诊断
openclaw --help                           # 帮助信息
```

### C. 参考资源

**官方文档**：
- OpenClaw 官方文档: https://docs.openclaw.ai
- OMLX 官方网站: https://omlx.ai
- Gemma 模型: https://ai.google.dev/gemma

**社区资源**：
- OpenClaw GitHub: https://github.com/IoTchange/openclaw
- OMLX GitHub: https://github.com/iotfusion-ai/omlx

**项目地址**：
- MacTools 项目: https://github.com/changzhi777/mactools
- 问题反馈: https://github.com/changzhi777/mactools/issues

---

## 总结

通过本指南，你应该已经成功配置了 OpenClaw + OMLX 本地模型环境。这个组合为你提供了：

✅ **隐私保护**: 所有数据处理都在本地完成
✅ **成本优化**: 无需支付 API 费用
✅ **灵活切换**: 可以在本地和云端模型之间自由切换
✅ **完整功能**: 保留了 OpenClaw 的所有强大功能

### 快速开始

```bash
# 启动 OMLX 服务
omlx serve --port 8008

# 启动 OpenClaw 网关
openclaw gateway start

# 开始使用
openclaw agent
```

### 获取帮助

如果遇到问题，请：
1. 查看 [故障排除](#故障排除) 部分
2. 运行 `openclaw doctor` 进行诊断
3. 查看日志文件: `~/.openclaw/logs/`
4. 提交 Issue: https://github.com/changzhi777/mactools/issues

---

**配置完成后，享受完全私有的本地 AI 体验！** 🚀

---

**最后更新**: 2026-04-12
**文档版本**: V1.0.0
**作者**: 外星动物（常智）
**邮箱**: 14455975@qq.com
**组织**: IoTchange

---

## 版权声明

MIT License

Copyright (C) 2026 IoTchange

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
