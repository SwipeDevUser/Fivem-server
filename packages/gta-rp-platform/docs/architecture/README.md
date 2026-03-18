# GTA RP Platform Architecture

## System Overview

```
┌─────────────────────────────────────────────────────────┐
│                    Admin Portal (React)                  │
│                 http://localhost:3000                    │
└────────────────────────┬────────────────────────────────┘
                         │
                    REST API / WebSocket
                         │
┌────────────────────────▼────────────────────────────────┐
│            Admin API (Node.js/Express)                   │
│         Manages: Players, Jobs, Businesses, Bans        │
└────────────────────────┬────────────────────────────────┘
                         │
        ┌────────────────┼────────────────┐
        │                │                │
        ▼                ▼                ▼
    PostgreSQL        Redis Cache    FiveM Server
    Database          (Sessions)      (Lua)
    (Players,
     Characters,
     Businesses)
```

## Data Flow

### Player Login
```
Client
  │
  └─► FiveM Server (Identify Check)
      │
      └─► Database (Authentication)
          │
          └─► Player Data Loaded
              │
              └─► Character Selection
                  │
                  └─► In-Game
```

### Business Operations
```
Sales Transaction
  │
  └─► Inventory Deducted
      │
      └─► Revenue Added to Business Account
          │
          └─► Stored in Database
              │
              └─► Admin Portal Updated (Real-time)
```

### Payroll Processing
```
Payroll Timer (Every 30 minutes)
  │
  ├─► Calculate Salary for Each Job
  │   │
  │   └─► Deduct from Employer Account (Business/Government)
  │
  ├─► Add Money to Player Character
  │   │
  │   └─► Log Transaction
  │
  └─► Update Player Balance
      │
      └─► Notify Player
```

## Module Architecture

### Core Framework (Lua)
```
Resources/
├── core/                  ← Central Framework
│   ├── checks.lua        (Player verification)
│   ├── roles.lua         (Permission system)
│   ├── jobs.lua          (Job management)
│   ├── paycheck.lua      (Salary distribution)
│   ├── economy.lua       (Financial tracking)
│   ├── business.lua      (Business creation)
│   └── crime.lua         (Crime system)
│
├── jobs/                 ← Job Resources
│   ├── police/
│   ├── ems/
│   └── taxi/
│
├── gameplay/             ← Gameplay Features
│   ├── vehicles/
│   ├── housing/
│   └── inventory/
│
└── support/              ← Support Systems
    ├── admin/
    ├── security/
    └── logging/
```

### Backend API (Node.js)
```
Routes/
├── /api/players     (User management)
├── /api/jobs        (Job operations)
├── /api/businesses  (Business admin)
├── /api/bans        (Ban system)
└── /api/logs        (Audit logs)

Middlewares/
├── auth.js          (JWT authentication)
├── validation.js    (Input validation)
├── errorHandler.js  (Error handling)
└── logging.js       (Request logging)
```

## Database Schema

### Player Hierarchy
```
Players (licenses, discord, role)
  │
  └─► Characters (firstname, lastname, money, job)
      │
      ├─► Jobs (job_name, grade, salary)
      ├─► Inventory (items, quantities)
      ├─► Crimes (committed crimes, arrests)
      └─► Transactions (financial history)

Businesses
  │
  ├─► Employees (hired characters)
  ├─► Inventory (business items)
  ├─► Sales (transaction history)
  └─► Expansions (purchased upgrades)
```

## Security Layers

```
┌─ Client (FiveM) ──────────────────────────┐
│ ├─ License Verification                    │
│ ├─ Whitelist Check                         │
│ └─ Anti-Cheat Hooks                        │
└─────────────────────────────────────────────┘
           │
           ▼
┌─ Server (FiveM/Lua) ──────────────────────┐
│ ├─ Player Checks (identity, permissions)  │
│ ├─ Resource Permissions                    │
│ └─ Event Validation                        │
└─────────────────────────────────────────────┘
           │
           ▼
┌─ API Layer (Node.js) ─────────────────────┐
│ ├─ JWT Authentication                      │
│ ├─ Rate Limiting                           │
│ ├─ Input Validation                        │
│ └─ RBAC (Role-Based Access Control)       │
└─────────────────────────────────────────────┘
           │
           ▼
┌─ Database (PostgreSQL) ────────────────────┐
│ ├─ Prepared Statements                     │
│ ├─ Row-Level Security                      │
│ └─ Encryption (sensitive fields)           │
└─────────────────────────────────────────────┘
```

## Deployment Architecture

```
┌──────────────────────────────────┐
│      Docker Compose              │
├──────────────────────────────────┤
│                                  │
│  ┌──────────────────────────┐   │
│  │   Admin API Container     │   │
│  │  (Node.js/Express)        │   │
│  │  Port: 3000               │   │
│  └──────────────────────────┘   │
│                                  │
│  ┌──────────────────────────┐   │
│  │ Support API Container     │   │
│  │  (Node.js/Express)        │   │
│  │  Port: 3001               │   │
│  └──────────────────────────┘   │
│                                  │
│  ┌──────────────────────────┐   │
│  │  PostgreSQL Container     │   │
│  │  Port: 5432               │   │
│  └──────────────────────────┘   │
│                                  │
│  ┌──────────────────────────┐   │
│  │  Redis Container          │   │
│  │  Port: 6379               │   │
│  └──────────────────────────┘   │
│                                  │
│  ┌──────────────────────────┐   │
│  │  FiveM Server Container   │   │
│  │  Port: 30120 (TCP/UDP)    │   │
│  └──────────────────────────┘   │
│                                  │
└──────────────────────────────────┘
```

## Scalability Considerations

- **Horizontal Scaling**: Run multiple FiveM instances behind a load balancer
- **Database**: PostgreSQL with replication for HA
- **Caching**: Redis for sessions and frequently accessed data
- **CDN**: Static files served via CDN
- **Monitoring**: Prometheus/Grafana for metrics
- **Logging**: ELK Stack for centralized logging

## Performance Metrics

- **Response Time**: < 200ms for API calls
- **Database Queries**: < 100ms avg
- **Backup Time**: < 5 minutes
- **Recovery Time Objective (RTO)**: 30 minutes
- **Recovery Point Objective (RPO)**: 15 minutes
