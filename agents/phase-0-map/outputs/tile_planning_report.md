# Tile Planning Report

## 1. Task Understanding

This report converts the approved Phase 0 map standards, layout, and labeled concept reference into an implementation-ready TileMap plan for the Godot Map Implementation Agent.

The scope is limited to Shadow Phase 1-2:

- Phase 1: create the exterior town TileMap.
- Phase 2: implement basic world collision.

This report does not implement Godot files, player movement, interiors, NPCs, entrance logic, day/night, weather, UI, or agent runtime.

The approved direction is:

- Exterior town map only.
- 2D pixel-art RPG top-down/three-quarter style.
- 32 x 32 px tiles.
- Medium map scale.
- Wider streets and clearer walking space.
- Buildings are exterior landmarks and future entrances, not full interior spaces.
- Trees and decorative blockers should be reduced compared to the first concept image.
- Location labels should be Godot Labels later, not baked into tile art.
- Door positions should be visually clear, but no entrance triggers are implemented in Phase 1-2.

Reference image:

```text
agents/phase-0-map/references/concept_map_revised_labeled.png
```

## 2. Core Recommendation

Use an `80 x 60` tile exterior map with `32 x 32 px` tiles.

Final logical map size:

```text
80 tiles wide x 60 tiles high
2560 px wide x 1920 px high
```

Recommended implementation style:

- Use Godot 4 `TileMapLayer` nodes if the project version supports them.
- If using classic `TileMap`, keep equivalent conceptual layers through separate TileMap nodes or tile source organization.
- Build the map from simple but readable prototype pixel tiles, not blank color blocks.
- Prioritize clear movement lanes over decorative density.
- Keep building footprints smaller than the concept art suggests if needed for playability.

Recommended first implementation target:

```text
scenes/world/town_exterior.tscn
resources/tilesets/town_exterior_tileset.tres
assets/tiles/town_exterior/
```

## 3. Map Dimensions and Coordinate Assumptions

Coordinate system:

```text
Origin: top-left tile
X: left to right, 0-79
Y: top to bottom, 0-59
Tile size: 32 x 32 px
```

Approximate region boxes:

```text
Government Hall:       x 05-23, y 05-18
Tavern:                x 28-43, y 07-20
Alley:                 x 44-52, y 09-29
Market / Shop Street:  x 53-76, y 07-27
Public Square:         x 27-53, y 26-42
Archive:               x 07-25, y 39-54
Workshop:              x 55-75, y 39-55
Expansion Roads:       map edges, especially north/east/south
```

These boxes are planning ranges, not strict pixel-perfect requirements. The Godot Map Implementation Agent may adjust them if collision and movement readability improve.

Recommended road widths:

```text
Main roads:       5-7 tiles wide
Secondary roads:  3-5 tiles wide
Alley path:       2-3 tiles wide minimum
Door front pads:  3-5 tiles wide, 2-3 tiles deep
Square open area: at least 16 x 10 walkable tiles
```

Do not make any primary movement path only 1 tile wide.

## 4. Tile Categories

### 4.1 Ground Tiles

Required:

- `grass_base`
- `grass_variation_01`
- `stone_road_base`
- `stone_road_edge`
- `square_paving_base`
- `square_paving_variation`
- `alley_dark_paving`
- `market_paving`
- `workshop_ground`
- `archive_stone_path`
- `government_courtyard_tile`
- `dirt_edge`

Optional but useful:

- `mud_patch`
- `small_crack`
- `loose_stone`
- `drain_cover`
- `shadow_patch`

Collision:

- Ground tiles are walkable by default.
- Decorative ground variants should not add collision.

### 4.2 Road and Path Transition Tiles

Required:

- grass-to-road edges
- road corners
- road T-junctions
- road cross-junctions
- square-to-road transitions
- alley-to-road transition
- market-to-road transition

Collision:

- Walkable.

### 4.3 Building Tiles

Required:

- wall front
- wall side
- roof top
- roof edge
- roof corner
- door closed / doorway visual
- window dark
- window warm-light-ready variant
- stair / step tile
- sign base without baked text

Collision:

- Building body, walls, and roof footprint are non-walkable.
- Doorway visual itself should be non-walkable in Phase 1-2 unless it is part of a walkable front pad.
- Door front pads and steps are walkable.

Important:

- Do not bake Chinese or English location names into the tile art.
- Leave plain sign surfaces for future Godot Labels or UI markers.

### 4.4 Props and Decoration Tiles

Required:

- small tree
- trimmed tree / shrub
- bench
- lamp post
- notice board
- crate
- barrel
- market stall
- canopy / awning
- workshop material pile
- workbench exterior prop
- fence
- roadblock
- small bridge or edge marker if used

Collision:

