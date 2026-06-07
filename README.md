# AI 全栈开发团队

基于 Claude Code 的 AI 协作开发团队配置，专为 Web 全栈开发设计。

> v2.0.0 | 2026-06-07

## 一句话

> 你负责想清楚"要什么"，AI 团队负责"怎么做"。

## 包含什么

| 组件 | 数量 | 说明 |
|------|------|------|
| **Agent** | 5 个 | Architect-Planner、Builder、Reviewer、Researcher、DevOps |
| **Skill** | 13 个 | 前端、后端、测试、安全、性能、UI 设计、TypeScript 进阶等 |
| **MCP 服务器** | 5 个 | GitHub、Playwright、Context7、SQLite、PostgreSQL |
| **Slash Command** | 4 个 | `/dev`、`/review-all`、`/ship`、`/standup` |
| **Rules** | 5 个 | TypeScript、React、Node.js、测试、Git |
| **Hook** | 3 个 | 代码安全检查、Bash 命令检查、任务追踪 |

## 快速开始

### 环境要求

- **Node.js** 18+
- **pnpm** 8+（或 npm）
- **Git** 2.30+
- **Claude Code** 最新版

### 安装

```bash
# 克隆仓库
git clone https://github.com/你的用户名/claude-team-config.git

# 复制配置到你的项目
cp -r claude-team-config/.claude 你的项目/.claude
cp claude-team-config/.gitignore 你的项目/.gitignore
mkdir -p 你的项目/data

# 进入项目，启动 Claude Code
cd 你的项目
claude
```

或使用安装脚本：

```bash
# Windows
claude-team-config\install.bat 你的项目路径

# Linux / Mac
bash claude-team-config/install.sh 你的项目路径
```

### 验证

在 Claude Code 中输入：

```
/mcp
```

应该看到 5 个 MCP 服务器。

## 怎么用

### 4 个核心命令

| 命令 | 什么时候用 | 例子 |
|------|-----------|------|
| `/dev` | 要写代码 | `/dev 做一个用户登录功能` |
| `/review-all` | 代码写完了想检查 | `/review-all src/features/auth/` |
| `/ship` | 准备上线 | `/ship` |
| `/standup` | 看进度 | `/standup` |

### 工作流

```
你想做个功能
    ↓
输入：/dev 做一个用户注册登录功能
    ↓
AI 自动判断任务复杂度（S/M/L/XL）
    ↓
L/XL 级：先出方案给你确认 → 确认后迭代开发 → 自动审查 → 完成
S/M 级：直接写代码 → 自动审查 → 完成
```

### 不用斜杠命令也行

```
帮我查一下 React 19 的新特性
打开 http://localhost:3000 看看效果
帮我解释一下 src/auth/login.ts 的逻辑
```

更多用法见 [BEST-PRACTICES.md](BEST-PRACTICES.md)。

## 配置文件结构

```
.claude/
├── CLAUDE.md              # 核心指令（工作流、技术栈、规范）
├── settings.json          # 权限配置、Hook 配置
├── .mcp.json              # MCP 服务器配置
├── agents/                # 5 个 Agent 角色定义
│   ├── architect-planner.md
│   ├── builder.md
│   ├── reviewer.md
│   ├── researcher.md
│   └── devops.md
├── skills/                # 13 个 Skill 技能定义
│   ├── frontend/
│   ├── api-design/
│   ├── testing/
│   ├── code-review/
│   └── ...
├── commands/              # 4 个斜杠命令
│   ├── dev.md
│   ├── review-all.md
│   ├── ship.md
│   └── standup.md
├── rules/                 # 5 个编码规范
│   ├── typescript.md
│   ├── react.md
│   ├── node.md
│   ├── testing.md
│   └── git.md
└── hooks/                 # 3 个安全钩子
    ├── security-check.sh
    └── bash-check.sh
```

## v2.0 核心变化

| 维度 | v1.x | v2.0 |
|------|------|------|
| 工作流 | 串行瀑布流 | 并行迭代模型 |
| 任务分级 | 一刀切全流程 | S/M/L/XL 四级按需 |
| Agent | 7 个 | 5 个（合并精简） |
| Skill | 18 个 | 13 个（合并精简） |
| 安全检查 | 仅 Write/Edit | + Bash 命令检查 |
| MCP 服务器 | 6 个 | 5 个（去重 Puppeteer） |
| 无障碍 | 无 | 审查维度 + 规则 |

## 可选配置

### GitHub MCP（管理仓库/PR/Issue）

```bash
# Windows PowerShell
$env:GITHUB_PERSONAL_ACCESS_TOKEN="ghp_你的token"

# 或在 .claude/settings.json 的 env 中添加
```

Token 获取：GitHub → Settings → Developer settings → Personal access tokens → 需要 `repo`、`read:org` 权限

### PostgreSQL MCP（生产数据库）

编辑 `.claude/.mcp.json`，修改 postgres 连接字符串：

```json
"args": ["-y", "@modelcontextprotocol/server-postgres", "postgresql://用户名:密码@localhost:5432/数据库名"]
```

### SQLite MCP

```bash
pip install uv
```

## 自定义

### 添加新 Agent

在 `.claude/agents/` 下创建 `.md` 文件，参考已有格式。

### 添加新 Skill

在 `.claude/skills/` 下创建目录和 `SKILL.md`：

```markdown
---
name: my-skill
description: 技能描述
---

# 技能内容
```

### 添加新命令

在 `.claude/commands/` 下创建 `.md` 文件，文件名即命令名。

### 禁用 MCP 服务器

编辑 `.claude/.mcp.json`，删除对应配置。

## 文档

- [USAGE.md](USAGE.md) - 完整使用文档
- [BEST-PRACTICES.md](BEST-PRACTICES.md) - 最佳实践指南（面向初学者）

## License

MIT
