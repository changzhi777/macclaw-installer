#!/bin/bash
#
# OMLX 本地模型配置脚本
# 作者: 外星动物（常智）
# 组织: IoTchange
# 邮箱: 14455975@qq.com
# 版权: Copyright (C) 2026 IoTchange - All Rights Reserved
#

set -e

# ============================================================================
# 颜色定义
# ============================================================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# ============================================================================
# 工具函数
# ============================================================================

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_step() {
    echo -e "${PURPLE}[STEP]${NC} $1"
}

print_header() {
    echo ""
    echo -e "${CYAN}============================================================${NC}"
    echo -e "${CYAN}  $1${NC}"
    echo -e "${CYAN}============================================================${NC}"
    echo ""
}

# ============================================================================
# 检测函数
# ============================================================================

check_omlx_installed() {
    if [ -d "/Applications/omlx.app" ] || [ -d "/Applications/OMLX.app" ]; then
        return 0
    else
        return 1
    fi
}

check_omlx_running() {
    if curl -s http://127.0.0.1:8000/v1/models > /dev/null 2>&1; then
        return 0
    else
        return 1
    fi
}

check_llamacpp_installed() {
    if command -v llama-server &> /dev/null; then
        return 0
    else
        return 1
    fi
}

# ============================================================================
# 安装函数
# ============================================================================

install_omlx() {
    print_header "安装 OMLX"

    log_info "OMMX 需要从官网手动下载安装"
    log_info "请访问: https://omlx.ai"
    echo ""

    log_warning "是否自动打开下载页面？[y/N]"
    read -r response

    if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
        if command -v open &> /dev/null; then
            open "https://omlx.ai"
        else
            log_info "请手动访问: https://omlx.ai"
        fi
    fi

    echo ""
    log_info "安装完成后，请运行以下命令启动 OMLX 服务:"
    log_info "  1. 打开 OMLX 应用"
    log_info "  2. 下载模型（推荐: Qwen3.5-9B-mlx-lm-mxfp4）"
    log_info "  3. 启动服务器"
    log_info "  4. 运行此脚本配置 Hermes"
    echo ""
}

install_llamacpp() {
    print_header "安装 llama.cpp"

    if ! command -v brew &> /dev/null; then
        log_error "Homebrew 未安装"
        log_info "请先安装 Homebrew: /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
        exit 1
    fi

    log_step "安装 llama.cpp..."
    brew install llama.cpp

    log_step "安装 huggingface-cli..."
    brew install huggingface-cli

    log_success "llama.cpp 安装完成！"

    echo ""
    log_info "下载模型（Qwen3.5-9B-Q4_K_M.gguf, ~5.3GB）..."
    log_warning "是否继续下载？[y/N]"
    read -r response

    if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
        mkdir -p ~/models
        log_step "下载模型中..."
        huggingface-cli download unsloth/Qwen3.5-9B-GGUF Qwen3.5-9B-Q4_K_M.gguf --local-dir ~/models

        log_success "模型下载完成！"
        log_info "模型位置: ~/models/Qwen3.5-9B-Q4_K_M.gguf"
    else
        log_info "跳过模型下载"
        log_info "您可以稍后运行: huggingface-cli download unsloth/Qwen3.5-9B-GGUF Qwen3.5-9B-Q4_K_M.gguf --local-dir ~/models"
    fi

    echo ""
    log_info "启动 llama.cpp 服务器:"
    log_info "llama-server -m ~/models/Qwen3.5-9B-Q4_K_M.gguf -ngl 99 -c 131072 -np 1 -fa on --cache-type-k q4_0 --cache-type-v q4_0 --host 0.0.0.0"
}

# ============================================================================
# 配置函数
# ============================================================================

configure_hermes_omlx() {
    print_header "配置 Hermes Agent 使用 OMLX"

    local base_url="http://127.0.0.1:8000"
    local model_name=""

    log_step "获取可用模型列表..."
    local models=$(curl -s "$base_url/v1/models" 2>&1)

    if echo "$models" | jq -e '.data' > /dev/null 2>&1; then
        log_info "可用模型:"
        echo "$models" | jq -r '.data[].id' | nl -w2 -s'. '

        echo ""
        log_info "请输入模型名称（从上面列表选择）:"
        read -r model_name

        if [ -z "$model_name" ]; then
            log_error "模型名称不能为空"
            exit 1
        fi
    else
        log_warning "无法获取模型列表"
        log_info "请手动输入模型名称（例如: Qwen3.5-9B-mlx-lm-mxfp4）:"
        read -r model_name

        if [ -z "$model_name" ]; then
            log_error "模型名称不能为空"
            exit 1
        fi
    fi

    log_step "配置 Hermes..."

    # 更新 .env 文件
    local env_file="$HOME/.hermes/hermes-agent/.env"
    if [ -f "$env_file" ]; then
        cp "$env_file" "${env_file}.backup.$(date +%Y%m%d_%H%M%S)"

        cat >> "$env_file" << EOF

# OMLX 本地模型配置
HERMES_OMLX_BASE_URL=$base_url
HERMES_OMLX_MODEL=$model_name
EOF

        log_success "配置已添加到 $env_file"
    fi

    echo ""
    log_success "Hermes Agent 已配置为使用 OMLX 本地模型！"
    log_info "Base URL: $base_url"
    log_info "Model: $model_name"
    echo ""

    log_info "启动 Hermes Agent:"
    log_info "  hermes model"
    log_info "  然后选择 'Custom endpoint'"
}

