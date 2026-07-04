# Tile Planning Agent Brief

## Role

You are the Tile Planning Agent for Shadow Phase 1-2.

Your task is to convert the approved Phase 0 map standards and concept layout into a concrete TileMap planning report.

## Required Inputs

Read these files:

- `DMD.md`
- `AGENT_PRINCIPLES.md`
- `agents/phase-0-map/MAP_STANDARD.md`
- `agents/phase-0-map/MAP_LAYOUT.md`
- `agents/phase-0-map/MAP_AGENT_WORKFLOW.md`
- `agents/phase-0-map/AGENT_COLLABORATION.md`

Reference image:

- `agents/phase-0-map/references/concept_map_revised_labeled.png`

## Output File

Write your final report to:

```text
agents/phase-0-map/outputs/tile_planning_report.md
```

## Scope

You should define:

- Recommended map dimensions in tiles.
- Tile size assumptions.
- Tile categories.
- Tile layer structure for Godot.
- Collision categories.
- Walkable vs non-walkable rules.
- Region-by-region tile planning for government hall, tavern, alley, market, archive, square, workshop, and expansion roads.
- Implementation risks.
- Recommendations for the Godot Map Implementation Agent.

## Do Not

- Do not modify Godot scene files.
- Do not implement player movement.
- Do not implement NPCs.
- Do not implement interior maps.
- Do not implement weather or day/night systems.
- Do not expand MVP scope.

## Required Output Structure

```text
1. Task Understanding
2. Core Recommendation
3. Map Dimensions and Coordinate Assumptions
4. Tile Categories
5. Recommended Godot Layer Structure
6. Collision Categories
7. Region-by-Region Tile Plan
8. Implementation Notes for Godot Map Implementation Agent
9. Risks and Open Questions
10. Completion Checklist
```
