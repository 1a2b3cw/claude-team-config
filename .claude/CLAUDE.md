# AI 全栈开发团队

> v2.0.0 | 2026-06-07

## 核心原则

1. **先思考再编码**：理解需求，明确假设，有疑问先问
2. **简洁优先**：不做过度设计，不写用不到的功能，不处理不可能的场景
3. **精准修改**：只改该改的，不顺手"优化"无关代码，匹配现有风格
4. **目标驱动**：把任务变成可验证的目标，测试先行
5. **反馈尽早**：安全、性能、可维护性在开发中持续检查，不等到最后

## 工作流程：并行迭代模型

### 任务分级

根据复杂度决定流程，不做一刀切：

| 级别 | 定义 | 参与角色 | 文档产出 | 示例 |
|------|------|----------|----------|------|
| **S（热修）** | 1 行 ~ 10 行修复 | Builder 直接修 | 无 | 修 typo、改配置值 |
| **M（小功能）** | 单模块、1-2 文件 | Builder + Reviewer | tasks.md | 加一个 API 端点、加一个表单字段 |
| **L（中功能）** | 跨模块、3-10 文件 | Architect + Builder + Reviewer | spec.md + tasks.md | 用户认证、文件上传 |
| **XL（大功能）** | 新系统、10+ 文件 | 全员参与 | spec.md + architecture.md | 新建支付系统、重构架构 |

### 流程图

```
S 级：Build → Test → Ship
M 级：Plan(简) → Build+Review(内联) → Ship
L/XL 级：

  ┌─────────────────────────────────────────────────┐
  │           Phase 0: Spike（探针）                 │
  │   Researcher + Architect 并行调研                  │
  │   产出：可行性结论 + 技术方案（可选）               │
  └──────────┬──────────────────────────────────────┘
             ↓
  ┌─────────────────────────────────────────────────┐
  │           Phase 1: Plan                          │
  │   Architect-Planner 输出 spec.md + tasks.md       │
  │   用户确认后进入迭代                               │
  └──────────┬──────────────────────────────────────┘
             ↓
  ┌─────────────────────────────────────────────────┐
  │    Phase 2: Iteration（每个迭代 1-3 个任务）       │
  │                                                  │
  │   ┌───────┐  ┌───────┐  ┌────────────────────┐  │
  │   │ Plan  │→ │ Build │→ │ Continuous Review   │  │
  │   │(选任务)│  │(TDD)  │  │(质量+安全+性能并行) │  │
  │   └───────┘  └───────┘  └────────────────────┘  │
  │        ↑                           │             │
  │        └───────────────────────────┘             │
  │              反馈在迭代内闭环                      │
  └──────────┬──────────────────────────────────────┘
             ↓
  ┌─────────────────────────────────────────────────┐
  │           Phase 3: Ship                          │
  │   集成验证 → 发布检查 → 部署                       │
  └─────────────────────────────────────────────────┘
```

### 关键改变

- **Review 不是独立阶段**，而是在 Build 过程中持续进行
- **安全检查贯穿全程**，不等到最后
- **小任务跳过文档**，直接写代码
- **迭代可中断**：发现方向错了，随时回退调整

## 技术栈规范

### 前端
- **语言**：TypeScript（严格模式）
- **框架**：React 18+ / Next.js 14+ / Astro（内容站点）
- **状态管理**：Zustand / React Context（按需选择）
- **样式**：Tailwind CSS / CSS Modules
- **测试**：Vitest + React Testing Library + Playwright

### 后端
- **运行时**：Node.js 20+ / Bun
- **框架**：Hono（优先）/ Fastify / Express
- **ORM**：Prisma / Drizzle / Kysely（按需选择）
- **数据库**：SQLite（开发）/ PostgreSQL（生产）
- **验证**：Zod / TypeBox
- **部署**：Edge Runtime / Serverless / Container（按场景选择）

### 工具链
- **包管理**：pnpm（优先）/ bun
- **格式化**：Prettier
- **检查**：ESLint（含 security plugin）
- **构建**：Vite / tsup
- **容器**：Docker / Docker Compose
- **Monorepo**：Turborepo / Nx（多包项目）
- **发布**：Changesets / semantic-release

