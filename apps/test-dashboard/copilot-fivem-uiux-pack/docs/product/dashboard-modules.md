# Dashboard modules and completion standard

## Personas
- Player support staff
- Moderators
- Senior admins
- Faction and department leaders
- Server owners / executive staff

## Primary modules
1. Authentication and session
   - login, logout, session timeout, permission-aware navigation
2. Overview
   - KPIs, alerts, server health summary, open reports, active incidents
3. Players
   - player search, current sessions, profiles, notes, sanctions, linked characters
4. Characters
   - character list, identities, jobs, inventories (read-heavy), properties, vehicles
5. Reports and support
   - queue, assignment, triage, response history, linked evidence
6. Moderation and enforcement
   - warnings, bans, kicks, appeals, evidence, audit trail
7. Factions and departments
   - staff roster, permissions, shift/status, department metrics
8. Economy and transactions
   - ledgers, invoices, fines, suspicious activity, treasury summaries
9. Assets
   - businesses, housing, garages, vehicles, inventories, item registries
10. Geography and map intelligence
   - market selector, area selector, activity heatmaps, incident zones, business coverage
11. Audit logs
   - actor, action, target, timestamp, filters, export
12. Settings
   - role management, feature flags, content configuration, area taxonomy management
13. Documentation and onboarding
   - SOP links, glossary, FAQ, release notes

## Shared UX patterns
- Global search command palette
- Role-aware side navigation
- Breadcrumbs and deep links
- Saved filters/views
- Split-view detail drawers
- Inline validation and action confirmations
- Bulk actions only with permission checks and confirmation
- Timeline-style audit history where appropriate

## Geography UX requirements
- Geography is a first-class filter in:
  - reports
  - players
  - economy
  - incidents
  - faction coverage
  - map/analytics views
- Every area filter must support:
  - market selection
  - typeahead area search
  - multi-select chips
  - clear and reset behavior
  - deep-linking in URL state
- Provide a dedicated taxonomy management screen with:
  - market overview
  - area count
  - search
  - alias management
  - content QA warnings

## Minimum page inventory
- `/login`
- `/app`
- `/app/overview`
- `/app/players`
- `/app/players/:playerId`
- `/app/characters`
- `/app/characters/:characterId`
- `/app/reports`
- `/app/reports/:reportId`
- `/app/moderation`
- `/app/factions`
- `/app/economy`
- `/app/assets`
- `/app/areas`
- `/app/audit`
- `/app/settings`
- `/app/docs`

## Definition of done
The UI/UX is not complete until all of the following are true:
- information architecture and navigation are documented
- design tokens exist and are consumed by components
- all core pages above are implemented
- all major tables have loading, empty, error, and permission-denied states
- light and dark themes both work
- keyboard navigation works for all core flows
- Storybook contains component states and page exemplars
- Playwright covers login, search, filter, detail drill-down, moderation flow, and area taxonomy flow
- geography filters work across all target modules
- browser dashboard and FiveM NUI shell share tokens/components where practical but remain separate apps/shells
- high-risk actions require confirmation and generate audit events
- docs explain architecture, security assumptions, and how to extend the area taxonomy
