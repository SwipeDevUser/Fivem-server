# System Architecture

## High-Level Overview

```
┌─────────────────────────────────────────────────────────────┐
│                    FiveM Admin Dashboard                     │
└─────────────────────────────────────────────────────────────┘
        ↓                    ↓                    ↓
   Web Dashboard      Mobile Web           FiveM NUI (In-Game)
   (Browser)          (Responsive)         (Chromium/CEF)
        │                 │                      │
        └────────────┬────┴──────────────────────┘
                     ↓
           ┌─────────────────────┐
           │   Next.js Frontend   │
           │  - React Components  │
           │  - Client State      │
           │  - Routing           │
           └─────────────────────┘
                     ↓
           ┌─────────────────────┐
           │   Next.js API Layer  │
           │  - REST Endpoints    │
           │  - RBAC Middleware   │
           │  - Authentication    │
           └─────────────────────┘
                     ↓
           ┌─────────────────────────────┐
           │    Business Logic Layer      │
           │  - Entity Services          │
           │  - Validation               │
           │  - Authorization            │
           │  - Audit Logging            │
           └─────────────────────────────┘
                     ↓
           ┌─────────────────────────────┐
           │    Data Access Layer        │
           │  - Database ORM             │
           │  - Caching (Redis)          │
           │  - FiveM Server API Bridge  │
           └─────────────────────────────┘
                     ↓
      ┌──────────────┬──────────────┐
      ↓              ↓              ↓
  PostgreSQL      Redis         FiveM Server
  (Primary DB)    (Cache)       (Game Server)
```

## Technology Stack

### Frontend
- **Framework**: React 18 + Next.js 14
- **Language**: TypeScript (strict mode)
- **State Management**: Zustand + TanStack Query
- **Styling**: Tailwind CSS
- **Components**: Custom library + Headless UI
- **Documentation**: Storybook

### Backend
- **Runtime**: Node.js 18+
- **Framework**: Next.js API Routes
- **Type Safety**: TypeScript + Zod
- **Security**: RBAC, JWT, Rate Limiting

### Database
- **Primary**: PostgreSQL
- **Cache**: Redis
- **ORM**: Prisma (future enhancement)

### Testing
- **Unit**: Jest + React Testing Library
- **E2E**: Playwright
- **Accessibility**: axe-core

### DevOps
- **Container**: Docker
- **CI/CD**: GitHub Actions (recommended)
- **Monitoring**: Prometheus/Grafana (recommended)
- **Logging**: ELK Stack (recommended)

## Directory Structure

```
src/
├── app/                           # Next.js App Router
│   ├── api/                       # API Routes
│   │   ├── auth/                  # Authentication
│   │   ├── players/               # Player management
│   │   ├── reports/               # Report system
│   │   └── health/                # Health checks
│   ├── app/                       # Authenticated app
│   │   ├── layout.tsx             # App shell
│   │   ├── overview/page.tsx      # Dashboard
│   │   ├── players/page.tsx       # Players list
│   │   ├── areas/page.tsx         # Geography page
│   │   └── [other pages]/         # Additional pages
│   ├── page.tsx                   # Home/Login
│   ├── layout.tsx                 # Root layout
│   └── globals.css                # Global styles
├── components/
│   ├── ui/                        # Reusable components
│   │   ├── Button.tsx             # Button component
│   │   ├── Modal.tsx              # Modal dialog
│   │   ├── Table.tsx              # Data table
│   │   └── [other components]/
│   ├── dashboard/                 # Dashboard components
│   │   ├── StatCard.tsx           # Stat display
│   │   ├── PlayerStats.tsx        # Player table
│   │   └── [other components]/
│   ├── nui/                       # FiveM NUI components
│   │   └── FiveMLiveUI.tsx        # In-game UI
│   └── layout/
│       └── Navigation.tsx         # Navigation sidebar
├── lib/                           # Utilities
│   ├── rbac.ts                    # Authorization
│   ├── security.ts                # Security utils
│   ├── nui-bridge.ts              # NUI communication
│   └── [other utilities]/
├── config/
│   └── app.config.ts              # App configuration
├── data/                          # Static data
│   └── areas.ts                   # Florida geography
├── types/                         # TypeScript types
│   └── index.ts                   # Main types file
├── utils/
│   └── mockData.ts                # Mock data
├── __tests__/                     # Tests
│   ├── lib/                       # Library tests
│   ├── components/                # Component tests
│   └── setup.ts                   # Test setup
└── theme/
    └── tokens.ts                  # Design tokens

e2e/                               # End-to-end tests
├── auth.spec.ts
├── players.spec.ts
└── reports.spec.ts

.storybook/                        # Storybook config
├── main.ts
└── preview.tsx

public/                            # Static assets
```

