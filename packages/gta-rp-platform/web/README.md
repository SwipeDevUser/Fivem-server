# Web Portals Directory

Admin portal and support dashboard frontend/backend applications.

## Contents

### admin-portal/
Administrative control panel for server management.

**Features:**
- Player management (kick, ban, warn)
- Job administration
- Business oversight
- Economy management
- Ban database
- Server logs
- Real-time statistics (WebSocket)

**Tech Stack:**
- Backend: Node.js/Express
- Frontend: React (ready for implementation)
- Database: PostgreSQL
- Real-time: Socket.io

**Files:**
- `package.json` - Dependencies
- `server.js` - Backend API server
- `src/` - Frontend React app (add as needed)

### support-dashboard/
Support team interface for player reports and tickets.

**Features:**
- Player reports viewer
- Chat logs
- Report history
- Ticket management
- Appeal processing
- Statistics dashboard

**Tech Stack:**
- Backend: Node.js/Express
- Database: PostgreSQL

**Files:**
- `package.json` - Dependencies
- `server.js` - Backend server

## Development

### Admin Portal
```bash
cd web/admin-portal

# Install dependencies
npm install

# Start development
npm run dev

# Access at http://localhost:3000
```

### Support Dashboard
```bash
cd web/support-dashboard

# Install dependencies
npm install

# Start development
npm run dev

# Access at http://localhost:3001
```

## API Endpoints

### Admin Portal (`/api/`)
```
GET    /players               - List all players
GET    /players/:id          - Player details
POST   /players/:id/ban      - Ban player
GET    /businesses           - List businesses
GET    /jobs                 - List jobs
GET    /logs                 - Admin logs
```

### Support Dashboard (`/api/`)
```
GET    /reports              - Player reports
POST   /reports/player       - Submit report
GET    /chatlogs             - Chat history
```

## Building Frontend

### Add React
```bash
cd web/admin-portal
npx create-react-app src
```

### Build for Production
```bash
npm run build
```

## Docker

Both portals are containerized in `docker-compose.yml`:

```bash
# Build images
docker-compose build

# Run
docker-compose up admin-api support-api

# View logs
docker-compose logs -f admin-api
```

## Authentication

Admin Portal uses JWT tokens:
```javascript
// Example login
const token = jwt.sign({id: admin.id}, process.env.JWT_SECRET);
localStorage.setItem('token', token);

// Add to headers
headers: {Authorization: `Bearer ${token}`}
```

## Adding Features

### New API Endpoint
```javascript
// In web/admin-portal/server.js
app.post('/api/feature', authMiddleware, async (req, res) => {
  // Your code here
});
```

### New Frontend Page
```jsx
// In web/admin-portal/src/pages/NewPage.jsx
import React from 'react';

export default function NewPage() {
  return <div>Your content</div>;
}
```

See `/docs/operations/` for deployment guides.
