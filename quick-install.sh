#!/bin/bash
#
# MacTools 快速安装脚本
# 作者: 外星动物（常智）
# 组织: IoTchange
# 邮箱: 14455975@qq.com
# 版本: V1.0.1
# 版权: Copyright (C) 2026 IoTchange - All Rights Reserved
#
# 说明: 最小依赖的快速安装脚本，下载后可本地执行
# 使用: curl -fsSL https://raw.githubusercontent.com/changzhi777/mactools/main/quick-install.sh -o quick-install.sh && sudo bash quick-install.sh
#

set -e

# ============================================
# 颜色定义
# ============================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# ============================================
# 配置参数（从 config.md 读取的默认值）
# ============================================

# 安装选项
AUTO_CONFIRM="${AUTO_CONFIRM:-true}"
AUTO_SELECT_ALL="${AUTO_SELECT_ALL:-true}"
SKIP_INTERACTIVE="${SKIP_INTERACTIVE:-true}"

# 下载源配置
CONFIGURE_SOURCES="${CONFIGURE_SOURCES:-auto}"

# 安装路径
NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
OPENCLAW_INSTALL_DIR="${OPENCLAW_INSTALL_DIR:-$HOME/.openclaw}"
OMLX_INSTALL_DIR="${OMLX_INSTALL_DIR:-/Applications/oMLX.app}"

# 服务端口
OPENCLAW_GATEWAY_PORT="${OPENCLAW_GATEWAY_PORT:-18789}"
OMLX_PORT="${OMLX_PORT:-8008}"

# 日志
LOG_FILE="${LOG_FILE:-$HOME/macclaw-install.log}"

# ============================================
# 日志函数
# ============================================

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1" | tee -a "$LOG_FILE"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1" | tee -a "$LOG_FILE"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1" | tee -a "$LOG_FILE"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1" | tee -a "$LOG_FILE"
}

# ============================================
# 错误处理
# ============================================

cleanup() {
    log_info "清理临时文件..."
    rm -rf /tmp/macclaw-* 2>/dev/null || true
}

trap cleanup EXIT

trap 'log_error "安装过程中发生错误，请查看日志: $LOG_FILE"; cleanup; exit 1' ERR

# ============================================
# 环境检查
# ============================================

check_environment() {
    log_info "🔍 检查安装环境..."

    # 检查 macOS 版本
    local macos_version=$(sw_vers -productVersion)
    local major=$(echo "$macos_version" | cut -d. -f1)

    if [ "$major" -lt 12 ]; then
        log_error "macOS 版本过低，需要 macOS 12 或更高版本"
        log_info "当前版本: $macos_version"
        exit 1
    fi

    log_success "✅ macOS 版本: $macos_version"

    # 检查 CPU 架构
    local arch=$(uname -m)
    log_success "✅ CPU 架构: $arch"

    # 检查内存
    local memory_gb=$(sysctl -n hw.memsize)
    memory_gb=$((memory_gb / 1024 / 1024 / 1024))
    log_success "✅ 系统内存: ${memory_gb}GB"

    # 检查磁盘空间
    local available_mb=$(df -m / | tail -1 | awk '{print $4}')
    local available_gb=$((available_mb / 1024))
    log_success "✅ 可用磁盘空间: ${available_gb}GB"

    if [ "$available_gb" -lt 20 ]; then
        log_error "磁盘空间不足，需要至少 20GB"
        exit 1
    fi

    # 检查 Xcode Command Line Tools
    if ! xcode-select -p &>/dev/null; then
        log_error "❌ Xcode Command Line Tools 未安装"
        echo ""
        echo "💡 请先安装 Xcode Command Line Tools："
        echo ""
        echo "  xcode-select --install"
        echo ""
        echo "⏳ 安装完成后，请重新运行此脚本"
        echo ""
        exit 1
    fi

    log_success "✅ Xcode Command Line Tools 已安装"

    # 检查必需命令
    local required_commands=("curl" "git" "python3")
    for cmd in "${required_commands[@]}"; do
        if ! command -v "$cmd" &>/dev/null; then
            log_error "缺少必需命令: $cmd"
            exit 1
        fi
    done

    log_success "✅ 所有必要工具可用"
}

# ============================================
# 配置下载源
# ============================================

configure_sources() {
    log_info "⚙️  配置下载源..."

    # 检测是否需要使用国内源
    if [ "$CONFIGURE_SOURCES" = "auto" ]; then
        # 简单检测：如果能访问 GitHub，使用官方源
        if curl -s --connect-timeout 3 https://github.com &>/dev/null; then
            CONFIGURE_SOURCES="official"
            log_info "使用官方下载源"
        else
            CONFIGURE_SOURCES="china"
            log_info "检测到网络限制，使用国内镜像源"
        fi
    fi

    if [ "$CONFIGURE_SOURCES" = "china" ]; then
        # 配置 npm 淘宝镜像
        if command -v npm &>/dev/null; then
            npm config set registry https://registry.npmmirror.com
            log_success "✅ npm 淘宝镜像已配置"
        fi

        # 配置 pip 清华镜像
        if command -v pip3 &>/dev/null; then
            pip3 config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple 2>/dev/null || true
            log_success "✅ pip 清华镜像已配置"
        fi
    else
        log_info "使用官方下载源"
    fi
}

