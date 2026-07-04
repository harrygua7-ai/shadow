# Map Review Checklist

## 1. Task Understanding

This checklist is for reviewing the Phase 1-2 Godot exterior map implementation after it is built.

The review target is the exterior town map only:

- Godot 2D TileMap / TileMapLayer implementation.
- 32x32 pixel tile basis.
- Medium-size exterior town map.
- RPG top-down / three-quarter RPG-style playable layout.
- Exterior locations: public square, tavern, alley, market / shop street, government hall, archive, workshop, future expansion roads.
- Basic world collision implementation.

This checklist does not review player movement implementation, NPCs, interior maps, agent runtime, weather, day-night behavior, UI systems, or location entry logic.

## 2. Review Checklist

### MAP_STANDARD Compliance

- [ ] The map is implemented as a Godot 2D TileMap / TileMapLayer, not as one flat background image.
- [ ] Tile size is based on 32x32 pixels.
- [ ] The map reads as a mature, warm, civic, slightly mysterious pixel town rather than a generic RPG dungeon, childish village, cyberpunk scene, or brand showroom.
- [ ] The implementation represents an exterior town map, not an interior scene or UI menu.
- [ ] Buildings function as exterior landmarks / future entrances, not as oversized playable interiors.
- [ ] The map avoids baking labels into tile art; location names should remain future Godot Label/UI responsibility.
- [ ] Day-night and weather are not implemented in Phase 1-2, but the map leaves room for future lamps, window lights, color overlays, and weather particles.

### MAP_LAYOUT Compliance

- [ ] Public square is near the center and acts as a connective civic space.
- [ ] Government hall is positioned in the upper-left / civic-order side of the map.
- [ ] Tavern is near the upper-center / upper-left social area and close enough to the alley.
- [ ] Alley is between or near tavern and market, reads as a narrow side passage, and is still walkable.
- [ ] Market / shop street is on the upper-right / trade side and has clear shopping identity.
- [ ] Archive is in the lower-left / quieter memory-oriented side.
- [ ] Workshop is in the lower-right / production side and has clear crafting identity.
- [ ] Future expansion road(s) exist at one or more map edges and are visibly blocked or unfinished.
- [ ] Core road connections are readable: government hall to square, tavern to square, tavern to alley to market, market to square, archive to square, workshop to square, workshop to market, square to expansion road.

### Building Size And Street Width

- [ ] Buildings are smaller than the earlier concept problem case and do not dominate the map.
- [ ] Every major building has a clear door / front approach area.
- [ ] Door/front approach areas have enough open space for future player stopping, NPC placement, and interaction prompts.
- [ ] Main roads are wide enough for future WASD movement and should not feel like single-file corridors.
- [ ] Public square is open enough to support future NPCs, event markers, and user movement without becoming crowded.
- [ ] Market has a wide central walking lane; stalls are mostly placed to the side.
- [ ] Workshop materials and props are placed along edges or inside visually bounded work areas, not across main paths.
- [ ] Government hall, archive, and workshop each have exterior grounds without blocking the main circulation.

### Tree / Decoration Obstruction Risk

- [ ] Trees are reduced compared with the first concept direction and do not crowd the center routes.
- [ ] Trees do not block main roads, doors, stairways, or the public square.
- [ ] Lamps, benches, boxes, barrels, and signs add life but do not create accidental maze-like navigation.
- [ ] Decoration density is highest at edges and low-risk areas, not in primary walking corridors.
- [ ] Alley props make the alley feel real but do not make the walkable path unclear.
- [ ] Market props support trade identity but do not turn the area into an obstacle field.
- [ ] Any decorative object with collision has an obvious visual body that matches the collision footprint.

### Collision Realism

- [ ] Building bodies are not walkable.
- [ ] Walls, fences, large props, water, cliffs, and blocked roads are not walkable.
- [ ] Trees have collision where their trunk/body blocks movement, but collision should not feel much larger than the visible obstacle.
- [ ] Road, square, door approach, stairs/steps intended as paths, and alley center path are walkable.
- [ ] Stall bodies and large workshop material piles block movement; stall-front browsing space remains walkable.
- [ ] Lamp collision is either absent or very small; lamps must not snag future movement unnecessarily.
- [ ] Collision boundaries follow visible art closely enough that players will not feel blocked by invisible walls in normal walkable space.
- [ ] Blocked future expansion roads are visibly blocked and have matching collision.
- [ ] Water / edge boundaries prevent leaving the map where appropriate.

### Future Phase 3 Movement Engine Readiness

- [ ] The map has obvious open areas for dropping in a temporary player marker.
- [ ] Main paths are wide enough to test WASD movement without immediate frustration.
- [ ] Collision is already present on world obstacles so Phase 3 can test real movement, not only empty-map movement.
- [ ] Map edges and blocked roads are defined clearly enough for future camera/map boundary handling.
- [ ] The map has no unavoidable one-tile choke points on required routes.
- [ ] The alley may be narrow, but should still allow comfortable future movement and collision testing.
- [ ] There is enough open space near tavern, market, square, archive, government hall, and workshop to test approach behavior later.

