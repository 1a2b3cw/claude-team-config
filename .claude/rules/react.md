# React 规则（必须遵守）

> 详细参考：`.claude/specs/react.md`（编辑 .tsx/.jsx 文件时自动注入）

## 必须做
- 函数组件 + Hooks
- Props 用 `interface` 定义，可选用 `?` 标记
- 交互元素必须有 `aria-label` 或可见文本
- 图片必须有 `alt` 属性
- 列表用稳定的 `key`（不用 index）

## 禁止做
- 在条件/循环中调用 Hook
- JSX 中使用 if-else（用三元或 &&）
- `innerHTML` / `dangerouslySetInnerHTML`（除非经过 sanitize）
- 无反馈的可点击元素（必须有 hover/press 状态）
