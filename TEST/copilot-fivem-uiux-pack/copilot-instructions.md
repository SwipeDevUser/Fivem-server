# FiveM Florida Dashboard project instructions

## Product scope
Build a production-grade browser dashboard for a FiveM GTA RP server with a shared UI system that can also support future NUI surfaces. The browser dashboard is the primary deliverable. NUI compatibility is secondary and must not force privileged staff tooling into the game client.

## Technology baseline
- Frontend: React + TypeScript + Vite.
- Component workshop and docs: Storybook.
- E2E and regression testing: Playwright.
- Styling: token-driven design system with CSS variables and a theme layer.
- Data-heavy screens: prefer MUI X Data Grid for speed and consistency, unless the repository already standardizes on another table system. If the codebase already uses a headless stack, preserve that choice and use TanStack Query plus a table abstraction.
- Shared package strategy:
  - `packages/design-tokens`
  - `packages/ui`
  - `apps/dashboard`
  - `apps/nui-shell` or `resources/[ui]/dashboard_nui/web`

## FiveM-specific constraints
- Keep the browser dashboard and NUI shell separate.
- The browser dashboard handles privileged staff and owner workflows.
- NUI handles contextual in-game flows only.
- For FiveM resources, maintain a valid `fxmanifest.lua` and `ui_page` entry where needed.
- Use `https://` for NUI callbacks.
- Respect NUI focus limitations and avoid designs that depend on click-through between resources.
- Never rely on browser APIs from regular FiveM client scripts; use a proper NUI page for browser-like UI.

## Security and trust boundaries
- Never trust client-originated data for money, inventory, permissions, punishments, or economy-changing actions.
- All privileged actions must be confirmed and validated server-side.
- All destructive actions need audit logging.
- Keep txAdmin for core server control and avoid recreating high-risk server controls in the custom dashboard unless explicitly required and fully reviewed.
- Apply least privilege for roles and agent behavior.

## Accessibility and UX standards
- Meet WCAG 2.2 AA as the minimum target.
- Prefer native semantic HTML before ARIA.
- Support full keyboard navigation.
- Provide visible focus states.
- Respect reduced motion and color-scheme preferences.
- Build clear loading, empty, error, and permission-denied states.
- Use real data tables for tabular data.
- Never rely on charts alone to convey critical information.

## Design system rules
- Build tokens first: color, spacing, radius, typography, elevation, motion, z-index.
- Support light and dark mode from day one.
- Keep density variants for staff-heavy data screens.
- Every component needs Storybook stories for default, hover, focus, disabled, loading, error, empty, and long-content states.
- Every page uses shared layout primitives and shared feedback patterns.

## Architecture rules
- Use feature folders by domain.
- Keep smart/container logic separated from presentational components.
- Use strict TypeScript settings.
- Treat server state and client state differently.
- Avoid leaking backend DTOs directly into UI components; map them into view models.
- Build reusable filter bars, command palettes, detail drawers, confirmation dialogs, and audit timelines.

## Florida taxonomy requirements
- The provided Florida area list is product canon for v1.
- Preserve all provided market and area entries.
- Do not silently drop or auto-correct entries.
- Build normalized slugs and alias support for search and filters.
- Create a non-blocking content QA report for possible typos, duplicates, or county mismatches, but keep the items in the taxonomy unless the product owner changes the source list.
- All major pages that filter by geography must support market and area selection.

## Deliverables
- A complete design system and dashboard IA.
- Production-ready browser dashboard screens.
- Shared UI package suitable for later NUI reuse.
- A Florida geography taxonomy used across filters, map views, forms, analytics, and access rules.
- Storybook docs.
- Playwright flows.
- Accessibility review notes.
- Security review notes.
- Developer documentation and decision records.

## Output expectations
- Work iteratively and keep a running plan in repo docs.
- Reuse existing codebase patterns if present.
- If the repository is empty, scaffold the full baseline and document all generated structure.
- Before marking work complete, run and fix lint, typecheck, Storybook build, and Playwright tests.
