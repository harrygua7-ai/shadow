# Map Review Report

Date: 2026-07-04
Reviewer: Main Coordination Agent
Scope: Phase 1-2 exterior town map implementation review

## 1. Review Result

Status: Accepted as Phase 1-2 baseline.

The Godot implementation creates a real exterior town scene with map scale, visual tile layers, region markers, and collision blockers. It is suitable as the foundation for the next phase: player movement and camera testing.

## 2. Files Reviewed

```text
scenes/world/town_exterior.tscn
resources/tilesets/town_exterior_tileset.tres
assets/tiles/town_exterior/town_exterior_tiles.png
assets/tiles/town_exterior/town_map_generator.gd
assets/tiles/town_exterior/town_map_generator.gd.uid
agents/phase-0-map/outputs/godot_map_implementation_report.md
```

## 3. Checks Passed

### Project Load

Godot headless scene load passed:

```text
Godot Engine v4.7.stable.mono.official.5b4e0cb0f
```

### Map Scale

The scene metadata includes the approved map basis:

```text
map_size_tiles = Vector2i(80, 60)
tile_size_px = 32
```

### Scene Structure

The map uses multiple `TileMapLayer` nodes instead of one flattened layer:

```text
GroundBaseLayer
RoadLayer
GroundDetailLayer
BuildingBaseLayer
BuildingRoofLayer
PropBackLayer
PropFrontLayer
BoundaryLayer
WorldCollision
LocationMarkers
```

This is acceptable for Phase 1-2 because later agents can inspect, replace, or tune individual map layers without rewriting the whole scene.

### Required Exterior Regions

The scene includes location markers for the required MVP exterior areas:

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

These markers give the next phase a stable way to locate important places even before entrance triggers or UI labels are implemented.

### Collision

Collision is implemented under:

```text
TownExterior/WorldCollision
```

Observed collision bodies:

```text
32 StaticBody2D nodes
32 CollisionShape2D nodes
```

The blockers cover buildings, map edges, expansion roadblocks, trees, market stalls, workshop piles, and alley walls. This is enough for Phase 3 movement testing.

### Scope Discipline

The implementation does not add player movement, camera logic, NPCs, agent runtime, interiors, weather, day-night runtime, or entrance triggers. This matches the agreed Phase 1-2 boundary.

## 4. Notes And Risks

### Prototype Art

The atlas is readable and usable for testing, but it is not final art:

```text
assets/tiles/town_exterior/town_exterior_tiles.png
```

This is acceptable because the goal of this phase is map structure and collision, not production visual polish.

### Collision Method

Collision uses explicit `StaticBody2D` rectangles rather than TileSet-embedded collision shapes. This is acceptable for this phase because it is very easy to inspect and adjust during movement testing.

Later, if the map grows much larger, we may move static collision into TileSet terrain rules or a generated collision layer to reduce manual scene noise.

### Naming

Some node names differ slightly from earlier planning language. For example, the base layer is named `GroundBaseLayer` instead of `GroundLayer`, and region identity is represented through marker nodes such as `TavernMarker` and `SquareMarker`.

This is acceptable, but future agents should treat the implementation report and this review report as the source of truth for the actual Godot scene structure.

### Door Positions

The scene has location markers and visually readable building fronts, but no entrance hot zones or door trigger nodes yet. This is intentional and should be handled in a later phase.

## 5. Recommendation

Proceed to Phase 3 after this commit:

```text
Phase 3: player movement, camera follow, collision feel test, and basic debug readouts.
```

Phase 3 should use `scenes/world/town_exterior.tscn` directly, test movement against `WorldCollision`, and report any blockers that feel too tight or any roads that need widening.
