# TypeScript 规范

## 类型定义
- 使用 `interface` 定义对象形状
- 使用 `type` 定义联合类型、交叉类型、工具类型
- 不使用 `any`，必要时用 `unknown`
- 优先使用泛型提高复用性

## 命名规范
- 接口/类型：PascalCase（`User`, `CreateUserInput`）
- 变量/函数：camelCase（`getUserById`, `isValid`）
- 常量：UPPER_SNAKE_CASE（`MAX_RETRY_COUNT`）
- 枚举：PascalCase，成员 PascalCase（`UserRole.Admin`）

## 代码风格
- 使用 `const` 断言（`as const`）
- 使用可选链（`?.`）和空值合并（`??`）
- 使用解构赋值
- 使用剩余参数代替 `arguments`

## 错误处理
- 使用自定义错误类继承 `Error`
- 在边界层捕获错误，内部函数抛出错误
- 使用 `Result` 模式或 `try-catch`，保持一致

## 导入导出
- 使用命名导出，不用默认导出
- 按类型分组导入：外部库 → 内部模块 → 相对路径
- 使用 `import type` 导入纯类型

## 示例
```typescript
// 好
interface CreateUserInput {
  name: string;
  email: string;
  role?: UserRole;
}

async function createUser(input: CreateUserInput): Promise<User> {
  const { name, email, role = UserRole.Member } = input;
  // 实现
}

// 坏
async function createUser(data: any) {
  // 实现
}
```
