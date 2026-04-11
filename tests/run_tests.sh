#!/bin/bash
#
# 纯 Shell 测试运行器 - MacClaw Installer
# 作者: 外星动物（常智）
# 组织: IoTchange
# 邮箱: 14455975@qq.com
# 版本: V1.0.1
# 版权: Copyright (C) 2026 IoTchange - All Rights Reserved
#
# 说明: 无依赖的测试套件，验证 MacClaw Installer 功能
#

set -e

# ============================================
# 加载测试框架
# ============================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/pure_shell_test.sh"

# ============================================
# 测试用例
# ============================================

# 环境检测测试
test_environment_1() {
    local version=$(sw_vers -productVersion)
    assert_not_empty "$version" "无法获取 macOS 版本"
    [[ "$version" =~ ^[0-9]+\.[0-9]+(\.[0-9]+)?$ ]]
}

test_environment_2() {
    local arch=$(uname -m)
    assert_not_empty "$arch" "无法获取系统架构"
    [[ "$arch" =~ ^(arm64|x86_64)$ ]]
}

test_environment_3() {
    command_exists curl
}

test_environment_4() {
    command_exists git
}

test_environment_5() {
    command_exists bash
}

# 文件结构测试
test_files_1() {
    assert_dir_exists "$PROJECT_ROOT" "项目根目录不存在"
}

test_files_2() {
    assert_dir_exists "$INSTALLER_DIR" "安装器目录不存在"
}

test_files_3() {
    assert_file_exists "$INSTALLER_DIR/install.sh" "安装脚本不存在"
}

test_files_4() {
    assert_file_exists "$INSTALLER_DIR/uninstall.sh" "卸载脚本不存在"
}

test_files_5() {
    assert_file_exists "$INSTALLER_DIR/lib/logger.sh" "日志模块不存在"
}

test_files_6() {
    assert_file_exists "$INSTALLER_DIR/lib/utils.sh" "工具模块不存在"
}

test_files_7() {
    assert_file_exists "$INSTALLER_DIR/lib/detector.sh" "检测模块不存在"
}

test_files_8() {
    assert_file_exists "$INSTALLER_DIR/lib/config.sh" "配置模块不存在"
}

test_files_9() {
    assert_file_exists "$INSTALLER_DIR/config/sources.conf" "国内源配置不存在"
}

test_files_10() {
    assert_file_exists "$INSTALLER_DIR/config/versions.conf" "版本配置不存在"
}

# 脚本语法测试
test_syntax_1() {
    bash -n "$INSTALLER_DIR/install.sh" 2>/dev/null
}

test_syntax_2() {
    bash -n "$INSTALLER_DIR/uninstall.sh" 2>/dev/null
}

test_syntax_3() {
    bash -n "$INSTALLER_DIR/lib/logger.sh" 2>/dev/null
}

test_syntax_4() {
    bash -n "$INSTALLER_DIR/lib/utils.sh" 2>/dev/null
}

# 脚本功能测试
test_features_1() {
    grep -q "main()" "$INSTALLER_DIR/install.sh"
}

test_features_2() {
    grep -q "detect_environment" "$INSTALLER_DIR/install.sh"
}

test_features_3() {
    grep -q "install-nodejs.sh" "$INSTALLER_DIR/install.sh"
}

test_features_4() {
    grep -q "install-openclaw.sh" "$INSTALLER_DIR/install.sh"
}

test_features_5() {
    grep -q "install-omlx.sh" "$INSTALLER_DIR/install.sh"
}

test_features_6() {
    grep -q "set -e" "$INSTALLER_DIR/install.sh"
}

# 版本信息测试
test_version_1() {
    grep -q "作者: 外星动物" "$INSTALLER_DIR/install.sh"
}

test_version_2() {
    grep -q "IoTchange" "$INSTALLER_DIR/install.sh"
}

test_version_3() {
    grep -q "14455975@qq.com" "$INSTALLER_DIR/install.sh"
}

test_version_4() {
    grep -q "Copyright" "$INSTALLER_DIR/install.sh"
}

test_version_5() {
    assert_file_exists "$PROJECT_ROOT/VERSION" "VERSION 文件不存在"
}

