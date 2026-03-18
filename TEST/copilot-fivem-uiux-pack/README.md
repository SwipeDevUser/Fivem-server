# FiveM Florida Dashboard Copilot Pack

This pack gives you a ready-to-use GitHub Copilot customization setup for building a FiveM browser dashboard with shared UI primitives for future NUI usage.

## Files
- `.github/copilot-instructions.md` — always-on project rules
- `.github/prompts/build-fivem-florida-dashboard.prompt.md` — the main orchestration prompt
- `.github/agents/*.agent.md` — specialist agents with handoffs
- `docs/product/florida-areas.md` — the market and area canon
- `docs/product/dashboard-modules.md` — product scope and definition of done

## Recommended usage
1. Add these files to the repository root.
2. Open the repo in VS Code with GitHub Copilot enabled.
3. Select the `dashboard-orchestrator` agent in chat, or run the prompt file `/build-fivem-florida-dashboard`.
4. Review the plan before implementation starts.
5. Approve iterative changes and let the reviewer / QA agents validate before merge.

## What this pack assumes
- Primary deliverable is a browser dashboard.
- Shared component system can be reused by NUI later.
- Florida markets and areas are product canon for v1.
