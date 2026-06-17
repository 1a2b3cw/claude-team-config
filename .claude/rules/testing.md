# 测试规则（必须遵守）

> 详细参考：`.claude/specs/testing.md`（编辑 .test.ts/.spec.ts 文件时自动注入）

## 必须做
- AAA 模式（Arrange → Act → Assert）
- 测试命名：`describe('功能') > it('应该在[条件]时[行为]')`
- Mock 外部依赖，不 Mock 被测代码
- 测试文件与源文件同目录，命名为 `*.test.ts`

## 覆盖率目标
- 语句 > 80%，分支 > 70%，函数 > 90%
- 核心业务逻辑：100%

## 必测边界
- 空值 / null / undefined
- 空数组 / 空对象
- 零值 / 负值 / 最大值
- 权限不足
