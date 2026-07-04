# QA / Map Review Agent Brief

## Role

You are the QA / Map Review Agent for Shadow Phase 1-2.

Your current task is to prepare a review checklist for the upcoming Godot exterior map implementation.

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

Write your final checklist to:

```text
agents/phase-0-map/outputs/map_review_checklist.md
```

## Scope

Prepare a checklist to evaluate whether the Phase 1-2 map implementation is acceptable.

The checklist should cover:

- MAP_STANDARD compliance.
- MAP_LAYOUT compliance.
- Building size and street width.
- Tree/decoration obstruction risk.
- Collision realism.
- Future Phase 3 movement engine readiness.
- Godot file organization.
- TileSet maintainability.
- Risks that would cause rework.

## Do Not

- Do not modify Godot files.
- Do not implement map features.
- Do not change product direction.
- Do not expand beyond Phase 1-2 map and collision review.

## Required Output Structure

```text
1. Task Understanding
2. Review Checklist
3. Critical Failure Conditions
4. Recommended Manual Test Pass
5. Phase 3 Readiness Criteria
6. Notes for Main Agent
```
