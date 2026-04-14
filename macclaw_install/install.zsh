#!/usr/bin/env zsh
# ==============================================================================
# MacClaw Install - 简化版安装脚本
# ==============================================================================
#
# 功能说明：
#   - 半交互式安装（oMLX 需要手动安装）
#   - 自动检测并安装缺失组件
#   - 修复了原脚本的PATH和交互问题
#   - 清晰的进度输出
#
# 使用方法：
#   ./install.zsh
#
# ==============================================================================

set -e  # 遇到错误立即退出

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# 日志文件
LOG_FILE="${HOME}/macclaw_simple_install.log"

# ==============================================================================
# 日志函数
# ==============================================================================

log_info() {
    echo -e "${BLUE}[INFO]${NC} $*" | tee -a "${LOG_FILE}"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $*" | tee -a "${LOG_FILE}"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $*" | tee -a "${LOG_FILE}"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $*" | tee -a "${LOG_FILE}"
}

log_section() {
    echo "" | tee -a "${LOG_FILE}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}" | tee -a "${LOG_FILE}"
    echo -e "${CYAN}  $*${NC}" | tee -a "${LOG_FILE}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}" | tee -a "${LOG_FILE}"
    echo "" | tee -a "${LOG_FILE}"
}

# ==============================================================================
# 系统检测
# ==============================================================================

detect_system() {
    log_section "系统检测"

    # macOS 版本
    local macos_version=$(sw_vers -productVersion)
    log_info "macOS 版本: ${macos_version}"

    # CPU 架构
    local arch=$(uname -m)
    log_info "CPU 架构: ${arch}"

    # CPU 型号
    local cpu=$(sysctl -n machdep.cpu.brand_string)
    log_info "CPU 型号: ${cpu}"

    # 内存大小
    local memory_gb=$(( $(sysctl -n hw.memsize) / 1024 / 1024 / 1024 ))
    log_info "内存大小: ${memory_gb}GB"

    # 磁盘空间
    local disk_free=$(/bin/df -h / | /usr/bin/tail -1 | /usr/bin/awk '{print $4}')
    log_info "磁盘可用空间: ${disk_free}"

    echo ""
}

# ==============================================================================
# 组件检测
# ==============================================================================

check_homebrew() {
    if command -v brew >/dev/null 2>&1; then
        local version=$(brew --version | head -1)
        log_success "Homebrew 已安装: ${version}"
        return 0
    else
        log_info "Homebrew 未安装"
        return 1
    fi
}

check_nodejs() {
    if command -v node >/dev/null 2>&1; then
        local version=$(node --version)
        log_success "Node.js 已安装: ${version}"
        return 0
    else
        log_info "Node.js 未安装"
        return 1
    fi
}

check_npm() {
    if command -v npm >/dev/null 2>&1; then
        local version=$(npm --version)
        log_success "npm 已安装: ${version}"
        return 0
    else
        log_info "npm 未安装"
        return 1
    fi
}

check_openclaw() {
    if command -v openclaw >/dev/null 2>&1; then
        local version=$(openclaw --version 2>&1 | head -1)
        log_success "OpenClaw 已安装: ${version}"
        return 0
    else
        log_info "OpenClaw 未安装"
        return 1
    fi
}

check_omlx() {
    if [[ -d "/Applications/oMLX.app" ]]; then
        log_success "oMLX 应用已安装"
        return 0
    else
        log_info "oMLX 应用未安装"
        return 1
    fi
}

detect_components() {
    log_section "组件检测"

    check_homebrew || true
    check_nodejs || true
    check_npm || true
    check_openclaw || true
    check_omlx || true

    echo ""
}

# ==============================================================================
# 安装 Homebrew
# ==============================================================================

install_homebrew() {
    log_section "安装 Homebrew"

    if check_homebrew; then
        log_info "Homebrew 已安装，跳过"
        return 0
    fi

    log_warning "Homebrew 安装需要管理员权限和交互式终端"
    log_warning "当前环境不支持，跳过 Homebrew 安装"
    echo ""
    echo "💡 如果您需要安装 Homebrew，请在终端中手动运行："
    echo "   /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
    echo ""
    log_info "继续安装其他组件..."
    return 0
}

# ==============================================================================
# 安装 Node.js
# ==============================================================================

install_nodejs() {
    log_section "安装 Node.js"

    if check_nodejs; then
        log_info "Node.js 已安装，跳过"
        return 0
    fi

    log_info "Node.js 未安装，但脚本暂不支持自动安装"
    log_warning "请手动安装 Node.js: https://nodejs.org/"
    return 0
}