## Data Models

### Core Entities

```
User
├── id: string
├── username: string
├── email: string
├── role: UserRole
└── permissions: Permission[]

Player
├── id: string
├── steamId: string
├── identifier: string
├── name: string
├── status: 'online' | 'offline'
└── characters: Character[]

Character
├── id: string
├── playerId: string
├── firstName: string
├── lastName: string
├── job: string
└── bankMoney: number

Report
├── id: string
├── reporter: Player
├── subject: Player
├── category: ReportCategory
├── status: ReportStatus
└── assignedTo: User

Job
├── id: string
├── name: string
├── type: 'legal' | 'illegal'
├── maxSlots: number
├── occupiedSlots: number
└── grades: JobGrade[]

Area
├── id: string
├── name: string
├── region: FloridaRegion
├── population: number
├── crimeRate: number
└── prosperity: number
```

## API Communication Flow

```
Client (Browser/NUI)
    ↓
[Zustand Store / TanStack Query]
    ↓
[Request Validation / Optimistic Updates]
    ↓
HTTP/JSON
    ↓
Next.js API Route
    ↓
[RBAC Middleware]
    ↓
[Input Validation]
    ↓
Business Logic Service
    ↓
Database Query / Cache Lookup
    ↓
Response Formatting
    ↓
HTTP/JSON
    ↓
Client (TanStack Query / Zustand)
    ↓
UI Update / Re-render
```

## Authentication Flow

```
1. User submits credentials
    ↓
2. Backend validates credentials
    ↓
3. Generate JWT tokens
    - accessToken (1 hour)
    - refreshToken (7 days)
    ↓
4. Send tokens to client
    ↓
5. Client stores tokens
    - accessToken: Memory / localStorage
    - refreshToken: HTTP-only cookie
    ↓
6. Include accessToken in subsequent requests
    ↓
7. If token expires, use refreshToken to get new accessToken
```

## Authorization (RBAC)

```
Route Requested
    ↓
Extract JWT Token
    ↓
Verify Signature & Expiration
    ↓
Extract User Role
    ↓
Check Required Permissions
    ↓
Permission Granted? ──Yes──→ Process Request
    ↓ No
Deny (403 Forbidden)
```

## State Management

### Global State (Zustand)

```typescript
// User state
- currentUser: User | null
- isAuthenticated: boolean
- userRole: UserRole

// UI State
- sidebarOpen: boolean
- activeTab: string
- selectedFilters: Record<string, any>

// Data State
- players: Player[]
- reports: Report[]
- selectedPlayer: Player | null
```

### Server State (TanStack Query)

```typescript
// Cached queries
- usePlayersQuery()
- useReportsQuery()
- usePlayerDetailQuery(id)

// Mutations
- useBanPlayerMutation()
- useCreateReportMutation()
- useUpdateReportMutation()
```

## Real-time Updates

### WebSocket (Future)

```
Client connects to WebSocket
    ↓
Subscribe to channels
    - players.changes
    - economy.updates
    - contracts.status
    ↓
Server broadcasts changes
    ↓
Client receives updates
    ↓
Update local state
    ↓
UI re-renders automatically
```

## Performance Optimizations

1. **Code Splitting**: Route-based chunks via Next.js
2. **Caching**: Redis for frequently accessed data
3. **Lazy Loading**: Components load on demand
4. **Image Optimization**: Next.js Image component
5. **Database**: Indexed queries, connection pooling
6. **API**: Rate limiting, pagination, field selection

## Security Layers

```
1. Transport: HTTPS/TLS
2. Application: RBAC, JWT, CSRF tokens
3. Data: Input validation, SQL injection prevention
4. Access: Rate limiting, IP logging
5. Audit: Complete action logging
```

## Scaling Considerations

### Horizontal Scaling
- Stateless API servers (multiple instances)
- Shared Redis cache
- Load balancer (nginx/HAProxy)
- Database replicas

### Vertical Optimization
- Increase server resources
- Optimize queries
- Implement caching layers
- Compress responses

### Database Scaling
- Read replicas for queries
- Write primary for mutations
- Partitioning for large tables
- Archive old audit logs

## Monitoring & Observability

### Metrics to Track
- Request latency (p50, p95, p99)
- Error rate
- Database query time
- Cache hit rate
- Active connections
- Memory usage
- CPU usage

### Logging Strategy
- Application logs (all requests)
- Error logs (exceptions)
- Audit logs (security events)
- Performance logs (slow queries)

### Alerts
- High error rate (> 5%)
- Slow response times (> 1s p95)
- Database connection pool exhaustion
- Memory usage critical
- Disk space low
