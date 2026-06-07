# 测试规范

## 测试类型
- **单元测试**：工具函数、业务逻辑
- **集成测试**：API 端点、数据库操作
- **E2E 测试**：核心用户流程

## 命名规范
```typescript
describe('功能/模块名', () => {
  describe('函数名', () => {
    it('应该在[条件]时[行为]', () => {});
    it('应该在[异常情况]时[抛出错误/返回默认值]', () => {});
  });
});
```

## 测试结构（AAA 模式）
```typescript
it('应该计算订单总价', () => {
  // Arrange（准备）
  const items = [{ price: 10, quantity: 2 }];

  // Act（执行）
  const total = calculateTotal(items);

  // Assert（断言）
  expect(total).toBe(20);
});
```

## 边界条件
必测的边界情况：
- 空值 / null / undefined
- 空数组 / 空对象
- 零值 / 负值
- 最大值 / 最小值
- 特殊字符
- 权限不足

## Mock 原则
- Mock 外部依赖（数据库、API、文件系统）
- 不 Mock 被测试的代码
- Mock 返回值要真实
- 验证 Mock 被正确调用

## 测试文件位置
- 与源文件同目录
- 命名为 `*.test.ts` 或 `*.spec.ts`
- 或放在 `__tests__/` 目录

## 测试命令
```bash
# 运行所有测试
pnpm test

# 运行特定文件
pnpm test src/utils/math.test.ts

# 运行带覆盖率
pnpm test --coverage

# 监听模式
pnpm test --watch
```

## 测试覆盖率目标
- 语句覆盖率：> 80%
- 分支覆盖率：> 70%
- 函数覆盖率：> 90%
- 核心业务逻辑：100%