## 代码规范

### 命名
- 变量/函数：camelCase
- 类/接口/类型：PascalCase
- 常量：UPPER_SNAKE_CASE
- 文件名：kebab-case（组件用 PascalCase）
- 数据库表/列：snake_case

### 函数
- 单一职责，一个函数做一件事
- 参数不超过 3 个，多了用对象
- 优先纯函数，减少副作用
- 错误处理在边界层，内部函数抛异常

### 文件组织
```
src/
├── features/          # 按功能模块组织
│   └── [feature]/
│       ├── components/
│       ├── hooks/
│       ├── services/
│       ├── types/
│       └── index.ts
├── shared/            # 共享代码
│   ├── components/
│   ├── hooks/
│   ├── utils/
│   └── types/
├── app/               # 应用入口和路由
└── server/            # 后端代码
    ├── routes/
    ├── services/
    ├── middleware/
    └── db/
```

## 测试要求

- **单元测试**：工具函数、业务逻辑必须有测试
- **集成测试**：API 端点、数据库操作需要测试
- **E2E 测试**：核心用户流程用 Playwright 测试
- **无障碍测试**：关键页面需通过 axe-core 检查
- **测试命名**：`describe('功能') > it('应该做什么')`
- **测试位置**：与源文件同目录，命名为 `*.test.ts`

## 非功能需求清单

在 spec 阶段必须确认以下指标（按项目需要选择）：

| 维度 | 指标 | 默认阈值 |
|------|------|----------|
| **性能** | LCP | < 2.5s |
| **性能** | CLS | < 0.1 |
| **性能** | API 响应时间 | P95 < 200ms |
| **安全** | npm audit | 无 high/critical |
| **无障碍** | WCAG 等级 | AA |
| **可用性** | 错误率 | < 0.1% |

## 安全要求

所有代码必须避免：
- `eval()` / `new Function()`
- `innerHTML` / `dangerouslySetInnerHTML`（除非经过 sanitize）
- SQL 字符串拼接（使用参数化查询）
- `os.system()` / `child_process.exec()`（使用 spawn + 参数数组）
- 硬编码密钥/密码（使用环境变量）
- 不校验的用户输入
- `JSON.parse()` 接受不可信输入（需 try-catch）
- 原型链污染（`__proto__`、`constructor`）

## 角色分工

| 角色 | 职责 | 何时参与 |
|------|------|----------|
| **Architect-Planner** | 需求分析、任务拆解、架构设计、技术选型 | L/XL 级任务 |
| **Builder** | 编码实现、单元测试、重构 | 所有任务 |
| **Reviewer** | 代码审查、安全检查、性能检查（合并原 Security Auditor） | M 及以上任务 |
| **Researcher** | 技术调研、方案对比、代码探索 | 按需调用 |
| **DevOps** | CI/CD、部署、容器化、监控 | L/XL 级任务、发布阶段 |

## 交互规范

- 所有沟通使用中文
- 代码注释使用英文
- Git commit message 使用英文
- 技术术语可保留英文原文

## MCP 工具使用

- **GitHub MCP**：管理仓库、PR、Issue
- **Playwright MCP**：浏览器自动化测试和截图
- **Context7 MCP**：查询最新库文档
- **SQLite MCP**：本地开发数据库
- **PostgreSQL MCP**：生产级数据库操作和查询

## 项目状态追踪

使用 TaskCreate/TaskUpdate 追踪任务进度：
- 每个任务有明确的 subject 和 description
- 任务完成后立即标记 completed
- 阻塞时创建新的阻塞任务
- 使用 TaskList 定期检查整体进度

## 文档策略

| 任务级别 | 必须产出 | 说明 |
|----------|----------|------|
| S | 无 | 代码即文档 |
| M | tasks.md（轻量 checklist） | 内联到 PR 描述 |
| L | spec.md + tasks.md | spec 保持精简 |
| XL | spec.md + architecture.md + ADR | ADR 记录关键决策 |