# ============================================
# 安装 Node.js
# ============================================

install_nodejs() {
    log_info "📦 安装 Node.js..."

    # 检查是否已安装
    if command -v node &>/dev/null; then
        local version=$(node --version)
        log_success "✅ Node.js 已安装: $version"
        return 0
    fi

    # 使用 nvm 安装
    if [ ! -d "$NVM_DIR" ]; then
        log_info "下载并安装 nvm..."

        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash

        # 加载 nvm
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    fi

    # 安装最新的 LTS 版本
    log_info "安装 Node.js LTS 版本..."
    bash -c "source $NVM_DIR/nvm.sh && nvm install --lts" || {
        log_error "Node.js 安装失败"
        return 1
    }

    # 验证安装
    if command -v node &>/dev/null; then
        local version=$(node --version)
        log_success "✅ Node.js 安装成功: $version"
    else
        log_error "Node.js 安装失败"
        return 1
    fi
}

# ============================================
# 安装 OpenClaw
# ============================================

install_openclaw() {
    log_info "📦 安装 OpenClaw CLI..."

    # 检查是否已安装
    if command -v openclaw &>/dev/null; then
        local version=$(openclaw --version 2>/dev/null | head -1)
        log_success "✅ OpenClaw 已安装: $version"
        return 0
    fi

    # 使用 npm 安装
    bash -c "source $NVM_DIR/nvm.sh && npm install -g @iotchange/openclaw" || {
        log_error "OpenClaw 安装失败"
        return 1
    }

    # 验证安装
    if command -v openclaw &>/dev/null; then
        log_success "✅ OpenClaw 安装成功"
    else
        log_error "OpenClaw 安装失败"
        return 1
    fi
}

# ============================================
# 安装 oMLX
# ============================================

install_omlx() {
    log_info "📦 安装 oMLX..."

    # 检查是否已安装
    if [ -d "$OMLX_INSTALL_DIR" ]; then
        log_success "✅ oMLX 已安装"
        return 0
    fi

    # 使用 pip 安装
    pip3 install --upgrade omlx || {
        log_error "oMLX 安装失败"
        return 1
    }

    log_success "✅ oMLX 安装成功"
}

# ============================================
# 下载 AI 模型
# ============================================

download_model() {
    log_info "📥 下载 AI 模型..."

    # 使用 OpenClaw 下载模型
    if command -v openclaw &>/dev/null; then
        openclaw model pull omlx/gemma-4-e4b-it-4bit || {
            log_warning "⚠️  模型下载失败，可以稍后手动下载"
            return 0
        }
        log_success "✅ AI 模型下载完成"
    else
        log_warning "⚠️  OpenClaw 未安装，跳过模型下载"
    fi
}

# ============================================
# 配置集成
# ============================================

configure_integration() {
    log_info "⚙️  配置集成..."

    # 初始化 OpenClaw
    if command -v openclaw &>/dev/null; then
        openclaw init || log_warning "OpenClaw 初始化失败"
    fi

    log_success "✅ 集成配置完成"
}

# ============================================
# 创建默认 Agents
# ============================================

create_agents() {
    log_info "🤖 创建默认 Agents..."

    if ! command -v openclaw &>/dev/null; then
        log_warning "OpenClaw 未安装，跳过 Agent 创建"
        return 0
    fi

    # 创建 main agent
    openclaw agents create main \
        --description "主要助手，负责日常任务" \
        --model omlx/gemma-4-e4b-it-4bit || log_warning "main agent 创建失败"

    # 创建 assistant agent
    openclaw agents create assistant \
        --description "辅助助手，协助主要助手" \
        --model omlx/gemma-4-e4b-it-4bit || log_warning "assistant agent 创建失败"

    log_success "✅ 默认 Agents 创建完成"
}

# ============================================
# 安装 Skills
# ============================================

install_skills() {
    log_info "🔧 安装 Skills..."

    if ! command -v openclaw &>/dev/null; then
        log_warning "OpenClaw 未安装，跳过 Skills 安装"
        return 0
    fi

    # 安装常用 Skills
    local skills=("filesystem" "web" "system")

    for skill in "${skills[@]}"; do
        log_info "安装 $skill skill..."
        openclaw skills install "$skill" || log_warning "$skill skill 安装失败"
    done

    log_success "✅ Skills 安装完成"
}

# ============================================
# 启动服务
# ============================================

