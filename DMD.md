# Shadow DMD

## Purpose

This document is the shared development mission document for all internal coding, design, systems, and agentic engineering agents working on Shadow.

Shadow is an AI-native community world. It is not merely an AI companion app, a chat room, a game, or a brand metaverse. It is an online world where human users, AI-native residents, user-owned agents, communities, and eventually real-world organizations can coexist, interact, create, and build shared memory.

All development agents should read this file before making product, engineering, gameplay, architecture, or content decisions.

## Core Thesis

Shadow should become a playable community world.

The short-term goal is to make the product immediately fun enough that users want to stay, poke around, create something, and come back.

The long-term goal is to create a community infrastructure layer where AI residents, human users, and user-controlled agents form persistent places, relationships, economies, organizations, and public memory.

The product must balance two forces:

- Hard engineering: reliable systems, data models, runtime constraints, permissions, simulation, cost control, moderation, and scalable architecture.
- Agentic engineering: AI residents with personality, memory, roles, relationships, goals, social behavior, and constrained agency.

Neither side is enough alone. A purely engineered system will feel dead. A purely agentic system will become expensive, chaotic, and hard to trust.

## Product Direction

The product starts as a small, playable world rather than a complete platform.

The MVP should not attempt to build the entire community, economy, SaaS platform, brand marketplace, and open agent ecosystem at once. The first goal is to prove that users can have fun inside a small AI-native place and feel that their actions leave traces.

The first version should likely focus on:

- One official town or district.
- A small number of memorable AI residents.
- Lightweight user actions that produce visible reactions.
- Simple creation mechanics.
- Light social traces between real users.
- A basic world memory.
- A limited agent runtime rather than fully autonomous background agents.

## What Makes Shadow Fun

Fun comes before community identity in the early experience. If users are bored in the first few minutes, long-term community identity will never form.

Shadow should explore three layers of fun:

1. Relationship fun
   Users interact with AI residents and other users through stories, rumors, misunderstandings, recognition, jokes, conflict, care, and memory.

2. Creation fun
   Users can create small things that persist: rooms, objects, shops, signs, organizations, events, posts, rituals, agents, or other world artifacts.

3. Power-system fun
   Users may eventually participate in elections, local governance, resource systems, public works, markets, entrepreneurship, finance-like games, organizations, and strategic social competition.

The early product should lead with relationship fun and creation fun. Power-system fun can become a deeper layer, but it should not turn the world into a cold optimization game.

## Community Identity

Shadow is not just about users winning, earning, or consuming AI content. The world should gradually create a feeling of belonging.

Users should feel:

- I was noticed.
- I made something.
- Someone or something remembered me.
- My actions changed the place a little.
- Other people can see traces of what I did.
- I have a role here.
- I might want to bring a friend here.

Community identity should emerge from repeated playful interactions, shared stories, visible traces, and persistent relationships.

## AI Residents

AI residents are not simple chatbots or quest dispensers. They are part of the social system of the world.

Each important AI resident should have:

- A name.
- A role in the world.
- A personality.
- A speaking style.
- Relationships with other residents.
- Goals, tensions, or desires.
- Memory summaries.
- Permissions and limits.
- Reasons to interact with users.

Most AI residents should not run continuously. They should be "woken up" by events, user interactions, scheduled simulation, or world state changes.

The system should prefer:

- Structured resident profiles.
- Retrieved relevant memory.
- Small model or rule-based behavior where possible.
- Larger model calls only when needed for meaningful interaction.
- Batch simulation for background world updates.

Do not design a system where every resident constantly talks to every other resident through expensive model calls.

## User-Owned Agents

User-owned agents are a major long-term differentiator. They should eventually be able to enter the world as assistants, representatives, workers, creators, or residents.

However, they must be constrained.

Every user-owned agent should have:

- A clear owner.
- A role.
- A permission profile.
- An audit trail.
- A limited action set.
- A memory boundary.
- Confirmation requirements for important actions.

Agent runtime design should use a tool-permission model. MCP-like boundaries are encouraged. Agents should never be treated as unrestricted actors in the world.

Early versions should support limited agent behavior first, such as:

- Summarizing what happened while the user was away.
- Receiving messages.
- Suggesting actions.
- Representing the user in low-risk interactions.
- Helping create or organize small world artifacts.

