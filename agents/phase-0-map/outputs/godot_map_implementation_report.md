# Godot Map Implementation Report

## 1. Task Understanding

Implemented the Shadow Phase 1-2 exterior town map only.

Scope followed:

- Exterior town map.
- `80 x 60` logical tiles.
- `32 x 32 px` tile basis.
- Prototype pixel-art tiles, not pure whitebox color blocks.
- Required exterior regions represented:
  - public square
  - government hall
  - tavern
  - alley
  - market / shop street
  - archive
  - workshop
  - future expansion roads
- Basic world collision for non-walkable surfaces.
- Future door approach positions and location marker nodes.

Explicitly not implemented:

- player movement
- camera
- NPCs
- interiors
- weather or day-night runtime
- entrance triggers
- location UI
- agent runtime

## 2. Files Created or Modified

Created:

```text
scenes/world/town_exterior.tscn
resources/tilesets/town_exterior_tileset.tres
assets/tiles/town_exterior/town_exterior_tiles.png
assets/tiles/town_exterior/town_map_generator.gd
assets/tiles/town_exterior/town_map_generator.gd.uid
agents/phase-0-map/outputs/godot_map_implementation_report.md
```

The generator script is included so the prototype map, TileSet, and atlas can be regenerated or inspected by later agents. It is not used by the running scene.

## 3. Implementation Summary

The implementation creates a Godot 4.7 scene at:

```text
scenes/world/town_exterior.tscn
```

Scene root:

```text
TownExterior
```

Important children:

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

The map uses Godot `TileMapLayer` nodes with a shared TileSet resource.

The scene references the external TileSet at:

```text
res://resources/tilesets/town_exterior_tileset.tres
```

The root node includes metadata:

```text
map_size_tiles = Vector2i(80, 60)
tile_size_px = 32
phase_scope = Phase 1-2 exterior map only...
```

## 4. Map Layout Summary

The map follows the approved Phase 0 layout:

- Government hall: upper-left civic/order area.
- Tavern: upper-center social area.
- Alley: between tavern and market, visually darker and narrower.
- Market / shop street: upper-right trade area.
- Public square: central civic connector.
- Archive: lower-left quiet memory area.
- Workshop: lower-right production/crafting area.
- Expansion roads: north, east, and south edges, visually blocked.

Main routes are intentionally wide:

- Main roads are approximately `5-7 tiles` wide.
- Public square is broad and open.
- Market stalls sit mostly along edges.
- Alley remains narrow, but the center path is wider than a one-tile choke.
- Trees and decorative blockers are sparse and kept away from primary routes.

## 5. Tile / Visual Asset Summary

Tile atlas:

```text
assets/tiles/town_exterior/town_exterior_tiles.png
```

TileSet:

```text
resources/tilesets/town_exterior_tileset.tres
```

The atlas includes readable prototype pixel tiles for:

- grass
- grass variation
- stone road
- square paving
- alley paving
- market paving
- workshop ground
- archive path
- government courtyard
- walls
- roofs
- doors
- windows
- steps
- trees / shrubs
- lamps
- benches
- notice board
- crates / barrels
- market stalls
- fences
- roadblocks
- shadow patches
- workshop material piles
- sign bases
- chimney
- flags
- edge vegetation

The tile art is prototype quality. It is meant to be readable and replaceable, not final production art.

## 6. Collision Implementation

World collision is implemented as explicit `StaticBody2D` nodes under:

```text
TownExterior/WorldCollision
```

Collision layer:

```text
Layer 2: WorldCollision
```

Collision is present for:

- building bodies
- alley side walls
- map edges
- blocked expansion roads
- selected tree footprints
- market stalls
- workshop material piles

Known implementation choice:

Collision is not embedded inside individual TileSet tile definitions yet. It is implemented as inspectable rectangular collision bodies aligned to the tile grid. This avoids brittle hand-authored TileSet collision resource data and gives Phase 3 a clear, working world collision layer for movement testing.

Phase 3 can later decide whether to keep these explicit collision bodies, convert collision into TileSet physics polygons, or use a hybrid.

## 7. How to Open / Inspect

Open the Godot project, then open:

```text
scenes/world/town_exterior.tscn
```

Useful inspection points:

- Check `TileMapLayer` nodes to inspect map layers.
- Check `WorldCollision` to inspect collision rectangles.
- Check `LocationMarkers` for future location approach anchors.
- Check `assets/tiles/town_exterior/town_exterior_tiles.png` to inspect the prototype atlas.
- Check `resources/tilesets/town_exterior_tileset.tres` to inspect the generated TileSet.

Headless load check performed:

```text
/Applications/Godot.app/Contents/MacOS/Godot --headless --path /Users/alex/Desktop/区域/shadow res://scenes/world/town_exterior.tscn --quit-after 1
```

Result:

```text
Scene loaded successfully.
```

## 8. Known Deviations from Brief

The brief requested a Godot TileMap / TileSet implementation. This was implemented with `TileMapLayer` nodes and a TileSet resource.

Deviation:

- Collision is implemented as explicit `StaticBody2D` rectangles under `WorldCollision`, not as embedded TileSet collision polygons.

Reason:

- TileSet collision data is more brittle to hand-author.
- Explicit collision bodies are easier for Phase 3 movement testing.
- The collision layer remains inspectable and aligned to the tile map.

Additional implementation artifact:

- `assets/tiles/town_exterior/town_map_generator.gd` is included as a generator/provenance script. It can be deleted later if the team wants only final assets in `assets/tiles/`.

## 9. Known Issues

- Prototype tiles are readable but not final art.
- The TileSet resource embeds a generated texture for reliable loading; the PNG atlas also exists for visual inspection, and the scene references the external TileSet resource instead of embedding a duplicate TileSet.
- No manual QA pass has been run in the interactive Godot editor yet.
- No movement engine exists yet, so collision has not been tested with WASD movement.
- Location names are not displayed, by design; future phases should use Godot Label/UI.
- Entrance positions are markers only; no triggers are implemented.

## 10. Phase 3 Handoff Notes

Phase 3 movement work should start by opening:

```text
scenes/world/town_exterior.tscn
```

Recommended Phase 3 steps:

1. Add a temporary player scene or player marker.
2. Put the player on collision layer 1 and collide against layer 2.
3. Test WASD movement through:
   - public square
   - tavern approach
   - alley center path
   - market lane
   - archive approach
   - workshop approach
   - government hall approach
4. Tune movement speed and player collision shape.
5. Adjust `WorldCollision` rectangles if any visible path feels blocked or any obstacle can be crossed.

Important anchors:

```text
LocationMarkers/GovernmentHallMarker
LocationMarkers/TavernMarker
LocationMarkers/AlleyMarker
LocationMarkers/MarketMarker
LocationMarkers/ArchiveMarker
LocationMarkers/WorkshopMarker
LocationMarkers/SquareMarker
LocationMarkers/ExpansionNorthMarker
LocationMarkers/ExpansionEastMarker
LocationMarkers/ExpansionSouthMarker
```

Do not treat these markers as entrance triggers yet. They are future approach positions only.