### Godot File Organization

- [ ] Exterior map scene exists at `scenes/world/town_exterior.tscn`.
- [ ] TileSet resource exists at `resources/tilesets/town_exterior_tileset.tres` or an explicitly documented equivalent path.
- [ ] Tile art / temporary prototype tile assets are stored under `assets/tiles/` or a clearly named subfolder.
- [ ] Process notes and implementation reports are stored under `agents/phase-0-map/outputs/`, not mixed into runtime scene directories.
- [ ] The implementation does not place final runtime Godot files inside `agents/phase-0-map/`.
- [ ] Existing root files such as `DMD.md`, `AGENT_PRINCIPLES.md`, and Phase 0 standards are not rewritten unnecessarily.
- [ ] The implementation report identifies all modified files.

### TileSet Maintainability

- [ ] Tile categories are understandable: ground, roads, square paving, buildings, doors/steps, vegetation, decorations, boundaries, blocked roads.
- [ ] Walkable and non-walkable tile types are easy to distinguish during editing.
- [ ] Collision-bearing tiles are named, grouped, or documented clearly enough for future agents.
- [ ] The TileSet avoids one-off special tiles where reusable tiles would work.
- [ ] Temporary prototype art is acceptable quality, not pure-color whitebox blocks, and still readable as a town.
- [ ] The tiles are not so visually busy that future labels, player marker, NPCs, or interaction hints would be unreadable.
- [ ] The tile system can later support lamp/window variants for day-night effects without remaking the whole map.

## 3. Critical Failure Conditions

The map should not be accepted for Phase 3 if any of these are true:

- The exterior map is a single static image rather than a usable TileMap / TileMapLayer.
- There is no actual world collision on buildings and major obstacles.
- Buildings are so large that streets and square movement feel secondary.
- Trees, stalls, lamps, or props block major routes or make the map feel like a maze.
- The alley does not read as an alley, or it is too blocked/narrow to support future movement.
- The market, tavern, government hall, archive, workshop, and public square cannot be visually distinguished.
- Door/front approach positions are unclear for future entrance and interaction work.
- Required files are scattered in unclear locations or final runtime assets are stored only under `agents/`.
- The implementation adds out-of-scope systems such as player movement, NPC logic, interior scenes, weather, day-night runtime, or agent runtime without explicit approval.
- The implementation changes product direction by making the map feel like a generic RPG quest town instead of Shadow's warm, civic, slightly mysterious community world.

## 4. Recommended Manual Test Pass

Use this after the implementation exists.

1. Open the Godot project.
2. Open `scenes/world/town_exterior.tscn`.
3. Confirm the scene loads without missing resources or broken dependencies.
4. Visually scan the map at full view:
   - Confirm all required locations exist.
   - Confirm location layout roughly follows `MAP_LAYOUT.md`.
   - Confirm the map looks like one coherent town exterior.
5. Zoom into each district:
   - Government hall.
   - Tavern.
   - Alley.
   - Market / shop street.
   - Archive.
   - Public square.
   - Workshop.
   - Future expansion road(s).
6. Check walkability visually:
   - Main roads are wide.
   - Square is open.
   - Doors have approach space.
   - Alley is narrow but readable.
   - Props do not block primary paths.
7. Check collision setup in editor:
   - Buildings and barriers have collision.
   - Walkable roads and square do not have accidental collision.
   - Tree / prop collision footprints are not oversized.
   - Blocked expansion roads have collision.
8. Check file organization:
   - Scene, TileSet, and assets are in approved project directories.
   - Agent notes remain in `agents/phase-0-map/`.
9. Read implementation report:
   - Confirm modified files are listed.
   - Confirm known issues are documented.
10. Record any issues in `agents/phase-0-map/outputs/map_review_report.md` when the actual review is performed.

## 5. Phase 3 Readiness Criteria

The map is ready for Phase 3 movement engine work only if:

- `town_exterior.tscn` can be opened in Godot.
- The map is laid out as a coherent exterior town TileMap.
- Collision exists for buildings, boundaries, trees/major props, and blocked roads.
- The main circulation routes are wide enough for WASD movement tests.
- The public square is open enough to test camera and player movement comfortably.
- The alley is narrow but passable.
- Each major location has a clear future approach/entrance area.
- The map does not require player movement code to be rewritten around bad collision or cramped layout.
- The implementation report documents the scene path, TileSet path, asset path, collision assumptions, and known risks.

## 6. Notes for Main Agent

- This checklist is a preparation document, not a review of a completed implementation.
- During actual review, create a separate `map_review_report.md` rather than editing this checklist into a report.
- The most important product risk is cramped navigation. Shadow's exterior map should feel like a social world with room to move, not a decorative painting full of blockers.
- The most important engineering risk is collision mismatch. If visible art and collision disagree, Phase 3 movement testing will produce misleading results.
- The current reference image is useful for location identity and layout, but the Godot implementation should simplify it where needed for movement clarity.
- Favor readable, maintainable prototype art over highly detailed but hard-to-edit tiles.