start_services() {
    log_info "🚀 启动服务..."

    if ! command -v openclaw &>/dev/null; then
        log_warning "OpenClaw 未安装，跳过服务启动"
        return 0
    fi

    # 启动 OpenClaw Gateway
    openclaw gateway start || log_warning "OpenClaw Gateway 启动失败"

    # 等待服务启动
    sleep 3

    log_success "✅ 服务启动完成"
}

# ============================================
# 验证安装
# ============================================

verify_installation() {
    log_info "🔍 验证安装..."

    local all_ok=true

    # 检查 Node.js
    if command -v node &>/dev/null; then
        log_success "✅ Node.js: $(node --version)"
    else
        log_error "❌ Node.js 未安装"
        all_ok=false
    fi

    # 检查 OpenClaw
    if command -v openclaw &>/dev/null; then
        log_success "✅ OpenClaw: $(openclaw --version | head -1)"
    else
        log_error "❌ OpenClaw 未安装"
        all_ok=false
    fi

    # 检查 oMLX
    if [ -d "$OMLX_INSTALL_DIR" ]; then
        log_success "✅ oMLX 已安装"
    else
        log_error "❌ oMLX 未安装"
        all_ok=false
    fi

    # 检查服务
    if curl -s "http://127.0.0.1:$OPENCLAW_GATEWAY_PORT" &>/dev/null; then
        log_success "✅ OpenClaw Gateway 运行中 (端口 $OPENCLAW_GATEWAY_PORT)"
    else
        log_warning "⚠️  OpenClaw Gateway 未运行"
    fi

    if curl -s "http://127.0.0.1:$OMLX_PORT/health" &>/dev/null; then
        log_success "✅ oMLX 服务运行中 (端口 $OMLX_PORT)"
    else
        log_warning "⚠️  oMLX 服务未运行"
    fi

    if [ "$all_ok" = true ]; then
        log_success "🎉 安装验证通过！"
        return 0
    else
        log_warning "⚠️  部分组件安装失败，请查看日志"
        return 1
    fi
}

# ============================================
# 显示完成信息
# ============================================

show_completion() {
    clear
    cat << EOF
╔════════════════════════════════════════════════════════════╗
║              🎉 安装完成！                                ║
╚════════════════════════════════════════════════════════════╝

✅ 已安装组件:
  ✅ Node.js $(node --version 2>/dev/null || echo "")
  ✅ OpenClaw CLI
  ✅ oMLX 服务
  ✅ gemma-4-e4b-it-4bit 模型
  ✅ 默认 Agents (main, assistant)
  ✅ 常用 Skills

🌐 访问地址:
  Web UI: http://127.0.0.1:$OPENCLAW_GATEWAY_PORT/

📊 服务状态:
  ✅ OpenClaw Gateway 运行中 (端口 $OPENCLAW_GATEWAY_PORT)
  ✅ oMLX 服务运行中 (端口 $OMLX_PORT)

📝 日志文件:
  安装日志: $LOG_FILE

🔧 常用命令:
  # Agent 管理
  列出 Agents: openclaw agents list

  # 测试推理
  测试推理: openclaw infer model run --model omlx/gemma-4-e4b-it-4bit --prompt "你好"

  # 服务管理
  查看状态: openclaw gateway status
  重启服务: openclaw gateway restart

📚 更多帮助:
  项目地址: https://github.com/changzhi777/mactools
  问题反馈: https://github.com/changzhi777/mactools/issues

作者: 外星动物（常智）
组织: IoTchange
邮箱: 14455975@qq.com

EOF

    # 尝试打开浏览器
    if command -v open &>/dev/null; then
        sleep 2
        open "http://127.0.0.1:$OPENCLAW_GATEWAY_PORT/"
    fi
}

# ============================================
# 主安装流程
# ============================================

main() {
    # 初始化日志
    echo "=== MacTools 快速安装日志 ===" > "$LOG_FILE"
    echo "开始时间: $(date '+%Y-%m-%d %H:%M:%S')" >> "$LOG_FILE"
    echo "================================" >> "$LOG_FILE"

    # 显示欢迎信息
    clear
    cat << "EOF"
╔════════════════════════════════════════════════════════════╗
║       🦞 MacTools 快速安装器 V1.0.1                       ║
║       OpenClaw + oMLX 本地 AI 模型完整安装                 ║
╚════════════════════════════════════════════════════════════╝

作者: 外星动物（常智）
组织: IoTchange
邮箱: 14455975@qq.com

正在开始安装...
EOF

    # 检查环境
    check_environment

    # 配置下载源
    configure_sources

    # 安装组件
    log_info "🚀 开始安装组件..."
    echo ""

    install_nodejs
    install_openclaw
    install_omlx
    download_model
    configure_integration
    create_agents
    install_skills
    start_services

    # 验证安装
    echo ""
    verify_installation

    # 显示完成信息
    show_completion

    log_success "✅ 安装完成！"
    echo ""
    echo "📝 详细日志: $LOG_FILE"
}

# ============================================
# 运行主函数
# ============================================

main "$@"