configure_hermes_llamacpp() {
    print_header "配置 Hermes Agent 使用 llama.cpp"

    local base_url="http://localhost:8080"
    local model_name="Qwen3.5-9B-Q4_K_M.gguf"

    log_step "配置 Hermes..."

    # 更新 .env 文件
    local env_file="$HOME/.hermes/hermes-agent/.env"
    if [ -f "$env_file" ]; then
        cp "$env_file" "${env_file}.backup.$(date +%Y%m%d_%H%M%S)"

        cat >> "$env_file" << EOF

# llama.cpp 本地模型配置
HERMES_LLAMACPP_BASE_URL=$base_url
HERMES_LLAMACPP_MODEL=$model_name
EOF

        log_success "配置已添加到 $env_file"
    fi

    echo ""
    log_success "Hermes Agent 已配置为使用 llama.cpp 本地模型！"
    log_info "Base URL: $base_url"
    log_info "Model: $model_name"
    echo ""

    log_info "启动 llama.cpp 服务器:"
    log_info "llama-server -m ~/models/Qwen3.5-9B-Q4_K_M.gguf -ngl 99 -c 131072 -np 1 -fa on --cache-type-k q4_0 --cache-type-v q4_0 --host 0.0.0.0"
    echo ""

    log_info "启动 Hermes Agent:"
    log_info "  hermes model"
    log_info "  然后选择 'Custom endpoint'"
}

# ============================================================================
# 主菜单
# ============================================================================

show_menu() {
    print_header "本地 LLM 模型配置"

    echo "请选择配置方式:"
    echo ""
    echo "1) OMLX (GUI 应用，Token 生成快)"
    echo "2) llama.cpp (命令行，响应快，内存优化)"
    echo "3) 检查现有安装"
    echo "4) 退出"
    echo ""

    log_info "请输入选项 [1-4]:"
    read -r choice

    case $choice in
        1)
            if check_omlx_installed; then
                if check_omlx_running; then
                    configure_hermes_omlx
                else
                    log_warning "OMMX 已安装但服务未运行"
                    log_info "请先启动 OMLX 应用并启动服务器"
                fi
            else
                install_omlx
            fi
            ;;
        2)
            if check_llamacpp_installed; then
                configure_hermes_llamacpp
            else
                install_llamacpp
            fi
            ;;
        3)
            print_header "系统状态"

            echo "OMMX:"
            if check_omlx_installed; then
                log_success "✓ 已安装"
                if check_omlx_running; then
                    log_success "✓ 服务运行中"
                    curl -s http://127.0.0.1:8000/v1/models | jq -r '.data[].id' | sed 's/^/  - /'
                else
                    log_warning "✗ 服务未运行"
                fi
            else
                log_warning "✗ 未安装"
            fi

            echo ""
            echo "llama.cpp:"
            if command -v llama-server &> /dev/null; then
                log_success "✓ 已安装"
                llama-server --version 2>&1 | head -1
            else
                log_warning "✗ 未安装"
            fi

            echo ""
            echo "模型文件:"
            if [ -f ~/models/Qwen3.5-9B-Q4_K_M.gguf ]; then
                log_success "✓ Qwen3.5-9B-Q4_K_M.gguf ($(du -h ~/models/Qwen3.5-9B-Q4_K_M.gguf | cut -f1))"
            else
                log_warning "✗ 未找到 GGUF 模型"
            fi
            ;;
        4)
            log_info "退出"
            exit 0
            ;;
        *)
            log_error "无效选项"
            exit 1
            ;;
    esac
}

# ============================================================================
# 主函数
# ============================================================================

main() {
    clear

    echo ""
    echo -e "${CYAN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${NC}         ${GREEN}OMLX / llama.cpp 本地模型配置工具${NC}           ${CYAN}║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""

    show_menu
}

# 运行主函数
main "$@"