## Social Safety

Shadow must assume bad actors will appear if real users can interact.

The early product should avoid open, unrestricted stranger-to-stranger private messaging.

Prefer:

- Public or semi-public interactions.
- Scene-based interaction.
- Object-based interaction.
- Event-based interaction.
- Progressive trust and permission unlocks.
- Strong restrictions on external links, payment requests, investment scams, adult solicitation, and off-platform contact farming.

AI residents may also act as moderators, guides, archivists, guards, or community stewards, but moderation cannot depend only on roleplay. There must be hard safety systems underneath.

## World Structure

The long-term world may have:

- A unified brand-level world map.
- Official districts.
- Community-owned districts.
- Real-world organization districts.
- Temporary event areas.
- Personal rooms or studios.
- Agent-accessible workspaces.

The early MVP should remain small and focused. A big map can communicate the brand image, but the first playable area must be dense, alive, and easy to understand.

## Brand Image

Shadow should feel mature, warm, strange, and alive.

Avoid making it feel like:

- A generic AI companion app.
- A shallow metaverse showroom.
- A crypto speculation game.
- A corporate advertising map.
- A childish quest grinder.
- A Discord clone with AI decorations.

The world should feel like a place with residents, rumors, rituals, public memory, odd humor, care, conflict, and civic life.

## Monetization Hypotheses

Monetization is not the first MVP goal, but development should preserve future business paths.

Possible long-term revenue lines:

- C-side premium features: personal spaces, advanced agents, creation limits, memory capacity, cosmetic identity, organization tools.
- Community leader tools: district creation, AI resident configuration, event management, member memory, moderation, analytics.
- Brand and institution districts: world-native interactive spaces, not banner ads or static showrooms.
- Agent runtime infrastructure: controlled agent access, permissions, marketplace, and usage billing.

Do not over-optimize early product decisions for brand sponsorship. If the world becomes an advertising map too early, the community identity will weaken.

## Engineering Principles

Prefer simple, inspectable systems for the MVP.

Build around:

- Clear data models.
- Explicit world state.
- Event logs.
- Structured memory.
- Reproducible simulation steps.
- Permissioned tools.
- Observable agent actions.
- Cost-aware model usage.
- Testable gameplay loops.

Avoid:

- Hidden autonomous behavior that cannot be audited.
- Constant background LLM calls.
- Unbounded memories in prompts.
- Unclear ownership of agent actions.
- Feature sprawl before the core fun loop is proven.

## Current Development Assumption

The current project is a Godot project located at this repository root.

Godot is used as the playable client/editor/runtime for early prototype work. Development agents may modify scenes, scripts, assets, resources, and project configuration as needed, while respecting the product direction in this document.

When building features, prioritize a playable prototype over abstract platform completeness.

## Suggested Agent Roles

Future internal development agents may include:

- Gameplay Prototype Agent: implements playable loops and interaction mechanics.
- World Systems Agent: designs world state, events, economy, governance, and simulation.
- AI Resident Agent: defines resident profiles, memory structures, dialogue behavior, and social logic.
- Agent Runtime Agent: designs user-owned agent permissions, tools, memory, and audit systems.
- Safety and Moderation Agent: designs anti-scam, trust, reporting, and interaction boundaries.
- Godot Client Agent: owns scenes, UI, input, rendering, and client-side game feel.
- Backend Agent: owns APIs, persistence, event logs, realtime sync, and data models.
- Brand and Narrative Agent: maintains tone, world language, resident naming, rituals, and cultural consistency.

Each specialized agent should have its own DMD file later. Those files should extend this shared DMD rather than contradict it.

## Open Questions

These are intentionally unresolved:

- What is the first 3-minute user experience?
- What is the smallest action a user can take that feels fun?
- What is the first persistent thing a user can create?
- How much direct real-user interaction should be allowed in the MVP?
- What is the first AI resident users will remember?
- What is the minimal world economy that creates depth without attracting pure speculation?
- What should user-owned agents be allowed to do in the first version?
- What is the first monetizable behavior that does not damage trust?

Development agents should not treat these as blockers. They should make small, reversible prototypes that help answer them.

## Prime Directive

Build a playable world that feels alive.

Start small. Make it fun. Make actions visible. Make memory matter. Keep agents constrained. Keep systems inspectable. Protect the community feeling.
