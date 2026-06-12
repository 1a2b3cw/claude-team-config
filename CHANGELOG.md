# 更新日志

## v2.0.1（2026-06-12）

**文档和规范改进**

- 修复 README/USAGE 中 Agent 数量（5→6）和 Skill 数量（13→14）不一致
- 给 `ui-prototype/SKILL.md` 添加 frontmatter（name + description）
- 统一所有 Skill 描述语言为中文
- 修复 `database` Skill 的 name 字段不匹配（database-optimization → database）
- 明确 Builder Agent 中 Designer/Reviewer 在 UI 任务中的审查协作顺序
- design.md 增加优先级层级说明（preview/ > spec.md > styles/*.md > design.md）
- 统一配色规范为 60-30-10 法则，移除与具体风格冲突的硬性限制
- CLAUDE.md 任务分级增加安全敏感度升级规则
- bash-check.sh：区分 `--force` 和 `--force-with-lease`，增强 `rm -rf` 变体检测
- security-check.sh：跳过 .sh 脚本文件避免误报
- 移除 README 中不存在的 install 脚本引用
- CHANGELOG 从 USAGE.md 独立为 CHANGELOG.md
- 消除审查定义三重重复（reviewer.md、review-all.md 引用 code-review SKILL.md）
- 精简 USAGE.md：移除与 CHANGELOG 重复的 v2.0 对比表、与 BEST-PRACTICES 重复的 MCP 示例和工作流场景
- database Skill 的 Python 示例改为 TypeScript（匹配项目技术栈）
- DevOps Agent 模板代码移至 ci-cd-pipelines Skill，Agent 文件精简为角色定义
- design.md "绝对禁止" 改为 "默认禁止"，与优先级层级说明一致

## v2.0.0（2026-06-07）

**架构级重构：从线性瀑布流到并行迭代模型**

| 变化 | v1.x | v2.0 |
|------|------|------|
| 工作流 | 串行瀑布流 | 并行迭代模型 |
| 任务分级 | 一刀切全流程 | S/M/L/XL 四级按需 |
| Agent 数量 | 7 个（职责分散） | 6 个（合并精简） |
| Skill 数量 | 18 个（重叠多） | 14 个（合并精简） |
| 安全检查 | 仅 Write/Edit | + Bash 命令检查 |
| MCP 服务器 | 6 个 | 5 个（去重 Puppeteer） |
| 无障碍 | 无 | 审查维度 + 规则 |

**详细变更**：
- **工作流**：线性瀑布流 → 并行迭代模型，Review 在 Build 过程中持续进行
- **任务分级**：新增 S/M/L/XL 四级，小任务跳过文档直接写代码
- **Agent**：Planner + Architect 合并为 Architect-Planner；Security Auditor 合并入 Reviewer
- **Skill**：frontend 合并 react-patterns + nextjs-mastery；code-review 合并 security-review；testing 合并 tdd + testing-strategies；api-design 合并 authentication-patterns
- **技术栈**：新增 Hono（优先框架）、Astro、Kysely、Turborepo、Changesets、Edge Runtime
- **安全 Hook**：新增 bash-check.sh（拦截危险命令）；security-check.sh 增加注释剥离、原型链污染检测
- **无障碍**：react.md 规则增加 WCAG AA 要求；Reviewer 增加第 6 维度；/ship 增加无障碍检查
- **Docker**：修复 Dockerfile（`npm prune --omit=dev`）；docker-compose 移除 version 字段
- **CI/CD**：GitHub Actions 增加 matrix 测试、codecov、Docker layer cache
- **非功能需求**：CLAUDE.md 新增性能阈值表（LCP < 2.5s, CLS < 0.1）

## v1.1.0（2026-06-02）
- 新增 8 个 Skill：ui-design、testing-strategies、react-patterns、nextjs-mastery、authentication-patterns、typescript-advanced、ci-cd-pipelines、microservices-design
- 移除 PostToolUse 格式化提示 Hook（功能过弱，无实际价值）
- 修复安全检查 Hook 逻辑 bug（`&&` → `||`）
- 修复 PostgreSQL 连接字符串硬编码问题（改为 `${DATABASE_URL}`）
- 新增 PostgreSQL 到 CLAUDE.md MCP 工具说明
- 安装脚本和文档同步更新

## v1.0.0（2026-06-02）
- 初始版本
- 7 个 Agent
- 10 个 Skill
- 6 个 MCP 服务器
- 4 个 Slash Command
- 5 个 Rules
- 2 个 Hook
