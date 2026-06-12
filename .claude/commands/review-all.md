# /review-all - 多维度联合审查

Reviewer Agent 一次完成所有维度的审查。

## 审查规范

审查维度、输出格式、审查原则均遵循 `.claude/skills/code-review/SKILL.md` 中的定义。

### 6 个维度（简要）
1. **正确性** — 逻辑、边界、错误处理、并发
2. **安全性** — OWASP Top 10、依赖漏洞、输入验证
3. **性能** — N+1 查询、重渲染、内存泄漏、分页
4. **可维护性** — 命名、职责、重复、复杂度
5. **测试** — 覆盖率、边界条件、独立可重复
6. **无障碍** — WCAG AA、aria 标签、键盘操作

## 使用方式
```
/review-all src/features/auth/
/review-all 最近的变更
/review-all
```
