# MAP_AGENT_WORKFLOW

## 文件目的

本文档定义 Shadow Phase 0-2 地图阶段的 Agent 协作方式。

它适用于所有参与地图标准、地图蓝图、TileMap、碰撞规则和交接的内部开发 Agent。

## 阶段范围

本工作流覆盖：

- Phase 0：地图标准与概念蓝图
- Phase 1：外部小镇 TileMap
- Phase 2：碰撞规则与实现

不覆盖：

- 玩家移动
- 室内地图
- NPC
- Agent runtime
- 天气系统
- 社会现场
- 用户 Agent

## 主 Agent 职责

Phase 0-2 主 Agent 负责：

- 维护地图方向
- 整合用户反馈
- 创建和维护地图标准文件
- 生成或整理概念图
- 拆分子任务
- 读取子 Agent 输出
- 整合最终方案
- 实现或协调 Godot 地图
- 编写交接文档

主 Agent 不应把产品方向交给子 Agent 决定。

## 工作区

Phase 0-2 工作区：

```text
agents/phase-0-map/
```

推荐结构：

```text
agents/phase-0-map/
  README.md
  MAP_STANDARD.md
  MAP_AGENT_WORKFLOW.md
  MAP_LAYOUT.md
  references/
  outputs/
  logs/
  handoff/
```

用途：

- `references/`：概念图、参考图、提示词
- `outputs/`：子 Agent 输出
- `logs/`：阶段记录和决策日志
- `handoff/`：交接文档

正式 Godot 文件不放在 `agents/` 里。

正式产物应放在：

```text
scenes/
assets/
resources/
scripts/
```

## Agent 分工

### Map Blueprint Agent

职责：

- 提出外部小镇空间布局建议
- 分析地点关系
- 评估道路和广场是否合理
- 找出可能阻碍玩家移动的布局问题

权限：

- 只输出文档
- 不修改 Godot 文件

输出：

```text
1. 布局理解
2. 地点关系建议
3. 道路结构建议
4. 风险点
5. 修改建议
```

### Tile Planning Agent

职责：

- 设计 tile 类型
- 规划 tile 分类
- 规划碰撞类型
- 分析哪些元素可走/不可走
- 为 Godot TileSet 提供结构建议

权限：

- 只输出方案
- 不修改 Godot 文件，除非进入 Phase 1-2 实现阶段时被明确授权

输出：

```text
1. Tile 类型清单
2. 碰撞分类
3. 地图层级建议
4. Godot TileMap 建议
5. 风险点
```

### Visual Reference Agent

职责：

- 生成或优化概念图提示词
- 分析概念图是否符合地图标准
- 标注地点区域
- 判断图像是否适合转成 TileMap

权限：

- 可生成参考图
- 可输出标注图
- 不直接修改正式 Godot 文件

输出：

```text
1. 概念图评价
2. 区域标注
3. 是否适合转 TileMap
4. 修改建议
```

### Godot Map Implementation Agent

职责：

- 创建 Godot 外部地图场景
- 创建或导入 tileset
- 拼接外部地图
- 实现基础碰撞
- 保持项目结构清晰

权限：

- 可修改 Godot 正式文件
- 只允许修改地图相关文件
- 不修改玩家、NPC、Agent、后端相关文件

输出：

```text
1. 修改文件
2. 实现内容
3. 如何打开场景
4. 已知问题
5. 下一阶段接口
```

## 并行与串行规则

### 串行事项

以下事项必须由主 Agent 和用户确认：

- 地图标准
- 概念图是否采用
- 外部地点列表
- 地图大小
- 地点位置
- 最终布局
- 碰撞原则
- Phase 0-2 是否完成

### 可并行事项

以下事项可以并行：

- 概念图分析
- tile 类型规划
- 碰撞分类规划
- 布局风险审查
- 参考图标注
- Godot 实现前的技术方案

### 不允许并行修改

不要让多个 Agent 同时修改：

```text
scenes/world/town_exterior.tscn
resources/tilesets/town_exterior_tileset.tres
```

Godot 场景文件由一个实现 Agent 主导修改。

## 文件修改规则

默认：

- 设计 Agent 不改正式项目文件
- 实现 Agent 只能改授权范围
- 审查 Agent 只检查不修改
- 主 Agent 负责最终合并

任何 Agent 不得擅自：

- 改 `DMD.md`
- 改 `AGENT_PRINCIPLES.md`
- 删除用户确认过的概念图
- 重写非本阶段文件
- 修改 Git 历史
- 引入无关依赖

## 输出格式

所有 Agent 输出应包含：

```text
1. 任务理解
2. 核心结论
3. 具体方案
4. 风险点
5. 需要确认的问题
6. 下一步建议
```

工程实现 Agent 还要包含：

```text
修改文件
实现方式
测试方式
剩余问题
```

## 交接规则

Phase 0-2 结束时必须创建：

```text
agents/phase-0-map/handoff/PHASE_0_2_HANDOFF.md
```

内容包括：

- 完成了什么
- 修改了哪些文件
- 地图标准
- 布局决策
- tile 和碰撞规则
- 概念图位置
- Godot 场景位置
- 后续移动引擎应如何接入
- 哪些文件不要随便重写
- 已知问题

## Git 规则

每个稳定节点应提交一次。

建议提交点：

1. Phase 0 标准文档完成
2. 概念图确认
3. Godot 外部地图初版完成
4. 碰撞实现完成
5. handoff 完成

提交信息应清楚说明阶段内容。

## Phase 0-2 验收

本阶段完成时，必须满足：

- `MAP_STANDARD.md` 存在
- `MAP_LAYOUT.md` 存在
- 概念图参考存在
- 外部地图场景存在
- tile 结构可理解
- 碰撞规则已实现或明确标注
- 下一阶段移动 Agent 能接入测试
