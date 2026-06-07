#!/bin/bash
# 安全检查 Hook - PreToolUse
# 在 Write/Edit 操作前检查代码安全性

# 从 stdin 读取 JSON 输入
input=$(cat)

# 提取文件路径和内容
file_path=$(echo "$input" | jq -r '.tool_input.file_path // empty')
content=$(echo "$input" | jq -r '.tool_input.content // .tool_input.new_string // empty')

# 如果没有内容，直接退出
if [ -z "$content" ]; then
  exit 0
fi

# 跳过非代码文件
if echo "$file_path" | grep -qE '\.(md|txt|json|yaml|yml|toml|env|gitignore|dockerignore)$'; then
  exit 0
fi

# 预处理：去除注释行和字符串内容，减少误报
# 去除单行注释（// 和 #）
cleaned=$(echo "$content" | sed -E 's|//.*$||' | sed -E 's|^\s*#.*$||')
# 去除多行注释 /* ... */
cleaned=$(echo "$cleaned" | sed -E ':a;N;$!ba;s|/\*[^*]*\*+([^/*][^*]*\*+)*/||g')

# 检查函数
check_pattern() {
  local pattern="$1"
  local description="$2"
  local severity="$3"
  local target="${4:-$cleaned}"

  if echo "$target" | grep -qE "$pattern"; then
    echo "⚠️ [$severity] $description"
    return 1
  fi
  return 0
}

issues=0

# 🔴 严重问题（检查清理后的内容）
check_pattern "eval\s*\(" "检测到 eval() 使用 - 可能导致代码注入" "严重" || issues=$((issues + 1))
check_pattern "new\s+Function\s*\(" "检测到 new Function() 使用 - 可能导致代码注入" "严重" || issues=$((issues + 1))
check_pattern "innerHTML\s*=" "检测到 innerHTML 赋值 - 可能导致 XSS" "严重" || issues=$((issues + 1))
check_pattern "dangerouslySetInnerHTML" "检测到 dangerouslySetInnerHTML - 可能导致 XSS" "严重" || issues=$((issues + 1))
check_pattern "os\.system\s*\(" "检测到 os.system() - 可能导致命令注入" "严重" || issues=$((issues + 1))
check_pattern "child_process\.exec\s*\(" "检测到 child_process.exec() - 可能导致命令注入" "严重" || issues=$((issues + 1))
check_pattern "__proto__\s*=" "检测到原型链污染风险" "严重" || issues=$((issues + 1))
check_pattern "constructor\s*\[" "检测到原型链污染风险" "严重" || issues=$((issues + 1))

# 🟡 中等问题
check_pattern "(password|secret|api_key|apikey)\s*=\s*['\"][^'\"]{8,}['\"]" "检测到可能的硬编码密钥/密码（8+字符）" "中等" || issues=$((issues + 1))
check_pattern "SELECT\s+.*\s+FROM\s+.*\s+WHERE\s+.*\+\s*" "检测到可能的 SQL 字符串拼接" "中等" || issues=$((issues + 1))
check_pattern "\.exec\s*\(\s*\`" "检测到模板字符串中的 exec() - 可能导致命令注入" "中等" || issues=$((issues + 1))
check_pattern "JSON\.parse\s*\([^)]*\)" "JSON.parse 接受外部输入时需 try-catch 包裹" "中等" || issues=$((issues + 1))

# 输出结果
if [ $issues -gt 0 ]; then
  echo "安全检查发现 $issues 个问题，请审查后再继续。"
fi

# 始终返回 0（警告但不阻止）
exit 0