# ==============================================================================
# 安装 OpenClaw
# ==============================================================================

install_openclaw() {
    log_section "安装 OpenClaw"

    if check_openclaw; then
        log_info "OpenClaw 已安装，跳过"
        return 0
    fi

    if ! check_npm; then
        log_error "npm 未安装，无法安装 OpenClaw"
        return 1
    fi

    log_info "开始安装 OpenClaw..."

    # 使用淘宝镜像
    local npm_registry="https://registry.npmmirror.com"

    if npm install -g @iotchange/openclaw-cli --registry="${npm_registry}" 2>&1 | tee -a "${LOG_FILE}"; then
        log_success "OpenClaw 安装成功"
    else
        log_error "OpenClaw 安装失败"
        return 1
    fi

    # 验证安装
    if command -v openclaw >/dev/null 2>&1; then
        local version=$(openclaw --version 2>&1 | head -1)
        log_success "OpenClaw 验证成功: ${version}"
        return 0
    else
        log_error "OpenClaw 安装验证失败"
        return 1
    fi
}

# ==============================================================================
# 安装 omlx
# ==============================================================================

install_omlx() {
    log_section "安装 oMLX"

    # 检查 oMLX 应用是否已安装
    if [[ -d "/Applications/oMLX.app" ]]; then
        log_success "oMLX 应用已安装"
        return 0
    fi

    log_info "oMLX 是一个 macOS 应用程序，需要手动安装"

    # 检测 macOS 版本
    local macos_version=$(sw_vers -productVersion)
    local major_version=$(echo "${macos_version}" | cut -d. -f1)

    # 确定 DMG URL
    local dmg_url=""
    local dmg_filename=""

    if [[ ${major_version} -ge 26 ]]; then
        dmg_url="https://github.com/jundot/omlx/releases/download/v0.3.5.dev1/oMLX-0.3.5.dev1-macos26-tahoe.dmg"
        dmg_filename="oMLX-0.3.5.dev1-macos26-tahoe.dmg"
    elif [[ ${major_version} -ge 15 ]]; then
        dmg_url="https://github.com/jundot/omlx/releases/download/v0.3.5.dev1/oMLX-0.3.5.dev1-macos15-sequoia.dmg"
        dmg_filename="oMLX-0.3.5.dev1-macos15-sequoia.dmg"
    else
        log_warning "不支持的 macOS 版本: ${macos_version}"
        log_info "请访问 https://github.com/jundot/omlx/releases 下载适合的版本"
        return 0
    fi

    echo ""
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}  oMLX 手动安装向导${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo -e "${WHITE}检测到的 macOS 版本：${NC} ${macos_version}"
    echo -e "${WHITE}将下载的版本：${NC} ${dmg_filename}"
    echo ""

    # 询问用户是否自动下载并打开
    echo -e "${YELLOW}是否自动下载并打开 oMLX 安装包？${NC}"
    echo "  1) 是 - 自动下载并打开 DMG 文件"
    echo "  2) 否 - 跳过 oMLX 安装"
    echo "  3) 重新检测 - 检查是否已安装"
    echo ""
    echo -n "请选择 [1-3]: "

    read choice
    echo ""

    case "${choice}" in
        1|"yes"|"y"|"Y"|"是")
            log_info "正在下载 oMLX..."

            # 下载 DMG
            if curl -L -o /tmp/oMLX.dmg "${dmg_url}" 2>&1 | tee -a "${LOG_FILE}"; then
                log_success "下载完成: /tmp/oMLX.dmg"

                # 显示文件信息
                local file_size=$(ls -lh /tmp/oMLX.dmg | awk '{print $5}')
                log_info "文件大小: ${file_size}"

                # 打开 DMG
                log_info "正在打开安装包..."
                open /tmp/oMLX.dmg

                echo ""
                echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
                echo -e "${CYAN}  安装说明${NC}"
                echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
                echo ""
                echo -e "${WHITE}📱 安装步骤：${NC}"
                echo "  1. 在打开的 Finder 窗口中，找到 oMLX.app"
                echo "  2. 将 oMLX.app 拖拽到 Applications 文件夹"
                echo "  3. 等待复制完成"
                echo "  4. 返回此终端，按 Enter 继续"
                echo ""
                echo -e "${YELLOW}⏳  脚本已暂停，等待您完成安装...${NC}"
                echo ""

                # 等待用户确认
                echo -n "安装完成后，请按 Enter 键继续..."
                read

                echo ""
                log_info "检测 oMLX 安装状态..."

                # 检测安装
                if [[ -d "/Applications/oMLX.app" ]]; then
                    log_success "✅ oMLX 安装成功！"

                    # 清理 DMG 文件
                    log_info "清理下载的 DMG 文件..."
                    rm -f /tmp/oMLX.dmg
                    log_success "清理完成"

                    return 0
                else
                    log_warning "⚠️  未检测到 oMLX 应用"
                    log_warning "请确认安装步骤是否正确"
                    log_info "您可以稍后手动安装，OpenClaw 仍可正常使用"

                    # 询问是否重试
                    echo ""
                    echo -n "是否重新检测？[y/N]: "
                    read retry_choice
                    if [[ "${retry_choice}" =~ ^[yY] ]]; then
                        install_omlx
                        return $?
                    fi

                    return 0
                fi
            else
                log_error "下载失败"
                log_info "请手动下载: ${dmg_url}"
                return 1
            fi
            ;;

        2|"no"|"n"|"N"|"否")
            log_info "跳过 oMLX 安装"
            log_info "您可以稍后手动安装，OpenClaw 仍可正常使用"
            log_info "下载链接: ${dmg_url}"
            return 0
            ;;

        3|"重新检测"|"r"|"R")
            log_info "重新检测 oMLX 安装状态..."
            if [[ -d "/Applications/oMLX.app" ]]; then
                log_success "✅ oMLX 已安装！"
                return 0
            else
                log_warning "⚠️  未检测到 oMLX 应用"
                log_info "重新开始安装流程..."
                install_omlx
                return $?
            fi
            ;;

        *)
            log_warning "无效选择，跳过 oMLX 安装"
            return 0
            ;;
    esac
}

