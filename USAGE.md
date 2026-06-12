# AI 全栈开发团队 使用文档

> v2.0.0 | 2026-06-07

## 目录

- [项目简介](#项目简介)
- [环境要求](#环境要求)
- [快速开始](#快速开始)
- [在其他项目中使用](#在其他项目中使用)
- [MCP 服务器配置](#mcp-服务器配置)
- [Agent 团队](#agent-团队)
- [Skill 技能](#skill-技能)
- [Slash Command 命令](#slash-command-命令)
- [Rules 规则](#rules-规则)
- [Hooks 钩子](#hooks-钩子)
- [典型工作流](#典型工作流)
- [常见问题](#常见问题)

---

## 项目简介

基于 Claude Code 的 AI 协作开发团队配置，专为 Web 全栈开发设计。

- **6 个 Agent**：Architect-Planner、Builder、Designer、Reviewer、Researcher、DevOps
- **14 个 Skill**：前端、后端、测试、安全、性能、UI 设计、UI 原型、TypeScript 进阶等
- **5 个 MCP 服务器**：GitHub、Playwright、Context7、SQLite、PostgreSQL
- **4 个 Slash Command**：`/dev`、`/review-all`、`/ship`、`/standup`
- **6 个 Rules**：TypeScript、React、Node.js、测试、Git、设计
- **2 个 Hook**：代码安全检查（Write/Edit 时）、Bash 命令检查（执行命令时）

> v2.0 变化详见 [CHANGELOG.md](CHANGELOG.md)。

---

## 环境要求

### 必需

| 工具 | 版本 | 用途 |
|------|------|------|
| **Node.js** | 18+ | MCP 服务器运行环境 |
| **pnpm** | 8+ | 包管理（推荐）或 npm |
| **Git** | 2.30+ | 版本控制 |
| **Claude Code** | 最新版 | AI 开发工具 |

### 可选（按需安装）

| 工具 | 用途 |
|------|------|
| **Docker** | 容器化部署 |
| **PostgreSQL** | 生产数据库 |
| **uvx** | 运行 SQLite MCP |

### 安装命令

```bash
# Node.js (推荐使用 nvm)
nvm install 20
nvm use 20

# pnpm
npm install -g pnpm

# uvx (Python 包运行器，用于 SQLite MCP)
pip install uv

# Claude Code
npm install -g @anthropic-ai/claude-code
```

---

## 快速开始

### 1. 克隆/进入项目

```bash
cd D:\CD\MY1
```

### 2. 初始化 Git（已完成）

```bash
git init
```

### 3. 配置 GitHub Token（可选，用于 GitHub MCP）

```bash
# Windows PowerShell
$env:GITHUB_PERSONAL_ACCESS_TOKEN="ghp_你的token"

# 或在 .claude/settings.json 的 env 中添加
```

GitHub Token 获取方式：GitHub → Settings → Developer settings → Personal access tokens → Generate new token

需要的权限：`repo`、`read:org`、`read:user`

### 4. 配置 PostgreSQL（可选）

编辑 `.claude/.mcp.json`，修改 `postgres` 的连接字符串：

```json
"args": ["-y", "@modelcontextprotocol/server-postgres", "postgresql://你的用户名:你的密码@localhost:5432/你的数据库名"]
```

### 5. 启动 Claude Code

```bash
claude
```

### 6. 验证配置

在 Claude Code 中输入：

```
/mcp
```

应该看到 5 个 MCP 服务器（github、playwright、context7、sqlite、postgres）。

---

## 在其他项目中使用

本团队配置可以复用到任意项目中，有 2 种方式：

### 方式 1：手动复制（推荐）

```bash
# 复制整个 .claude 目录和 .gitignore
cp -r D:\CD\MY1\.claude D:\你的新项目\.claude
cp D:\CD\MY1\.gitignore D:\你的新项目\.gitignore
mkdir -p D:\你的新项目\data
```

Windows PowerShell：

```powershell
Copy-Item -Recurse D:\CD\MY1\.claude D:\你的新项目\.claude
Copy-Item D:\CD\MY1\.gitignore D:\你的新项目\.gitignore
New-Item -ItemType Directory -Path D:\你的新项目\data -Force
```

安装后目录结构：

```
你的新项目/
├── .claude/              # AI 团队配置（已安装）
│   ├── CLAUDE.md
│   ├── settings.json
│   ├── .mcp.json
│   ├── agents/
│   ├── skills/
│   ├── commands/
│   ├── rules/
│   └── hooks/
├── .gitignore
├── data/                 # SQLite 数据库目录
└── src/                  # 你的项目代码
```

### 方式 2：Git 子模块（适合团队协作）

把团队配置做成独立仓库，各项目通过 submodule 引用，统一更新。

```bash
# 第一步：创建团队配置仓库
cd D:\CD\MY1
git add .claude/ .gitignore USAGE.md
git commit -m "feat: AI team config v2.0"
git remote add origin https://github.com/你的用户名/claude-team-config.git
git push -u origin main

# 第二步：在新项目中引用
cd D:\你的新项目
git submodule add https://github.com/你的用户名/claude-team-config.git .claude-team

# 软链接到 .claude
# Windows (管理员 PowerShell)
New-Item -ItemType Junction -Path ".claude" -Target ".claude-team\.claude"
# Linux / Mac
ln -s .claude-team/.claude .claude

# 更新团队配置
git submodule update --remote
```

### 两种方式对比

| 维度 | 手动复制 | Git 子模块 |
|------|----------|------------|
| **难度** | 最简单 | 中等 |
| **更新方式** | 手动覆盖 | `git submodule update` |
| **版本管理** | 无 | 有（独立版本库） |
| **团队协作** | 不适合 | 最适合 |

### 针对不同项目类型的调整

安装后，你可能需要根据项目类型调整配置：

#### 前端项目（React/Next.js）

```bash
# 安装后，.claude/CLAUDE.md 中的技术栈规范已包含 React/Next.js
# 无需额外配置，直接使用
cd D:\你的前端项目
claude
/dev 做一个首页
```

#### 后端 API 项目

```bash
# 可能需要调整 MCP 配置
# 编辑 .claude/.mcp.json，确保 PostgreSQL 连接字符串正确

cd D:\你的后端项目
claude
/dev 做一个用户管理 API
```

#### 全栈项目

```bash
# 全栈项目直接使用，所有能力都可用
cd D:\你的全栈项目
claude
/dev 做一个博客系统
```

#### 移除不需要的组件

如果项目不需要某些 MCP 服务器，编辑 `.claude/.mcp.json` 删除对应配置：

```json
{
  "mcpServers": {
    "github": { ... },
    "context7": { ... },
    "sqlite": { ... },
    "postgres": { ... }
    // 移除了 playwright
  }
}
```

如果不需要某些 Skill，删除对应的目录：

```bash
rm -rf .claude/skills/testing      # 不需要测试
rm -rf .claude/skills/database     # 不需要数据库设计
rm -rf .claude/skills/microservices-design  # 不需要微服务
```

---

## MCP 服务器配置

### 服务器列表（v2.0 精简为 5 个，移除与 Playwright 重叠的 Puppeteer）

| 服务器 | 类型 | 用途 | 启动方式 |
|--------|------|------|----------|
| **GitHub** | HTTP | 仓库管理、PR、Issue | 需要 Token |
| **Playwright** | stdio | 浏览器自动化测试和截图 | 自动 |
| **Context7** | stdio | 查询最新库文档 | 自动 |
| **SQLite** | stdio | 本地数据库开发 | 需要 uvx |
| **PostgreSQL** | stdio | 生产级数据库 | 需要 PG 服务 |

> 各 MCP 的使用示例和场景说明见 [BEST-PRACTICES.md](BEST-PRACTICES.md#mcp-工具什么时候用什么)。

---

## Agent 团队（v2.0 精简为 6 个）

### 角色分工

```
需求输入
    ↓
┌─────────────────────────────────────────────────┐
│  Architect-Planner（规划架构师）                   │
│  - 需求分析 + 任务拆解 + 架构设计 + 技术选型        │
│  - 产出：spec.md / tasks.md / architecture.md     │
│  - 参与：L/XL 级任务                              │
└─────────────────┬───────────────────────────────┘
                  ↓
┌─────────────────────────────────────────────────┐
│  Builder（工程师）+ Designer（设计师）              │
│  - Builder：TDD 开发 + 编码实现 + 单元测试         │
│  - Designer：设计方向 + 原型产出 + 视觉审查         │
│  - 参与：所有任务（Designer 仅涉及 UI 时）         │
└─────────────────┬───────────────────────────────┘
                  ↓
┌─────────────────────────────────────────────────┐
│  Reviewer（审查员）                               │
│  - 代码审查 + 安全检查 + 性能 + 无障碍（6 维度）    │
│  - 合并了原 Security Auditor 职责                  │
│  - 产出：review-report.md                         │
│  - 参与：M 及以上任务                              │
└─────────────────┬───────────────────────────────┘
                  ↓
┌─────────────────────────────────────────────────┐
│  Researcher（研究员）+ DevOps（运维）              │
│  - 技术调研 / CI/CD / 容器化 / 部署                │
│  - 按需调用                                       │
└─────────────────────────────────────────────────┘
```

### Agent 详细说明

#### Architect-Planner（规划架构师）
- **职责**：需求分析、任务拆解、架构设计、技术选型、ADR 记录
- **产出**：spec.md、tasks.md、architecture.md
- **参与时机**：L/XL 级任务的规划阶段
- **v2.0 变化**：合并了原 Planner + Architect，减少角色切换开销

#### Builder（工程师）
- **职责**：按 spec 实现代码、写测试、重构
- **产出**：代码 + 测试
- **规则**：遵循 TDD 流程，小步提交，aria 无障碍标签
- **v2.0 变化**：M 级任务可自行完成轻量审查

#### Designer（设计师）
- **职责**：UI 设计方向、HTML 原型产出、视觉审查、设计系统维护
- **产出**：设计方向（spec.md 中）、`preview/` 原型、设计审查报告
- **参与时机**：L/XL 级涉及 UI 时确定设计方向；Builder 完成 UI 后审查视觉效果
- **v2.0 变化**：从原 Architect 中拆出 UI 设计职责，独立为专职设计师

#### Reviewer（审查员）
- **职责**：代码质量 + 安全 + 性能 + 无障碍 全维度审查
- **6 个维度**：正确性、安全性、性能、可维护性、测试覆盖、无障碍
- **产出**：review-report.md（一次完成，不再分安全/质量两轮）
- **v2.0 变化**：合并了原 Security Auditor，新增无障碍维度

#### Researcher（研究员）
- **职责**：技术调研、方案对比、代码探索
- **工具**：Context7、GitHub、WebSearch
- **产出**：research.md
- **参与时机**：按需调用，Spike 阶段与 Architect 并行

#### DevOps（运维）
- **职责**：CI/CD、容器化、部署、监控
- **产出**：Dockerfile、docker-compose.yml、CI 配置
- **参与时机**：L/XL 级任务、发布阶段

---

## Skill 技能（v2.0 精简为 14 个）

### 项目管理类

| Skill | 触发 | 核心内容 |
|-------|------|----------|
| **project-planning** | 新需求、要求规划 | 需求澄清 → 任务分解 → 优先级排序 → 风险评估 |
| **architecture** | 新项目、技术选型 | 分层架构、模块化、技术选型决策树、ADR |

### 开发类

| Skill | 触发 | 核心内容 |
|-------|------|----------|
| **frontend** | React/Next.js/Astro 开发 | 组件设计、Server Components、React 19 新特性、App Router、ISR、Tailwind、CWV 优化（合并了原 react-patterns + nextjs-mastery） |
| **database** | 数据模型、迁移 | Schema 设计、Prisma/Drizzle/Kysely、查询优化、索引策略 |
| **api-design** | API 设计、认证授权 | RESTful 规范、JWT/OAuth2+PKCE、RBAC、输入验证、OpenAPI（合并了原 authentication-patterns） |
| **debugging** | 遇到 bug | 复现 → 缩小范围 → 定位根因 → 修复 → 验证 |

### 质量类

| Skill | 触发 | 核心内容 |
|-------|------|----------|
| **code-review** | PR 审查、合并前 | 6 维度：正确性 + 安全(OWASP) + 性能 + 可维护性 + 测试 + 无障碍（合并了原 security-review） |
| **testing** | 写测试、制定测试计划 | TDD 循环、AAA 模式、测试金字塔、Vitest、Testcontainers、契约测试、属性测试（合并了原 tdd + testing-strategies） |
| **performance** | 性能问题、上线前 | LCP/FID/CLS、N+1 查询、缓存策略、代码分割、图片优化 |
| **ui-design** | 前端界面设计 | 字体排版、配色系统、空间构成、动效设计、暗色模式、拒绝 AI 廉价感 |
| **ui-prototype** | 画原型、选风格 | 4 种预设风格（Apple 简约/深色渐变/新拟物/极简线框）、静态 HTML 原型产出、设计契约 |

### 工程化类

| Skill | 触发 | 核心内容 |
|-------|------|----------|
| **ci-cd-pipelines** | 配置 CI/CD | GitHub Actions、Docker 构建、自动化测试、部署策略、Changesets |
| **microservices-design** | 分布式系统设计 | 服务拆分、通信模式、数据一致性、可观测性 |

> Skill 合并历史见 [CHANGELOG.md](CHANGELOG.md#v2002026-06-07)。

---

## Slash Command 命令

### /dev - 智能开发流程

**用途**：根据任务复杂度自动选择流程

**流程（v2.0）**：
1. **评估复杂度** → 判断 S/M/L/XL 级别
2. **Plan（L/XL）** → Architect-Planner 规划
3. **迭代开发** → Builder 构建 + Reviewer 并行审查
4. **验收** → 测试通过 + 用户确认

**使用示例**：
```
/dev 做一个用户注册登录功能
/dev 实现一个 TODO 应用
/dev 给现有项目添加文件上传功能
```

### /review-all - 多维度联合审查

**用途**：Reviewer 一次完成所有维度审查（不再分安全/质量两轮）

**6 个审查维度**：
- 代码质量（正确性、可维护性）
- 安全性（OWASP Top 10、依赖漏洞）
- 性能（查询优化、前端性能）
- 架构（模块划分、依赖关系）
- 测试（覆盖度、边界条件）
- 无障碍（WCAG AA、aria 标签、键盘操作）

**使用示例**：
```
/review-all src/features/auth/
/review-all 最近的变更
/review-all
```

### /ship - 发布前检查

**用途**：代码发布前的全面检查

**检查项**：
- 代码检查（测试、类型、TODO）
- 安全检查（漏洞、密钥、权限）
- 性能检查（查询、渲染、图片）
- 配置检查（环境变量、迁移、文档）
- Git 检查（分支、commit、.gitignore）

**使用示例**：
```
/ship
```

### /standup - 项目状态汇报

**用途**：生成项目当前状态的简要汇报

**内容**：
- 已完成的任务
- 进行中的任务
- 阻塞项
- 下一步计划
- 整体进度

**使用示例**：
```
/standup
```

---

## Rules 规则

### typescript.md

自动应用于 `**/*.ts` 和 `**/*.tsx` 文件：

- 使用 `interface` 定义对象形状
- 使用 `type` 定义联合/交叉类型
- 不使用 `any`，用 `unknown` 替代
- 命名：接口 PascalCase，变量 camelCase，常量 UPPER_SNAKE_CASE
- 使用可选链 `?.` 和空值合并 `??`
- 使用 `import type` 导入纯类型

### react.md

自动应用于 `**/*.tsx` 和 `**/*.jsx` 文件：

- 优先使用函数组件和 Hooks
- 组件单一职责
- 状态管理：局部用 useState，跨组件用 useContext，复杂用 Zustand
- 性能：React.memo、useMemo、useCallback
- 列表渲染使用稳定的 key（不用 index）
- **无障碍**：交互元素必须有 aria-label、语义化 HTML、颜色对比度 >= 4.5:1、键盘可操作

### node.md

自动应用于 `**/*.js` 和 `**/server/**` 文件：

- 使用 ES Modules
- async/await 优先
- 使用 helmet、cors、rate-limit
- 输入验证用 Zod
- 结构化日志（JSON）

### testing.md

自动应用于 `**/*.test.*` 和 `**/*.spec.*` 文件：

- AAA 模式：Arrange → Act → Assert
- 命名：`describe('功能') > it('应该...')`
- Mock 外部依赖，不 Mock 被测代码
- 覆盖率目标：语句 >80%，分支 >70%，函数 >90%

### git.md

全局生效：

- 分支：`feature/`、`fix/`、`hotfix/`
- Commit：`<type>(<scope>): <subject>`
- Type：feat、fix、docs、style、refactor、test、chore

---

## Hooks 钩子

### 代码安全检查 Hook（PreToolUse - Write/Edit）

**触发时机**：每次 Write/Edit 操作前

**v2.0 改进**：自动剥离注释再检查，减少误报；增加原型链污染检测

| 严重程度 | 检查项 |
|----------|--------|
| 🔴 严重 | eval()、new Function() |
| 🔴 严重 | innerHTML、dangerouslySetInnerHTML |
| 🔴 严重 | os.system()、child_process.exec() |
| 🔴 严重 | 原型链污染（`__proto__=`、`constructor[`） |
| 🟡 中等 | 硬编码密钥/密码（8+ 字符） |
| 🟡 中等 | SQL 字符串拼接 |
| 🟡 中等 | JSON.parse() 接受不可信输入 |

**行为**：发现安全问题时输出警告，由用户决定是否继续。

### Bash 命令检查 Hook（PreToolUse - Bash）🆕

**触发时机**：每次 Bash 命令执行前

**拦截（exit 2）**：
- `rm -rf /`、`rm -rf ~`、`rm -rf $HOME`
- `git push --force`（到 main/master）
- `git reset --hard`
- `git clean -f`

**警告（exit 0）**：
- `curl | bash`（远程脚本执行）
- `chmod 777`
- `docker --privileged`
- `eval` 命令

### 任务追踪 Hook（Stop）

**触发时机**：Claude 停止响应时

**行为**：提醒检查任务完成度，使用 TaskList 确认进度。

---

## 典型工作流

| 复杂度 | 流程 | 示例 |
|--------|------|------|
| **S 级** | 直接修 → 测试 → Ship | 修 typo、改配置 |
| **M 级** | 快速规划 → 构建+审查 → Ship | 加搜索框、加 API 端点 |
| **L 级** | 规划 → 多轮迭代（构建+审查） → Ship | 用户认证、文件上传 |
| **XL 级** | 调研 → 架构 → 多轮迭代 → 集成验证 → Ship | 重构支付系统 |

> 各级别的详细场景说明和操作指南见 [BEST-PRACTICES.md](BEST-PRACTICES.md#场景实战)。

---

## 常见问题

### Q: MCP 服务器连不上怎么办？

```bash
# 检查 Node.js 版本
node --version  # 需要 18+

# 手动测试 MCP 服务器
npx @playwright/mcp@latest  # 测试 Playwright
npx -y @upstash/context7-mcp  # 测试 Context7

# 检查 GitHub Token
echo $GITHUB_PERSONAL_ACCESS_TOKEN
```

### Q: GitHub MCP 需要什么权限？

Token 需要以下权限：
- `repo` - 完整仓库访问
- `read:org` - 读取组织信息
- `read:user` - 读取用户信息

### Q: SQLite MCP 报错怎么办？

```bash
# 安装 uvx
pip install uv

# 或使用 pipx
pipx install uv

# 创建数据目录
mkdir -p data
```

### Q: PostgreSQL MCP 连接字符串怎么配置？

编辑 `.claude/.mcp.json`：

```json
"postgres": {
  "type": "stdio",
  "command": "npx",
  "args": ["-y", "@modelcontextprotocol/server-postgres", "postgresql://用户名:密码@主机:端口/数据库名"]
}
```

或使用环境变量：
```json
"args": ["-y", "@modelcontextprotocol/server-postgres", "${DATABASE_URL}"]
```

### Q: 安全检查 Hook 太严格/太宽松怎么办？

编辑 `.claude/settings.json` 中的 `hooks` 配置：

```json
// 移除安全检查
"PreToolUse": []

// 或修改 .claude/hooks/security-check.sh 调整检查规则
```

### Q: 如何禁用某个 MCP 服务器？

编辑 `.claude/.mcp.json`，删除或注释掉对应的服务器配置。

### Q: 如何添加新的 Agent？

在 `.claude/agents/` 目录下创建新的 `.md` 文件，格式参考现有 Agent。

### Q: 如何添加新的 Skill？

在 `.claude/skills/` 目录下创建新目录和 `SKILL.md` 文件：

```markdown
---
name: my-skill
description: 技能描述
---

# 技能内容
...
```

### Q: Rules 文件怎么生效？

Rules 文件放在 `.claude/rules/` 目录下，Claude Code 会根据文件名自动匹配：

- `typescript.md` → `**/*.ts`, `**/*.tsx`
- `react.md` → `**/*.tsx`, `**/*.jsx`
- `node.md` → `**/*.js`, `**/server/**`
- `testing.md` → `**/*.test.*`, `**/*.spec.*`
- `git.md` → 全局生效

### Q: 如何自定义 Slash Command？

在 `.claude/commands/` 目录下创建 `.md` 文件，文件名即命令名：

```
.claude/commands/my-command.md  →  /my-command
```

---

## 配置文件说明

### .claude/CLAUDE.md
核心指令文件（v2.0），定义了：
- Karpathy 四原则 + 反馈尽早
- 并行迭代工作流（替代旧的线性瀑布流）
- S/M/L/XL 任务分级
- 技术栈规范（新增 Hono、Astro、Kysely、Turborepo）
- 非功能需求清单（性能阈值、无障碍等级）
- 6 个角色分工
- 文档策略（按任务级别产出）

### .claude/settings.json
项目级配置，包含：
- 权限白名单（允许的命令）
- 危险命令黑名单（rm -rf / 等）
- Hook 配置（代码安全检查、Bash 命令检查、任务追踪）

### .claude/.mcp.json
MCP 服务器配置（v2.0 精简为 5 个）：
- GitHub（HTTP）
- Playwright（stdio）
- Context7（stdio）
- SQLite（stdio）
- PostgreSQL（stdio）

---

## 更新日志

详见 [CHANGELOG.md](CHANGELOG.md)。
