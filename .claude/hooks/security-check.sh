#!/bin/bash
# 安全检查 Hook - PreToolUse
# 在 Write/Edit 操作前检查代码安全性
# 严重问题 → exit 2（阻止操作）
# 中等问题 → exit 0 + 警告（不阻止）

# 从 stdin 读取 JSON 输入
input=$(cat)

# 提取文件路径和内容
file_path=$(echo "$input" | jq -r '.tool_input.file_path // empty')
content=$(echo "$input" | jq -r '.tool_input.content // .tool_input.new_string // empty')

# 如果没有内容，直接退出
if [ -z "$content" ]; then
  exit 0
fi

# 跳过非代码文件（配置文件、文档等）
# 注意：不再跳过 .sh 文件，shell 脚本也需要安全检查
if echo "$file_path" | grep -qE '\.(md|txt|json|yaml|yml|toml|env|gitignore|dockerignore)$'; then
  exit 0
fi

# 预处理：去除注释行和字符串内容，减少误报
# 去除单行注释（// 和 #）
cleaned=$(echo "$content" | sed -E 's|//.*$||' | sed -E 's|^\s*#.*$||')
# 去除多行注释 /* ... */
cleaned=$(echo "$cleaned" | sed -E ':a;N;$!ba;s|/\*[^*]*\*+([^/*][^*]*\*+)*/||g')

# 检查函数 - 严重级别
check_critical() {
  local pattern="$1"
  local description="$2"
  local target="${3:-$cleaned}"

  if echo "$target" | grep -qE "$pattern"; then
    echo "🔴 [严重] $description"
    return 1
  fi
  return 0
}

# 检查函数 - 中等级别
check_warning() {
  local pattern="$1"
  local description="$2"
  local target="${3:-$cleaned}"

  if echo "$target" | grep -qE "$pattern"; then
    echo "🟡 [中等] $description"
    return 1
  fi
  return 0
}

critical_issues=0
warning_issues=0

# ==================== 🔴 严重问题 ====================
# 这些问题会阻止操作（exit 2）

check_critical "eval\s*\(" "检测到 eval() 使用 - 可能导致代码注入" || critical_issues=$((critical_issues + 1))
check_critical "new\s+Function\s*\(" "检测到 new Function() 使用 - 可能导致代码注入" || critical_issues=$((critical_issues + 1))
check_critical "innerHTML\s*=" "检测到 innerHTML 赋值 - 可能导致 XSS" || critical_issues=$((critical_issues + 1))
check_critical "dangerouslySetInnerHTML" "检测到 dangerouslySetInnerHTML - 可能导致 XSS（除非经过 sanitize）" || critical_issues=$((critical_issues + 1))
check_critical "os\.system\s*\(" "检测到 os.system() - 可能导致命令注入" || critical_issues=$((critical_issues + 1))
check_critical "child_process\.exec\s*\(" "检测到 child_process.exec() - 可能导致命令注入（请使用 spawn + 参数数组）" || critical_issues=$((critical_issues + 1))
check_critical "__proto__\s*=" "检测到原型链污染风险" || critical_issues=$((critical_issues + 1))
check_critical "constructor\s*\[" "检测到原型链污染风险" || critical_issues=$((critical_issues + 1))

# ==================== 🟡 中等问题 ====================
# 这些问题只打印警告，不阻止操作

check_warning "(password|secret|api_key|apikey)\s*=\s*['\"][^'\"]{4,}['\"]" "检测到可能的硬编码密钥/密码（请使用环境变量）" || warning_issues=$((warning_issues + 1))

# SQL 拼接检测：覆盖 SELECT/INSERT/UPDATE/DELETE
check_warning "(SELECT|INSERT|UPDATE|DELETE)\s+.*\s+(FROM|INTO|SET|WHERE)\s+.*\+\s*" "检测到可能的 SQL 字符串拼接（请使用参数化查询）" || warning_issues=$((warning_issues + 1))
# 模板字符串 SQL 拼接
check_warning "(SELECT|INSERT|UPDATE|DELETE)\s+.*\`" "检测到模板字符串中的 SQL（请使用参数化查询）" || warning_issues=$((warning_issues + 1))

check_warning "\.exec\s*\(\s*\`" "检测到模板字符串中的 exec() - 可能导致命令注入" || warning_issues=$((warning_issues + 1))
check_warning "JSON\.parse\s*\([^)]*\)" "JSON.parse 接受外部输入时需 try-catch 包裹" || warning_issues=$((warning_issues + 1))

# ==================== 输出结果 ====================

if [ $critical_issues -gt 0 ]; then
  echo ""
  echo "安全检查发现 $critical_issues 个严重问题，操作已被阻止。"
  echo "请修复上述 🔴 严重问题后重试。"
  exit 2
fi

if [ $warning_issues -gt 0 ]; then
  echo ""
  echo "安全检查发现 $warning_issues 个中等问题，请审查。"
fi

exit 0
