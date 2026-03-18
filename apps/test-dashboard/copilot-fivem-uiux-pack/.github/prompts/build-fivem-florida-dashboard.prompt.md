---
name: build-fivem-florida-dashboard
description: Build and complete a production-grade FiveM browser dashboard with shared UI primitives, geography taxonomy, Storybook, and Playwright.
agent: dashboard-orchestrator
---

Build and finish the FiveM Florida dashboard UI/UX in this repository.

Use these context files as source material:
- [Project instructions](../copilot-instructions.md)
- [Dashboard modules and definition of done](../../docs/product/dashboard-modules.md)
- [Florida geography canon](../../docs/product/florida-areas.md)

Your objectives are:
1. Audit the repository and determine whether to extend existing code or scaffold the baseline.
2. Produce a concrete implementation plan and save it to `docs/implementation/dashboard-plan.md`.
3. Use specialist agents to create:
   - information architecture
   - design system
   - geography taxonomy
   - browser dashboard routes and pages
   - FiveM NUI bridge and shared UI packaging
   - accessibility and security review
   - automated QA
4. Implement the dashboard until the definition of done in `docs/product/dashboard-modules.md` is satisfied.
5. Keep all changes production-oriented: typed, documented, testable, and reviewable.

Non-negotiable product requirements:
- primary deliverable is a browser dashboard
- shared UI must be reusable in future NUI surfaces
- geography is first-class and must support all canon Florida markets and areas
- preserve canon names from the Florida geography file
- create a content QA report for questionable entries without deleting them
- all major pages must support loading, empty, error, and permission-denied states
- build light and dark themes
- keep privileged server operations out of NUI unless explicitly documented and justified

Execution rules:
- do not stop at wireframes; implement working code
- do not stop at components; wire pages and filters
- do not stop at pages; add tests and docs
- route work back through reviewers when specialist findings reveal issues
- iterate until the project reaches a stable, documented completion state

Required outputs before completion:
- implementation plan
- route map
- design tokens and reusable components
- area taxonomy code and docs
- implemented routes/pages
- Storybook setup and stories
- Playwright coverage
- accessibility review
- security review
- QA report
- final completion report summarizing what shipped and what remains
