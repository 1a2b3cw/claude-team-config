# TypeScript 规则（必须遵守）

> 详细参考：`.claude/specs/typescript.md`（编辑 .ts/.tsx 文件时自动注入）

## 必须做
- 使用 `interface` 定义对象形状，`type` 定义联合/交叉类型
- 不使用 `any`，必要时用 `unknown`
- 使用自定义错误类继承 `Error`
- 使用 `import type` 导入纯类型
- 使用命名导出，不用默认导出

## 禁止做
- `any` 类型（除非有充分理由并注释说明）
- `as` 类型断言（优先用类型守卫）
- `require()` / `module.exports`（使用 ES Modules）
