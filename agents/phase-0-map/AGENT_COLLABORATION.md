# AGENT_COLLABORATION

## 文件目的

本文档定义 Phase 0-2 地图阶段内部 Agent 之间的实际协作协议。

它补充 `MAP_AGENT_WORKFLOW.md`，重点回答：

- Agent 之间如何传递信息
- 哪些 Agent 必须存在
- 哪些 Agent 是可选的
- 输出文件放在哪里
- 冲突如何处理
- 交接时下一个 Agent 需要读什么

## 基本原则

Agent 之间不直接互相指挥，也不通过自由讨论完成协作。

协作路径是：

```text
主 Agent 发 brief
-> 专项 Agent 输出报告
-> 主 Agent 整合
-> 用户确认关键决策
-> 实现 Agent 修改正式项目文件
-> QA Agent 检查
-> 主 Agent 修正、提交、交接
```

## 当前阶段状态

Phase 0 已完成。

已确认：

- 地图标准
- 地图布局
- 概念参考图
- 32x32 tile
- RPG 斜顶式最终落地
- 中等外部小镇地图
- 建筑作为入口地标，不作为完整室内空间
- 树和障碍物应减少，街道和广场应更宽

因此，Phase 1-2 不再默认需要继续发散概念图。

## Phase 1-2 必需 Agent

### 1. Tile Planning Agent

职责：

- 把 `MAP_STANDARD.md`、`MAP_LAYOUT.md` 和概念图转成可实现的 tile 方案
- 定义 tile 类型
- 定义地图层级
- 定义可走/不可走分类
- 定义碰撞对象优先级
- 为 Godot TileSet 和 TileMap 提供实现建议

输入：

- `DMD.md`
- `AGENT_PRINCIPLES.md`
- `agents/phase-0-map/MAP_STANDARD.md`
- `agents/phase-0-map/MAP_LAYOUT.md`
- `agents/phase-0-map/references/concept_map_revised_labeled.png`

输出位置：

```text
agents/phase-0-map/outputs/tile_planning_report.md
```

不允许：

- 修改 Godot 场景
- 修改 TileSet 资源
- 修改产品定位
- 扩大地图阶段范围

### 2. Godot Map Implementation Agent

职责：

- 创建外部地图 Godot 场景
- 创建或导入可用原型 tileset
- 拼出外部小镇 TileMap
- 实现基础碰撞
- 保持正式项目结构清晰

输入：

- `DMD.md`
- `AGENT_PRINCIPLES.md`
- `agents/phase-0-map/MAP_STANDARD.md`
- `agents/phase-0-map/MAP_LAYOUT.md`
- `agents/phase-0-map/outputs/tile_planning_report.md`

正式输出：

```text
scenes/world/town_exterior.tscn
resources/tilesets/town_exterior_tileset.tres
assets/tiles/
```

实现说明输出：

```text
agents/phase-0-map/outputs/godot_map_implementation_report.md
```

不允许：

- 实现玩家移动
- 实现 NPC
- 实现 Agent runtime
- 实现室内地图
- 实现昼夜天气系统
- 修改非地图相关核心文件

### 3. QA / Map Review Agent

职责：

- 检查地图是否符合标准
- 检查道路是否足够宽
- 检查建筑是否过大
- 检查树和装饰是否阻挡移动
- 检查小巷是否像小巷但仍可走
- 检查碰撞是否合理
- 检查 Phase 3 移动引擎能否接入

输入：

- `MAP_STANDARD.md`
- `MAP_LAYOUT.md`
- `tile_planning_report.md`
- `godot_map_implementation_report.md`
- Godot 地图文件

输出位置：

```text
agents/phase-0-map/outputs/map_review_report.md
```

不允许：

- 直接修改 Godot 文件
- 擅自修复实现
- 扩大验收范围

## Phase 1-2 可选 Agent

### Map Blueprint Agent

只在需要重新评估地图布局时启用。

当前默认不启用，因为 `MAP_LAYOUT.md` 已经确定主要布局。

### Visual Reference Agent

只在需要重新生成、重新标注或重新评估概念图时启用。

当前默认不启用，因为参考图已经确认。

### Tile Asset Agent

可在需要更好的原型 tileset 时启用。

如果启用，它只负责素材，不负责地图场景实现。

输出位置：

```text
agents/phase-0-map/outputs/tile_asset_report.md
assets/tiles/
```

## 文件与输出命名

所有专项 Agent 输出必须放在：

```text
agents/phase-0-map/outputs/
```

推荐命名：

```text
tile_planning_report.md
godot_map_implementation_report.md
map_review_report.md
tile_asset_report.md
```

阶段日志放在：

```text
agents/phase-0-map/logs/
```

交接文件放在：

```text
agents/phase-0-map/handoff/
```

## 正式项目文件边界

`agents/phase-0-map/` 是阶段工作区，不是运行时代码目录。

正式 Godot 文件应放在：

```text
scenes/
scripts/
assets/
resources/
```

地图阶段正式文件建议：

```text
scenes/world/town_exterior.tscn
resources/tilesets/town_exterior_tileset.tres
assets/tiles/
```

## 冲突处理

如果 Agent 输出发生冲突：

1. 主 Agent 汇总冲突。
2. 判断冲突属于产品、地图、工程、视觉、碰撞或未来扩展。
3. 主 Agent 给出推荐方案。
4. 必要时交给用户确认。
5. 确认后写入标准或 handoff。

专项 Agent 不得自行合并冲突方案。

## 进入 Phase 3 的交接要求

Phase 0-2 完成时，必须创建：

```text
agents/phase-0-map/handoff/PHASE_0_2_HANDOFF.md
```

必须包含：

- 完成内容
- 修改文件
- 地图尺寸
- tile 尺寸
- 地图场景路径
- TileSet 路径
- 碰撞层说明
- 可走/不可走规则
- 地点位置说明
- Phase 3 移动引擎接入建议
- 不应随意重写的文件
- 已知问题

下一个主 Agent 至少应阅读：

- `DMD.md`
- `AGENT_PRINCIPLES.md`
- `agents/phase-0-map/MAP_STANDARD.md`
- `agents/phase-0-map/MAP_LAYOUT.md`
- `agents/phase-0-map/AGENT_COLLABORATION.md`
- `agents/phase-0-map/handoff/PHASE_0_2_HANDOFF.md`

## 最高原则

Phase 1-2 的目标不是继续发散地图方向，而是把已确认的外部小镇地图变成可运行、可碰撞、可接入移动引擎的 Godot 基础场景。
