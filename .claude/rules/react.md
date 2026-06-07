# React 规范

## 组件设计
- 优先使用函数组件和 Hooks
- 组件单一职责
- Props 接口使用 `interface` 定义
- 可选 Props 用 `?` 标记，提供默认值

## Hooks 使用
- 自定义 Hook 以 `use` 开头
- Hook 调用不能在条件语句中
- useEffect 依赖数组要完整
- 避免在循环/条件中调用 Hook

## 状态管理
- 局部状态：`useState`
- 跨组件状态：`useContext`
- 复杂状态：Zustand
- 服务端状态：TanStack Query

## 性能优化
- 使用 `React.memo` 包裹纯展示组件
- 使用 `useMemo` 缓存计算结果
- 使用 `useCallback` 缓存回调函数
- 大列表使用虚拟滚动

## 事件处理
- 事件处理函数以 `handle` 开头
- 传递给子组件的回调以 `on` 开头
- 避免在 JSX 中定义内联函数（复杂组件中）

## 条件渲染
```tsx
// 好：使用三元运算符
{isLoggedIn ? <UserProfile /> : <LoginForm />}

// 好：使用 && 运算符
{hasPermission && <AdminPanel />}

// 坏：使用 if-else 在 JSX 中
```

## 列表渲染
```tsx
// 好：使用稳定的 key
{users.map(user => (
  <UserCard key={user.id} user={user} />
))}

// 坏：使用 index 作为 key（列表会变化时）
{users.map((user, index) => (
  <UserCard key={index} user={user} />
))}
```

## 无障碍（Accessibility）
- 交互元素必须有 `aria-label` 或可见文本
- 使用语义化 HTML：`<button>`、`<nav>`、`<main>`、`<h1-h6>`
- 表单元素关联 `<label>`
- 图片必须有 `alt` 属性（装饰性图片用 `alt=""`）
- 颜色对比度 >= 4.5:1（WCAG AA）
- 所有功能可通过键盘操作（Tab、Enter、Escape）
- 使用 `role` 和 `aria-*` 属性增强自定义组件
