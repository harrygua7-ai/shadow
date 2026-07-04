# Phase 0-2 Map Workspace

This folder is the working area for the Phase 0-2 map lead agent.

It is used for planning, notes, agent outputs, references, logs, and handoff documents related to:

- Phase 0: map standards and concept blueprint
- Phase 1: exterior town TileMap
- Phase 2: collision planning and implementation

This folder is not the final runtime location for Godot scenes, scripts, or production assets.

Final project files should live in the shared project structure:

- `scenes/`
- `scripts/`
- `assets/`
- `resources/`

Use this workspace to preserve reasoning, decisions, intermediate outputs, and transition context for later agents.

## Suggested Structure

- `outputs/`: deliverables from sub-agents or planning passes
- `logs/`: chronological notes and decisions
- `references/`: concept prompts, visual references, and source material
- `handoff/`: handoff documents for the next phase lead agent

## Handoff Rule

At the end of Phase 0-2, create a handoff document in `handoff/` describing:

- What was completed
- Which files were created or modified
- Map standards and layout decisions
- Tile and collision rules
- Known issues
- What the next phase agent should do
- Which files should not be casually rewritten
