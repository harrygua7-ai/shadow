# Godot Map Implementation Agent Brief

## Role

You are the Godot Map Implementation Agent for Shadow Phase 1-2.

Your task is to implement the exterior town map in Godot using the approved Phase 0 standards and the Tile Planning Agent's report.

## Required Inputs

Read:

- `DMD.md`
- `AGENT_PRINCIPLES.md`
- `agents/phase-0-map/MAP_STANDARD.md`
- `agents/phase-0-map/MAP_LAYOUT.md`
- `agents/phase-0-map/MAP_AGENT_WORKFLOW.md`
- `agents/phase-0-map/AGENT_COLLABORATION.md`
- `agents/phase-0-map/outputs/tile_planning_report.md`
- `agents/phase-0-map/outputs/map_review_checklist.md`

Reference image:

- `agents/phase-0-map/references/concept_map_revised_labeled.png`

## Required Formal Outputs

Create or update:

```text
scenes/world/town_exterior.tscn
resources/tilesets/town_exterior_tileset.tres
assets/tiles/town_exterior/
```

Write implementation report:

```text
agents/phase-0-map/outputs/godot_map_implementation_report.md
```

## Scope

Implement:

- Exterior town map only.
- 80 x 60 tile logical map.
- 32 x 32 tile basis.
- Readable prototype pixel-art tiles, not pure color whitebox blocks.
- Required exterior regions:
  - public square
  - government hall
  - tavern
  - alley
  - market / shop street
  - archive
  - workshop
  - future expansion road(s)
- Basic world collision for non-walkable surfaces.
- Clear future door approach positions, without entrance trigger logic.
- Keep map open enough for Phase 3 WASD movement testing.

## Do Not

- Do not implement player movement.
- Do not implement camera.
- Do not implement NPCs.
- Do not implement interiors.
- Do not implement weather or day/night runtime systems.
- Do not implement location entrance triggers.
- Do not modify unrelated files.
- Do not rewrite `DMD.md`, `AGENT_PRINCIPLES.md`, or Phase 0 standards.

## Write Ownership

You may modify only:

```text
scenes/world/
resources/tilesets/
assets/tiles/town_exterior/
agents/phase-0-map/outputs/godot_map_implementation_report.md
```

You are not alone in the codebase. Do not revert or overwrite others' changes.

## Implementation Guidance

If Godot TileSet authoring through raw `.tres` files is too brittle, create a clear procedural/prototype map scene using Godot-native nodes that still respects the TileMap plan and can be converted to TileMap later. Prefer a working, inspectable Godot scene over fragile hand-authored binary resources.

However, preserve the intended formal output paths and document any deviations clearly.

## Required Report Structure

```text
1. Task Understanding
2. Files Created or Modified
3. Implementation Summary
4. Map Layout Summary
5. Tile / Visual Asset Summary
6. Collision Implementation
7. How to Open / Inspect
8. Known Deviations from Brief
9. Known Issues
10. Phase 3 Handoff Notes
```
