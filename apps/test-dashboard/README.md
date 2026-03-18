# FiveM Admin Dashboard

A comprehensive Next.js admin dashboard for managing FiveM multiplayer roleplay servers. This dashboard provides real-time insights into player statistics, job management, drug economy, and hitman contracts.

## Features

### 📊 Dashboard Overview
- **Real-time Server Statistics**: Monitor online/offline players, active jobs, and pending contracts
- **Financial Tracking**: Track total cash circulation and bank money across the server
- **Status Indicators**: Visual indicators for server health and game events

### 👥 Player Management
- **Player Statistics Table**: Sortable player list with detailed information
- **Job Filtering**: Filter players by their current job
- **Financial Overview**: Track cash and bank balances for each player
- **Playtime Tracking**: Monitor player engagement with total playtime statistics
- **Online Status**: Quick view of which players are currently online

### 💼 Jobs Management
- **Legal vs. Illegal Jobs**: Organized view of all server jobs
- **Capacity Visualization**: Progress bars showing job slots utilization
- **Job Overview**: Quick stats on legal jobs, illegal jobs, and total players
- **Boss Information**: Track job leadership and organization

### 💊 Drug Economy System
- **Production Facilities**: Monitor methamphetamine labs, cocaine processing, and weed farms
- **Facility Status**: Track active, raided, and shut down operations
- **Production Metrics**: Monitor production rates, purity levels, and daily output
- **Black Market Prices**: Real-time drug prices with demand levels
- **Market Intelligence**: Supply levels and recent transaction counts

### 🎯 Hitman Contracts
- **Contract Management**: Full lifecycle tracking of hitman contracts
- **Status Tracking**: Pending, in-progress, completed, failed, and cancelled contracts
- **Progress Monitoring**: Visual progress bars for active contracts
- **Reward Tracking**: Monitor contract rewards and payouts
- **Target Management**: Track targets and assigned assassins

## Tech Stack

- **Framework**: Next.js 14 (React 18)
- **Language**: TypeScript
- **Styling**: Tailwind CSS
- **Package Manager**: npm

## Project Structure

```
src/
├── app/
│   ├── page.tsx              # Main dashboard page
│   ├── layout.tsx            # Root layout
│   └── globals.css           # Global styles
├── components/
│   ├── layout/
│   │   └── Navigation.tsx     # Navigation bar
│   └── dashboard/
│       ├── StatCard.tsx       # Statistics card component
│       ├── PlayerStats.tsx    # Player management section
│       ├── JobsManagement.tsx # Jobs management section
│       ├── DrugEconomy.tsx    # Drug economy section
│       └── HitmanContracts.tsx # Contracts section
├── types/
│   └── index.ts              # TypeScript type definitions
└── utils/
    └── mockData.ts           # Mock data for development
```

## Getting Started

### Prerequisites
- Node.js 18+ 
- npm

### Installation

1. Install dependencies:
```bash
npm install
```

2. Run the development server:
```bash
npm run dev
```

3. Open [http://localhost:3000](http://localhost:3000) in your browser

### Building for Production

```bash
npm run build
npm run start
```

## Available Scripts

- `npm run dev` - Start development server
- `npm run build` - Create production build
- `npm run start` - Start production server
- `npm run lint` - Run ESLint

## Mock Data

The dashboard currently uses mock data for demonstration. To use real data:

1. Replace `mockData.ts` with actual API calls
2. Create API routes in `src/app/api/` to fetch server data
3. Update components to use real data instead of mock data

### Mock Data Locations
- **Players**: `src/utils/mockData.ts` - `mockPlayers`
- **Jobs**: `src/utils/mockData.ts` - `mockJobs`
- **Drug Productions**: `src/utils/mockData.ts` - `mockDrugProductions`
- **Market Data**: `src/utils/mockData.ts` - `mockDrugMarkets`
- **Contracts**: `src/utils/mockData.ts` - `mockContracts`

## Type Definitions

All TypeScript types are defined in `src/types/index.ts`:
- `Player`: Player information and statistics
- `Job`: Job configuration and occupancy
- `JobGrade`: Job rank and permissions
- `DrugProduction`: Drug lab status and output
- `DrugMarket`: Black market pricing data
- `HitmanContract`: Contract status and tracking
- `ServerStats`: Overall server statistics
- `Dashboard`: Main dashboard data structure

## UI Components

### StatCard
Displays key metrics with color coding and trend indicators.

### PlayerStats
Filterable, sortable table of all server players with financial and playtime data.

### JobsManagement
Organized view of legal and illegal jobs with capacity visualization.

### DrugEconomy
Tabbed interface showing production facilities and market prices.

### HitmanContracts
Contract listing with status filters and progress tracking.

## Customization

### Colors
Tailwind CSS configuration can be modified in `tailwind.config.ts`:
- `primary`: Main dashboard color (default: slate-900)
- `secondary`: Secondary background (default: slate-800)
- `accent`: Accent color (default: blue)

### Styling
Global styles and component classes are in `src/app/globals.css`.

## Performance Optimizations

- Server-side rendering with Next.js
- CSS modules with Tailwind for optimized styling
- Client-side components for interactive features
- Automatic code splitting

## Future Enhancements

- [ ] Real-time WebSocket updates
- [ ] Authentication system
- [ ] Admin actions (kick players, manage jobs)
- [ ] Advanced analytics and reporting
- [ ] Dark/Light theme toggle
- [ ] Responsive mobile layout improvements
- [ ] Export data functionality
- [ ] Server configuration management

## API Integration

To connect to a real FiveM server, create API routes in the `app/api` directory:

```typescript
// Example: app/api/players/route.ts
export async function GET() {
  // Fetch from FiveM server or database
  const players = await fetchPlayersFromServer();
  return Response.json(players);
}
```

Then update components to fetch from these routes instead of using mock data.

## Troubleshooting

### Port 3000 Already in Use
```bash
# Change port in package.json or run:
npm run dev -- -p 3001
```

### TypeScript Errors
Ensure all type files are properly imported. Check `src/types/index.ts` for required type definitions.

### Styling Issues
Run `npm install` to ensure Tailwind CSS is properly installed.

## License

MIT

## Contributing

For contributions, please follow these steps:
1. Create a feature branch
2. Make your changes
3. Test thoroughly
4. Submit a pull request

## Support

For issues or questions, refer to the Next.js documentation:
- [Next.js Documentation](https://nextjs.org/docs)
- [TypeScript Handbook](https://www.typescriptlang.org/docs/)
- [Tailwind CSS Documentation](https://tailwindcss.com/docs)

---

**Project Version**: 0.1.0  
**Last Updated**: March 18, 2026