# ==============================================================================
# 测试 AI 模型
# ==============================================================================

test_model() {
    log_section "测试 AI 模型"

    if ! check_openclaw; then
        log_warning "OpenClaw 未安装，跳过模型测试"
        return 0
    fi

    log_info "测试 OpenClaw 推理功能..."
    log_info "使用模型: omlx/gemma-4-e4b-it-4bit"

    # 测试推理
    if openclaw infer model run --model omlx/gemma-4-e4b-it-4bit --prompt "你好" 2>&1 | tee -a "${LOG_FILE}"; then
        log_success "模型测试成功！"
    else
        log_warning "模型测试失败，但这不影响后续使用"
        log_info "您可以稍后手动测试: openclaw infer model run --model omlx/gemma-4-e4b-it-4bit --prompt '你好'"
    fi
}

# ==============================================================================
# 主函数
# ==============================================================================

main() {
    # 初始化日志
    {
        echo "=============================================================================="
        echo "  MacClaw Install - 简化版安装日志"
        echo "=============================================================================="
        echo "  开始时间: $(date '+%Y-%m-%d %H:%M:%S')"
        echo "  用户: ${USER}"
        echo "  主机: $(hostname)"
        echo "=============================================================================="
        echo ""
    } > "${LOG_FILE}"

    # 显示标题
    clear
    echo -e "${CYAN}"
    echo "╔════════════════════════════════════════════════════════════╗"
    echo "║                                                            ║"
    echo "║       🦞 MacClaw Install - 简化版安装工具                 ║"
    echo "║                                                            ║"
    echo "║       一键安装 OpenClaw + omlx 本地 AI 环境                ║"
    echo "║                                                            ║"
    echo "╚════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    echo ""

    # 系统检测
    detect_system

    # 组件检测
    detect_components

    # 安装组件
    install_homebrew
    install_nodejs
    install_openclaw
    install_omlx
    test_model

    # 最终检测
    log_section "安装完成"
    detect_components

    # 显示总结
    echo ""
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}  🎉 安装完成！${NC}"
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo "📝 日志文件: ${LOG_FILE}"
    echo ""
    echo "🚀 快速开始："
    echo ""
    echo "  # 测试推理（推荐）"
    echo "  openclaw infer model run --model omlx/gemma-4-e4b-it-4bit --prompt '你好'"
    echo ""
    echo "  # 运行一个 Agent 交互"
    echo "  openclaw agent"
    echo ""
    echo "  # 查看所有命令"
    echo "  openclaw --help"
    echo ""
    echo "  # 查看模型列表"
    echo "  openclaw infer model list"
    echo ""
    echo "  # 配置 OpenClaw"
    echo "  openclaw configure"
    echo ""
}

# 运行主函数
main