- Large props should use collision.
- Small visual clutter should usually have no collision if it would harm walking feel.
- Avoid continuous prop walls unless intentionally forming boundaries.

### 4.5 Boundary Tiles

Required:

- map edge vegetation
- low wall
- fence
- blocked road marker
- construction barrier
- shadow edge / inaccessible edge

Optional:

- water edge
- rock edge
- broken bridge

Collision:

- Boundary tiles are non-walkable.

### 4.6 Light-Ready Tiles

Phase 1-2 does not implement day/night, but the map should include light anchor visuals:

- lamp post base
- window tile that can be paired with future light
- tavern warm window
- market lantern post
- workshop furnace/window marker

Collision:

- Lamp post base non-walkable if occupying a tile.
- Window and wall light visuals inherit building collision.

## 5. Recommended Godot Layer Structure

Use separate layers so Phase 3 movement and later visual systems can work cleanly.

Recommended `TileMapLayer` structure:

```text
TownExteriorRoot
  GroundBaseLayer
  GroundDetailLayer
  RoadLayer
  BuildingBaseLayer
  BuildingRoofLayer
  PropBackLayer
  PropFrontLayer
  BoundaryLayer
  CollisionOverlayLayer (optional debug/planning only)
  LocationMarkers (Node2D, no entrance logic yet)
```

### GroundBaseLayer

Purpose:

- Grass, base terrain, broad ground color.

Collision:

- None.

### RoadLayer

Purpose:

- Main roads, square paving, market street, alley path, door pads.

Collision:

- None.

### GroundDetailLayer

Purpose:

- Cracks, dirt, small non-blocking texture details.

Collision:

- None.

### BuildingBaseLayer

Purpose:

- Building footprints, walls, doors, steps.

Collision:

- Building body and walls should collide.
- Steps and door front pads should not collide.

### BuildingRoofLayer

Purpose:

- Roofs and upper building visual parts.

Collision:

- Usually no separate collision if BuildingBase already blocks the footprint.
- Use visual-only unless a roof tile extends into a blocked footprint not covered by BuildingBase.

### PropBackLayer

Purpose:

- Props visually behind the player path: trees, walls, background stalls.

Collision:

- Only if physically blocking movement.

### PropFrontLayer

Purpose:

- Props that should render in front of the player later: lamp posts, benches, stall fronts, barrels.

Collision:

- Collision according to prop type.

### BoundaryLayer

Purpose:

- Edge blockers, roadblocks, construction barriers, inaccessible edges.

Collision:

- Non-walkable.

### LocationMarkers

Purpose:

- Store future location positions without implementing triggers.

Suggested child nodes:

```text
LocationMarkers
  GovernmentHallMarker
  TavernMarker
  AlleyMarker
  MarketMarker
  ArchiveMarker
  WorkshopMarker
  SquareMarker
  ExpansionNorthMarker
  ExpansionEastMarker
  ExpansionSouthMarker
```

These should be plain `Marker2D` or `Node2D` nodes in Phase 1-2. Do not add `Area2D` entrance triggers yet.

## 6. Collision Categories

Use the project collision-layer naming from `MAP_STANDARD.md` and `MAP_LAYOUT.md`.

Recommended future layers:

```text
Layer 1: Player
Layer 2: WorldCollision
Layer 3: LocationTrigger
Layer 4: NPC
Layer 5: InteractionObject
```

Phase 2 implements only:

```text
WorldCollision
```

### Collision Category A: Walkable

Examples:

- roads
- square paving
- open grass
- door front pads
- steps
- alley center path
- market walkway

Collision:

- None.

### Collision Category B: Full-Block

Examples:

- building body
- walls
- boundary fences
- water
- roadblocks
- large market stalls
- major workshop material piles

Collision:

- Full tile or rectangle collision.

### Collision Category C: Footprint Block

Examples:

- tree trunks
- lamp post bases
- barrels
- crates
- bench legs
- small signs

Collision:

- Smaller collision shape than the full tile where possible.
- Prefer lower-footprint collision for RPG-style readability.

### Collision Category D: Visual-Only

Examples:

- grass details
- road cracks
- shadows
- window lights
- light stains
- small leaves
- tiny stones

Collision:

- None.

### Collision Category E: Future Trigger Placeholder

Examples:

- door fronts
- alley entry mouth
- expansion road gate

Collision:

- No trigger implementation in Phase 1-2.
- Mark position only through `LocationMarkers`.

## 7. Region-by-Region Tile Plan

### 7.1 Public Square

Approximate range:

```text
x 27-53, y 26-42
```

Tile plan:

- Use `square_paving_base` as the main tile.
- Add subtle paving variations, but keep visual noise low.
- Place a central civic marker or notice board, but keep it small.
- Preserve a large open walkable area.
- Connect roads to government hall, tavern, market, archive, workshop, and expansion roads.

