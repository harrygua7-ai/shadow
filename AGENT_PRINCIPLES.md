# Agent 协作原则

## 1. 文件目的

本文档用于指导所有参与 Shadow 开发的内部 Agent 协作。

这里的 Agent 指的是开发 Agent、设计 Agent、工程 Agent、审查 Agent，而不是 Shadow 世界里的 NPC Agent。

所有内部 Agent 必须理解：Shadow 是一个 AI 原生社区世界，不是普通游戏、AI 陪伴应用、聊天室或品牌展厅。

## 2. 核心协作原则

Shadow 的开发采用 agentic engineering 工作流。

Agent 可以帮助我们：

- 发散方案
- 拆解系统
- 生成代码
- 搭建 Godot 原型
- 检查风险
- 优化交互
- 设计地图
- 设计记忆系统
- 审查实现

但 Agent 不能替代产品判断。

最终方向由项目 owner 和主协调 Agent 决定。

## 3. 角色分工原则

每个 Agent 必须有清晰边界。

每个 Agent 启动前必须明确：

- 任务目标
- 输入资料
- 输出格式
- 权限范围
- 禁止事项
- 验收标准

不要启动模糊 Agent。

错误示例：

```text
帮我想想地图。
```

正确示例：

```text
基于 MAP_STANDARD，设计 Shadow MVP 小镇地图的地点布局、道路关系、玩家路线和风险点。只输出方案，不修改文件。
```

## 4. 并行与串行原则

Agent 协作不是所有人同时开工。

采用：

> 方向和接口先串行，探索和实现可并行，整合必须串行。

### 必须串行的事情

- 产品方向决定
- MVP 范围确认
- 地图标准确认
- 技术接口定义
- 最终方案整合
- Godot 核心场景合并
- 用户体验验收

### 可以并行的事情

- 地图布局探索
- Tile 系统方案
- 交互 UX 方案
- 视觉参考
- QA checklist
- 风险清单
- 文档草案
- 独立素材生成

## 5. 主协调 Agent 原则

主协调 Agent 负责：

- 读取总 DMD
- 维护产品方向
- 拆分任务
- 分配 Agent
- 整合 Agent 输出
- 识别冲突
- 决定下一步执行路径
- 向项目 owner 汇报关键判断

主协调 Agent 不应该把产品方向外包给其他 Agent。

其他 Agent 可以提出建议，但不能擅自改变 MVP 定义。

## 6. 专项 Agent 原则

专项 Agent 应该只负责自己的领域。

例如：

- Map Director Agent：地图布局和空间体验
- Tile System Agent：TileMap 结构、tile 类型、碰撞规则
- Interaction UX Agent：玩家移动、热区、点击反馈、地图 UI
- Godot Implementation Agent：Godot 场景和代码实现
- Tile Asset Agent：临时素材、tileset、视觉资产
- QA Agent：验收、测试、发现问题
- AI Resident Agent：NPC Agent 架构和记忆行为
- Safety Agent：反诈骗、互动边界、安全策略

专项 Agent 不应该随意跨界改动其他模块。

## 7. 文件修改权限原则

不是所有 Agent 都可以改文件。

建议分为四类权限：

### 只读 Agent

只能阅读文档和代码，输出分析报告。

适合：

- Research Agent
- Review Agent
- Strategy Agent

### 文档 Agent

可以创建或修改文档，但不改代码。

适合：

- Product Agent
- Map Director Agent
- UX Agent

### 实现 Agent

可以修改代码、场景、资源，但必须限制在指定目录。

适合：

- Godot Implementation Agent
- Backend Agent
- Agent Runtime Agent

### 审查 Agent

只检查，不直接改。

适合：

- QA Agent
- Safety Agent
- Architecture Review Agent

## 8. 禁止事项

所有 Agent 默认禁止：

- 擅自扩大 MVP 范围
- 擅自引入复杂经济系统
- 擅自引入完整 B 端 SaaS
- 擅自改变产品定位
- 擅自把产品做成传统 RPG
- 擅自开放无限私聊
- 擅自让 NPC 变成纯聊天机器人
- 擅自绕过安全限制
- 擅自删除或重写用户未确认的重要文件
- 多个 Agent 同时修改同一个核心场景文件
- 在没有验收标准的情况下大规模实现

## 9. 输出格式原则

每个 Agent 的输出必须可整合。

推荐输出格式：

```text
1. 任务理解
2. 核心结论
3. 具体方案
4. 风险点
5. 需要决策的问题
6. 下一步建议
```

如果是工程 Agent，额外包含：

```text
修改文件
实现内容
运行方式
测试结果
剩余问题
```

如果是设计 Agent，额外包含：

```text
设计目标
用户体验流程
备选方案
推荐方案
为什么不选其他方案
```

## 10. 冲突处理原则

如果多个 Agent 给出冲突方案：

1. 主协调 Agent 先整理冲突点。
2. 判断冲突属于产品、工程、成本、体验还是安全。
3. 给出推荐方案。
4. 交给项目 owner 确认。
5. 确认后写入对应标准文件。

不要让多个 Agent 自行争论并私自合并。

## 11. 地图开发阶段的协作规则

地图相关工作建议按以下顺序：

1. 确认 `MAP_STANDARD`
2. Map Director Agent 输出空间布局
3. Tile System Agent 输出 tile 结构
4. Interaction UX Agent 输出移动和热区交互
5. 主协调 Agent 整合方案
6. 项目 owner 确认
7. Godot Implementation Agent 实现
8. QA Agent 检查
9. 主协调 Agent 修正并汇报

地图实现阶段不要让多个 Agent 同时修改同一个 Godot 主场景。

## 12. MVP 优先级原则

所有 Agent 必须优先服务 MVP。

MVP 当前重点是：

- 地图基础
- 玩家小点
- 摄像机跟随
- 地点热区
- 基础碰撞
- 轻量昼夜/天气预留
- 可扩展 TileMap
- 后续社会现场入口

暂时不做：

- 完整经济
- 完整市长系统
- 品牌入驻
- 大规模 NPC
- 完整 Agent 生态
- 复杂私聊
- 大型 3D 世界

## 13. 判断标准

每个 Agent 的工作应该被这几个问题检验：

- 是否让 Shadow 更像一个活的社会？
- 是否服务当前 MVP？
- 是否降低后续开发混乱？
- 是否保留长期扩展性？
- 是否避免过度复杂化？
- 是否能被用户实际体验到？
- 是否安全、可控、可审计？

## 14. 最高原则

Agentic engineering 的目的不是让 Agent 自由发挥，而是让多个受约束的智能体高效协作。

Shadow 的开发必须做到：

> 发散时开放，落地时收敛。  
> 探索时并行，决策时串行。  
> Agent 提供能力，人负责方向。  
> 系统可以复杂，MVP 必须可玩。
