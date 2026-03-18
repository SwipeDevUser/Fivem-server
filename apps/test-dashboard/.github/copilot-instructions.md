# FiveM Admin Dashboard - Copilot Instructions

## Project Overview
This is a Next.js-based admin dashboard for FiveM server management. It provides comprehensive monitoring and management capabilities for multiplayer roleplay servers, including player statistics, job management, drug economy tracking, and hitman contract management.

## Development Guidelines

### Getting Started
- Development server runs on `http://localhost:3000`
- Use `npm run dev` to start development
- Use `npm run build` to create production build
- Use `npm run lint` to check code quality

### File Structure
- **Components**: Located in `src/components/`
  - `dashboard/` - Dashboard-specific components
  - `layout/` - Layout components
- **Pages**: Located in `src/app/` (App Router)
- **Types**: TypeScript definitions in `src/types/index.ts`
- **Utils**: Helper functions and mock data in `src/utils/`

### Adding New Features

#### Create a New Dashboard Section
1. Create a new component in `src/components/dashboard/YourComponent.tsx`
2. Import in `src/app/page.tsx`
3. Follow the existing component patterns with TypeScript types
4. Use Tailwind CSS for styling with provided utility classes

#### Add New Data Types
1. Update `src/types/index.ts` with new interfaces
2. Create mock data in `src/utils/mockData.ts`
3. Update components to use new data structure

#### API Integration
1. Create route handler in `src/app/api/` folder
2. Use Next.js App Router conventions
3. Return proper TypeScript-typed responses
4. Update components from mock to API data gradually

### Code Standards

#### TypeScript
- Use strict mode for type safety
- Define interfaces/types for all data structures
- No implicit `any` types

#### Styling
- Use Tailwind CSS utility classes
- Define custom classes in `src/app/globals.css` for reusable patterns
- Responsive design required (mobile-first approach)
- Color scheme: Dark theme (slate-900 primary, blue-600 accent)

#### Component Structure
- Use functional components with React hooks
- Add 'use client' directive for interactive components
- Props should be typed with interfaces
- Keep components focused and reusable

### Performance Considerations
- Leverage Next.js automatic code splitting
- Use React.memo for expensive components
- Implement proper loading states
- Avoid unnecessary re-renders

### Testing
- Run linting: `npm run lint`
- Test build: `npm run build`
- Manual testing on `http://localhost:3000`

### Deployment
- Build optimization: `npm run build`
- Ensure all TypeScript types are valid
- Test production build locally: `npm run start`
- Set environment variables for production

## Common Tasks

### Update Mock Data
Edit `src/utils/mockData.ts` to modify test data without changing component code.

### Change Dashboard Layout
Modify the grid structure in `src/app/page.tsx`. Use Tailwind grid utilities:
- `grid-cols-1` - Mobile
- `md:grid-cols-2` - Tablet
- `lg:grid-cols-4` - Desktop

### Add Filtering/Sorting
Follow the pattern in `PlayerStats.tsx` with useState for filter state.

### Create New Stat Card
Use `StatCard` component in `src/components/dashboard/StatCard.tsx` for consistent styling.

## Component Reference

### StatCard
```typescript
<StatCard
  title="Players"
  value={100}
  icon="👥"
  color="blue"
  trend={{ value: 5, direction: 'up' }}
/>
```

### Filter Select
```typescript
<select className="bg-slate-700 border border-slate-600 px-3 py-1 rounded text-sm">
  <option>Option 1</option>
</select>
```

### Card Container
```typescript
<div className="card">
  {/* Content */}
</div>
```

## Environment Setup
- Node.js 18+
- npm 9+
- No additional environment variables required for development

## Debugging
- Use browser DevTools for client-side debugging
- Check terminal for compilation errors
- Ensure all imports are correct and files exist

## Related Resources
- Next.js Docs: https://nextjs.org/docs
- TypeScript: https://www.typescriptlang.org/
- Tailwind CSS: https://tailwindcss.com/
- React: https://react.dev/

## Project Status
✅ Core dashboard implemented with mock data
✅ All main features working (players, jobs, drugs, contracts)
📋 Ready for API integration
📋 Ready for authentication system
📋 Ready for real-time updates