Collision:

- Square ground walkable.
- Notice board or central marker may have small footprint collision.
- Avoid blocking the square with trees or benches.

Implementation note:

- The square is the main future event space. Leave enough room for later NPCs, event markers, and user presence.

### 7.2 Government Hall

Approximate range:

```text
x 05-23, y 05-18
```

Tile plan:

- Use `government_courtyard_tile` in front.
- Building footprint should be formal but not oversized.
- Suggested building body size: around `10-14 tiles wide x 6-8 tiles tall`.
- Add clear steps and a front pad facing the main road or square.
- Add 1-2 flags, lamp posts, or formal props, not dense decoration.

Collision:

- Building body non-walkable.
- Steps and front pad walkable.
- Lamp bases small footprint collision.

Implementation note:

- Avoid castle-like proportions. It should read as civic architecture, not fantasy palace.

### 7.3 Tavern

Approximate range:

```text
x 28-43, y 07-20
```

Tile plan:

- Medium-small building with warm character.
- Suggested building body size: around `9-12 tiles wide x 6-8 tiles tall`.
- Add clear door, front pad, and optional 1-2 outdoor tables to one side.
- Keep enough street width between tavern and square road.
- Place tavern close to alley entrance, but not blocking it.

Collision:

- Building body non-walkable.
- Outdoor tables may have collision if large, but keep them off the main path.
- Door pad walkable.

Implementation note:

- Tavern should be recognizable but must not dominate the exterior map.

### 7.4 Alley

Approximate range:

```text
x 44-52, y 09-29
```

Tile plan:

- Use `alley_dark_paving`.
- Place walls/building sides on both sides.
- Add crates, barrels, pipes, side doors, and stronger shadow patches.
- Keep center passage at least `2-3 tiles` wide.
- Connect tavern side to market side.

Collision:

- Side walls non-walkable.
- Crates/barrels should not reduce the passage below 2 tiles.
- Shadow patches visual-only.

Implementation note:

- The alley must clearly look like an alley, but movement must remain comfortable.
- Do not turn the alley into a maze.

### 7.5 Market / Shop Street

Approximate range:

```text
x 53-76, y 07-27
```

Tile plan:

- Use `market_paving`.
- Include small stalls, awnings, and shop fronts.
- Keep a central market walkway at least `5 tiles` wide.
- Put stalls along the sides rather than in the road center.
- Market can have multiple small structures, but none should be too large.

Collision:

- Stall bodies non-walkable.
- Walkway fully walkable.
- Small props near stalls may have smaller footprint collision.

Implementation note:

- Market should look active but must not become an obstacle field.

### 7.6 Archive

Approximate range:

```text
x 07-25, y 39-54
```

Tile plan:

- Use `archive_stone_path` from square to archive door.
- Building should feel quiet, formal, and memory-oriented.
- Suggested building body size: around `10-12 tiles wide x 6-8 tiles tall`.
- Add a few trees or shrubs, but keep them away from the door path.
- Use more ordered paving and less clutter.

Collision:

- Building body non-walkable.
- Trees/shrubs collision only on trunks/footprints.
- Main path walkable.

Implementation note:

- Archive can be calmer and slightly separated, but not hidden.

### 7.7 Workshop

Approximate range:

```text
x 55-75, y 39-55
```

Tile plan:

- Use `workshop_ground`.
- Include exterior workbench, tool rack, material piles, smoke stack/furnace visual.
- Suggested building body size: around `10-14 tiles wide x 6-8 tiles tall`.
- Keep materials along edges.
- Leave a walkable route toward market and square.

Collision:

- Building body non-walkable.
- Large material piles non-walkable.
- Small decorative tools visual-only where possible.

Implementation note:

- Workshop should support future creation mechanics, so leave exterior staging space.

### 7.8 Expansion Roads

Approximate locations:

```text
North edge: x 35-45, y 00-05
East edge:  x 75-79, y 25-35
South edge: x 35-48, y 55-59
```

Tile plan:

- Continue road tiles toward edges.
- Block with construction barrier, low fence, broken bridge, or shadow gate.
- Keep visual promise of future expansion.

Collision:

- Roadblock/boundary non-walkable.
- Road before blockade walkable.

Implementation note:

- Do not implement area transition.
- Do not add trigger logic.

## 8. Implementation Notes for Godot Map Implementation Agent

### 8.1 Recommended Build Order

