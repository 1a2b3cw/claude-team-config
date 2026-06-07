# Node.js 规范

## 模块系统
- 使用 ES Modules（import/export）
- 文件扩展名使用 `.js` 或 `.mjs`
- 避免 CommonJS（require/module.exports）

## 错误处理
- 使用自定义错误类
- 在中间件统一处理错误
- 未捕获异常记录日志后优雅退出
- 不要吞掉错误

## 异步编程
- 优先使用 async/await
- 避免回调地狱
- 使用 `Promise.all` 并行执行
- 设置超时和取消机制

## 安全实践
- 使用 helmet 设置安全头
- 使用 cors 限制跨域
- 使用 rate-limit 防止暴力攻击
- 验证所有用户输入（Zod）
- 使用参数化查询防止 SQL 注入

## 日志
- 使用结构化日志（JSON 格式）
- 不记录敏感信息（密码、Token）
- 日志级别：error > warn > info > debug

## 环境变量
- 使用 `.env` 文件（不提交到 Git）
- 使用 `zod` 验证环境变量
- 提供 `.env.example` 模板

## 项目结构
```
src/
├── routes/         # 路由定义
├── middleware/      # 中间件
├── services/       # 业务逻辑
├── repositories/   # 数据访问
├── types/          # 类型定义
├── utils/          # 工具函数
└── index.ts        # 入口文件
```

## API 设计
- RESTful 风格
- 统一响应格式
- 正确使用 HTTP 状态码
- 版本化 API（/api/v1/...）
