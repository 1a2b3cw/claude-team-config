#!/bin/bash
# Bash 命令安全检查 Hook - PreToolUse
# 检查 Bash 工具执行的危险命令

input=$(cat)
command=$(echo "$input" | jq -r '.tool_input.command // empty')

if [ -z "$command" ]; then
  exit 0
fi

issues=0

# 🔴 严重：不可逆破坏
if echo "$command" | grep -qE 'rm\s+(-rf?|--recursive)\s+(/|~|\$HOME|\*)'; then
  echo "🔴 [严重] 检测到递归删除根目录/主目录 - 拒绝执行"
  exit 2
fi

if echo "$command" | grep -qE 'git\s+push\s+.*--force'; then
  echo "🔴 [严重] 检测到 force push - 请确认目标分支"
  exit 2
fi

if echo "$command" | grep -qE 'git\s+reset\s+--hard'; then
  echo "🔴 [严重] 检测到 git reset --hard - 将丢失未提交的更改"
  exit 2
fi

if echo "$command" | grep -qE 'git\s+clean\s+-f'; then
  echo "🔴 [严重] 检测到 git clean -f - 将删除未跟踪文件"
  exit 2
fi

# 🟡 中等：需要审查
if echo "$command" | grep -qE 'curl\s+.*\|\s*(bash|sh|zsh)'; then
  echo "🟡 [中等] 检测到 curl | bash 管道 - 可能执行远程脚本"
fi

if echo "$command" | grep -qE 'chmod\s+777'; then
  echo "🟡 [中等] 检测到 chmod 777 - 过于宽松的权限"
fi

if echo "$command" | grep -qE 'docker\s+run\s+.*--privileged'; then
  echo "🟡 [中等] 检测到 Docker 特权模式 - 绕过安全隔离"
fi

if echo "$command" | grep -qE 'eval\s+'; then
  echo "🟡 [中等] 检测到 eval 执行命令"
fi

if echo "$command" | grep -qE '(GITHUB_TOKEN|GH_TOKEN|NPM_TOKEN|AWS_SECRET|DATABASE_URL)\s*='; then
  echo "🟡 [中等] 检测到敏感环境变量赋值"
fi

exit 0