1. Create `scenes/world/town_exterior.tscn`.
2. Create or import `resources/tilesets/town_exterior_tileset.tres`.
3. Create `assets/tiles/town_exterior/` for prototype pixel tiles.
4. Add layer nodes in the recommended order.
5. Block out the `80 x 60` map with ground and roads.
6. Place public square and main roads.
7. Place building footprints.
8. Place door pads and visual entrances.
9. Place alley walls and path.
10. Add sparse trees, lamps, benches, stalls, and props.
11. Add boundary / expansion road blockers.
12. Add collision to blocking tiles.
13. Add `LocationMarkers` as marker nodes only.

### 8.2 Prototype Art Quality

Use readable prototype pixel art, not blank color rectangles.

Minimum visual readability:

- road vs grass clearly distinct
- buildings visibly different by region
- alley visibly darker and narrower
- market has stalls/awnings
- government hall looks civic
- archive looks formal/quiet
- workshop looks craft/production-oriented

Do not over-polish before collision and movement testing.

### 8.3 Road and Walkability Checks

Before handing off to movement:

- Main road should support a future player sprite plus NPC traffic.
- Main roads should not have single-tile choke points.
- Alley should be narrow but not frustrating.
- Door front pads should have enough space for future interaction prompts.
- Props should not trap the future player.

### 8.4 Collision Implementation Guidance

Prefer collision on tiles through the TileSet where repeated.

Use manual `StaticBody2D` or collision shapes only for unusual composite objects if TileSet collision is insufficient.

Avoid oversized collisions on:

- trees
- lamp posts
- benches
- crates

Oversized collisions will make Phase 3 movement feel bad.

### 8.5 Location Markers

Create non-trigger marker nodes at approximate future interaction points:

```text
GovernmentHallMarker
TavernMarker
AlleyMarker
MarketMarker
ArchiveMarker
WorkshopMarker
SquareMarker
ExpansionNorthMarker
ExpansionEastMarker
ExpansionSouthMarker
```

These markers are for future phases only. They should not open UI, switch scenes, or handle input in Phase 1-2.

## 9. Risks and Open Questions

### Risk 1: Concept Art Does Not Translate Directly to TileMap

The concept reference is a direction, not a 1:1 map. The implementation should preserve spatial relationships and mood while simplifying shapes into tile-friendly forms.

Recommendation:

- Use the coordinate boxes in this report as implementation scaffolding.
- Prioritize movement space over exact concept art shape.

### Risk 2: Buildings May Still Become Too Large

Large buildings will damage walking feel.

Recommendation:

- Keep buildings as exterior landmarks.
- Use doors, signs, roofs, and silhouettes for identity instead of large footprints.

### Risk 3: Alley May Become Too Narrow

The alley needs to look like an alley but still be playable.

Recommendation:

- Minimum center passage: 2 tiles.
- Preferred center passage: 3 tiles.
- Place clutter along walls only.

### Risk 4: Market Can Become Too Dense

Stalls can accidentally turn the market into an obstacle maze.

Recommendation:

- Put stalls on sides.
- Keep central lane 5 tiles wide.

### Risk 5: Collision May Need Phase 3 Tuning

Without a movement engine, Phase 2 collision can only be approximate.

Recommendation:

- Implement reasonable collision now.
- Expect collision-size tuning after Phase 3 movement testing.

### Open Question 1: Exact Godot Version

If using Godot 4.3/4.4+, `TileMapLayer` is preferred. If using an older project setup, separate `TileMap` nodes can approximate the same structure.

### Open Question 2: Prototype Tileset Source

The Godot Map Implementation Agent must decide whether to:

- draw simple prototype tiles directly,
- generate a temporary tilesheet and slice it,
- or build tiles procedurally in-editor.

Recommendation:

- Use a simple custom prototype tileset under `assets/tiles/town_exterior/`, with enough visual quality to judge layout.

## 10. Completion Checklist

Tile Planning completion:

- [x] Map dimensions recommended.
- [x] Tile size confirmed.
- [x] Coordinate assumptions defined.
- [x] Tile categories defined.
- [x] Godot layer structure recommended.
- [x] Collision categories defined.
- [x] Region-by-region plan provided.
- [x] Implementation notes provided for Godot Map Implementation Agent.
- [x] Risks and open questions listed.

Godot Map Implementation Agent should complete:

- [ ] Create `scenes/world/town_exterior.tscn`.
- [ ] Create `resources/tilesets/town_exterior_tileset.tres`.
- [ ] Create prototype tile assets under `assets/tiles/town_exterior/`.
- [ ] Build an `80 x 60` exterior town map.
- [ ] Include government hall, tavern, alley, market, archive, public square, workshop, and expansion roads.
- [ ] Keep roads and square wide enough for future WASD movement.
- [ ] Implement basic `WorldCollision`.
- [ ] Add non-trigger location markers.
- [ ] Do not implement player movement, interiors, NPCs, day/night, weather, or entrance logic.
