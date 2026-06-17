# Node.js 规则（必须遵守）

> 详细参考：`.claude/specs/node.md`（编辑服务端 .ts/.js 文件时自动注入）

## 必须做
- ES Modules（import/export）
- async/await，不用回调
- 验证所有用户输入（Zod）
- 参数化查询，禁止 SQL 拼接
- 环境变量用 `.env`，不提交到 Git
- 结构化日志（JSON），不记录敏感信息

## 禁止做
- `os.system()` / `child_process.exec()`（用 spawn + 参数数组）
- 硬编码密钥/密码
- 吞掉错误（catch 块必须处理或重新抛出）
- `JSON.parse()` 不加 try-catch（处理不可信输入时）