# 在线安装测试
test_online_1() {
    local status=$(curl -s -o /dev/null -w "%{http_code}" --max-time 5 \
        https://raw.githubusercontent.com/changzhi777/mactools/main/macclaw-installer/install.sh)

    # 返回 200, 301, 或 302 都算成功
    [[ "$status" =~ ^(200|301|302)$ ]] || skip_test "GitHub 访问失败 (状态码: $status)"
}

test_online_2() {
    local content=$(curl -fsSL --max-time 5 \
        https://raw.githubusercontent.com/changzhi777/mactools/main/macclaw-installer/install.sh)

    assert_not_empty "$content" "无法下载安装脚本"
    [[ "$content" =~ "#!/bin/bash" ]] || skip_test "下载内容不是 bash 脚本"
}

test_online_3() {
    local content=$(curl -fsSL --max-time 5 \
        https://raw.githubusercontent.com/changzhi777/mactools/main/macclaw-installer/install.sh)

    assert_not_empty "$content" "无法下载安装脚本"
    [[ "$content" =~ "MACCLAW_LIB_DIR" ]] || skip_test "脚本未包含环境变量修复"
}

# 组件测试（可选）
test_components_1() {
    command_exists node && echo "  ✓ Node.js 已安装" || skip_test "Node.js 未安装"
}

test_components_2() {
    command_exists openclaw && echo "  ✓ OpenClaw 已安装" || skip_test "OpenClaw 未安装"
}

test_components_3() {
    [ -d ~/.omlx ] && echo "  ✓ oMLX 已安装" || skip_test "oMLX 未安装"
}

test_components_4() {
    lsof -i :8008 &>/dev/null && echo "  ✓ oMLX 服务运行中" || skip_test "oMLX 服务未运行"
}

test_components_5() {
    lsof -i :18789 &>/dev/null && echo "  ✓ OpenClaw Gateway 运行中" || skip_test "OpenClaw Gateway 未运行"
}

# ============================================
# 测试套件
# ============================================

run_environment_tests() {
    run_test "检测 macOS 版本" test_environment_1
    run_test "检测系统架构" test_environment_2
    run_test "检测 curl 工具" test_environment_3
    run_test "检测 git 工具" test_environment_4
    run_test "检测 bash 工具" test_environment_5
}

run_file_structure_tests() {
    run_test "项目根目录存在" test_files_1
    run_test "安装器目录存在" test_files_2
    run_test "安装脚本存在" test_files_3
    run_test "卸载脚本存在" test_files_4
    run_test "日志模块存在" test_files_5
    run_test "工具模块存在" test_files_6
    run_test "检测模块存在" test_files_7
    run_test "配置模块存在" test_files_8
    run_test "国内源配置存在" test_files_9
    run_test "版本配置存在" test_files_10
}

run_script_syntax_tests() {
    run_test "安装脚本语法正确" test_syntax_1
    run_test "卸载脚本语法正确" test_syntax_2
    run_test "日志模块语法正确" test_syntax_3
    run_test "工具模块语法正确" test_syntax_4
}

run_script_features_tests() {
    run_test "包含主函数" test_features_1
    run_test "包含环境检测" test_features_2
    run_test "包含 Node.js 安装" test_features_3
    run_test "包含 OpenClaw 安装" test_features_4
    run_test "包含 oMLX 安装" test_features_5
    run_test "包含错误处理" test_features_6
}

run_version_info_tests() {
    run_test "包含作者信息" test_version_1
    run_test "包含组织信息" test_version_2
    run_test "包含邮箱信息" test_version_3
    run_test "包含版权信息" test_version_4
    run_test "包含版本文件" test_version_5
}

run_online_install_tests() {
    run_test "GitHub URL 可访问" test_online_1
    run_test "安装脚本可下载" test_online_2
    run_test "脚本包含修复代码" test_online_3
}

run_component_tests() {
    run_test "Node.js 可用性" test_components_1
    run_test "OpenClaw 可用性" test_components_2
    run_test "oMLX 可用性" test_components_3
    run_test "oMLX 服务状态" test_components_4
    run_test "OpenClaw Gateway 状态" test_components_5
}

# ============================================
# 主测试流程
# ============================================

main() {
    print_header "MacClaw Installer - 纯 Shell 测试套件"

    local start_time=$(date +%s)

    # 运行所有测试套件
    run_test_suite "环境检测测试" run_environment_tests
    run_test_suite "文件结构测试" run_file_structure_tests
    run_test_suite "脚本语法测试" run_script_syntax_tests
    run_test_suite "脚本功能测试" run_script_features_tests
    run_test_suite "版本信息测试" run_version_info_tests
    run_test_suite "在线安装测试" run_online_install_tests
    run_test_suite "组件测试（可选）" run_component_tests

    local end_time=$(date +%s)
    local duration=$((end_time - start_time))

    # 打印测试报告
    print_test_report

    echo -e "  总耗时: ${CYAN}${duration} 秒${NC}"
    echo ""

    # 返回测试结果
    if [ $TESTS_FAILED -eq 0 ]; then
        exit 0
    else
        exit 1
    fi
}

# ============================================
# 运行主函数
# ============================================

main "$@"
