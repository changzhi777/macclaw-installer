# 本地 LLM 模型配置指南

**作者**: 外星动物（常智）
**组织**: IoTchange
**邮箱**: 14455975@qq.com
**版权**: Copyright (C) 2026 IoTchange - All Rights Reserved
**更新时间**: 2026-04-12

---

## 📋 概述

本指南介绍如何在 Hermes Agent 中配置本地 LLM 模型，支持两种方案：

| 方案 | 特点 | 适用场景 |
|------|------|----------|
| **OMMX** | Token 生成快（96 tok/s），GUI 应用 | 长文档生成、批量处理 |
| **llama.cpp** | 响应快（67ms TTFT），命令行 | 交互式对话、实时应用 |

---

## 🚀 快速开始

### 自动配置脚本

```bash
cd /Users/mac/cz_code/mactools/tools/hermes-agent-local
chmod +x setup-omlx.sh
./setup-omlx.sh
```

---

## 方案 1: OMLX 配置

### 步骤 1: 安装 OMLX

1. 访问 [omlx.ai](https://omlx.ai) 下载应用
2. 安装 OMLX 应用到 `/Applications/`

### 步骤 2: 下载模型

打开 OMLX 应用，搜索并下载推荐模型：

| 模型 | 大小 | 内存需求 | 特点 |
|------|------|----------|------|
| Qwen3.5-9B-mlx-lm-mxfp4 | ~5 GB | ~12 GB | 推理能力强，推荐 |

### 步骤 3: 启动服务器

在 OMLX 应用中启动服务器，默认运行在 `http://127.0.0.1:8000`

### 步骤 4: 测试服务

```bash
# 检查可用模型
curl -s http://127.0.0.1:8000/v1/models | jq .

# 测试对话
curl -s http://127.0.0.1:8000/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "Qwen3.5-9B-mlx-lm-mxfp4",
    "messages": [{"role": "user", "content": "Hello!"}],
    "max_tokens": 50
  }' | jq .
```

### 步骤 5: 配置 Hermes

```bash
# 运行配置向导
hermes model

# 选择 "Custom endpoint"
# 输入 Base URL: http://127.0.0.1:8000
# 输入 Model Name: Qwen3.5-9B-mlx-lm-mxfp4
```

---

## 方案 2: llama.cpp 配置

### 步骤 1: 安装 llama.cpp

```bash
# 安装 llama.cpp 和 huggingface-cli
brew install llama.cpp huggingface-cli
```

### 步骤 2: 下载模型

```bash
# 创建模型目录
mkdir -p ~/models

# 下载 Qwen3.5-9B GGUF 模型（~5.3GB）
huggingface-cli download unsloth/Qwen3.5-9B-GGUF \
  Qwen3.5-9B-Q4_K_M.gguf \
  --local-dir ~/models
```

### 步骤 3: 启动服务器

```bash
llama-server \
  -m ~/models/Qwen3.5-9B-Q4_K_M.gguf \
  -ngl 99 \
  -c 131072 \
  -np 1 \
  -fa on \
  --cache-type-k q4_0 \
  --cache-type-v q4_0 \
  --host 0.0.0.0
```

**参数说明**：

| 参数 | 说明 |
|------|------|
| `-ngl 99` | 全部层 GPU 加速 |
| `-c 131072` | 上下文窗口 128K tokens |
| `-np 1` | 单用户模式 |
| `-fa on` | Flash Attention |
| `--cache-type-k q4_0` | KV cache 4-bit 量化 |
| `--cache-type-v q4_0` | KV cache 4-bit 量化 |

### 步骤 4: 测试服务

```bash
# 检查可用模型
curl -s http://localhost:8080/v1/models | jq .

# 测试对话
curl -s http://localhost:8080/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "Qwen3.5-9B-Q4_K_M.gguf",
    "messages": [{"role": "user", "content": "Hello!"}],
    "max_tokens": 50
  }' | jq .
```

### 步骤 5: 配置 Hermes

```bash
# 运行配置向导
hermes model

# 选择 "Custom endpoint"
# 输入 Base URL: http://localhost:8080
# 输入 Model Name: Qwen3.5-9B-Q4_K_M.gguf
```

---

## 📊 性能对比

基于 Apple M5 Max, 128GB RAM 的基准测试：

| 指标 | llama.cpp | OMLX | 胜者 |
|------|-----------|------|------|
| 首次 Token (TTFT) | **67 ms** | 289 ms | llama.cpp (4.3x) |
| Token 生成 | 70 tok/s | **96 tok/s** | OMLX (1.37x) |
| 512 tokens 总时间 | 7.3s | **5.5s** | OMLX (1.25x) |

### 选择建议

| 使用场景 | 推荐方案 |
|----------|----------|
| 交互式对话 | llama.cpp |
| 实时工具 | llama.cpp |
| 长文档生成 | OMLX |
| 批量处理 | OMLX |
| 内存受限 (8-16GB) | llama.cpp |
| 多模型同时服务 | OMLX |

---

## 💾 内存优化

### llama.cpp KV Cache 优化

| KV Cache 类型 | 128K 上下文内存占用 |
|---------------|-------------------|
| f16 (默认) | ~16 GB |
| q8_0 | ~8 GB |
| **q4_0** | **~4 GB** |

**推荐配置**：
- 8GB 内存: `-c 32768` + `--cache-type-k q4_0 --cache-type-v q4_0`
- 16GB 内存: `-c 131072` + `--cache-type-k q4_0 --cache-type-v q4_0`
- 32GB+ 内存: `-c 131072` 或更大模型

---

## 🔧 Hermes 配置文件

### 环境变量配置

编辑 `~/.hermes/hermes-agent/.env`：

```bash
# OMLX 配置
HERMES_OMLX_BASE_URL=http://127.0.0.1:8000
HERMES_OMLX_MODEL=Qwen3.5-9B-mlx-lm-mxfp4

# llama.cpp 配置
HERMES_LLAMACPP_BASE_URL=http://localhost:8080
HERMES_LLAMACPP_MODEL=Qwen3.5-9B-Q4_K_M.gguf
```

### 超时配置

本地模型可能需要更长的处理时间：

```bash
# 在 .env 中添加
HERMES_STREAM_READ_TIMEOUT=1800  # 30分钟
```

---

## 🛠️ 故障排查

### 问题 1: 连接拒绝

**症状**: `curl: (7) Failed to connect`

**解决方案**:
```bash
# 检查服务是否运行
ps aux | grep -E "llama-server|omlx"

# 检查端口占用
lsof -i :8080  # llama.cpp
lsof -i :8000  # OMLX
```

### 问题 2: 内存不足

**症状**: `out of memory` 或系统卡顿

**解决方案**:
- 减少上下文大小: `-c 32768`
- 使用更小的模型
- 确保 KV cache 量化: `--cache-type-k q4_0 --cache-type-v q4_0`

### 问题 3: 模型未找到

**症状**: `model not found`

**解决方案**:
```bash
# 列出可用模型
curl -s http://localhost:8080/v1/models | jq '.data[].id'

# 确保模型名称与配置一致
```

---

## 📚 相关资源

- **Hermes Agent 官方文档**: https://docs.nousresearch.com
- **OMMX 官网**: https://omlx.ai
- **llama.cpp GitHub**: https://github.com/ggerganov/llama.cpp
- **Qwen 模型**: https://huggingface.co/Qwen

---

## ✅ 配置检查清单

完成配置后，使用以下清单验证：

- [ ] 本地服务已启动（端口 8080 或 8000）
- [ ] 模型已下载并可访问
- [ ] curl 测试成功返回响应
- [ ] Hermes 已配置 Custom endpoint
- [ ] Hermes 对话测试成功

---

**配置完成后，您可以享受完全私有的本地 LLM 体验！** 🚀

---

**最后更新**: 2026-04-12
**版本**: v1.0.0
