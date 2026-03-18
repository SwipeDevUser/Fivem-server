# API Documentation

## Authentication

### Login Endpoint

**POST /api/auth/login**

Request:
```json
{
  "username": "admin",
  "password": "SecurePassword123!"
}
```

Response:
```json
{
  "success": true,
  "data": {
    "accessToken": "eyJhbGciOiJIUzI1NiIs...",
    "refreshToken": "refresh_token_here",
    "expiresIn": 3600,
    "tokenType": "Bearer",
    "user": {
      "id": "admin-1",
      "username": "admin",
      "email": "admin@fivem.local",
      "role": "admin",
      "permissions": ["*"]
    }
  }
}
```

### Refresh Token Endpoint

**PUT /api/auth/login**

Request:
```json
{
  "refreshToken": "refresh_token_here"
}
```

## Players API

### List Players

**GET /api/players**

Query Parameters:
- `page` (number, default: 1) - Page number
- `pageSize` (number, default: 10) - Items per page
- `status` (string) - Filter by status ('online', 'offline')
- `search` (string) - Search by name, steamId, or identifier

Response:
```json
{
  "success": true,
  "data": [
    {
      "id": "player-1",
      "name": "John_Doe",
      "steamId": "76561198012345678",
      "status": "online",
      "playtimeMinutes": 4520,
      "totalMoney": 5000,
      "totalBankMoney": 45000,
      "warnings": 0
    }
  ],
  "meta": {
    "page": 1,
    "pageSize": 10,
    "total": 284,
    "totalPages": 29
  }
}
```

### Get Player Details

**GET /api/players/:id**

Response:
```json
{
  "success": true,
  "data": {
    "id": "player-1",
    "steamId": "76561198012345678",
    "discordId": "123456789012345678",
    "name": "John_Doe",
    "status": "online",
    "joinedDate": "2024-01-15T10:30:00Z",
    "lastSeen": "2024-03-18T15:20:00Z",
    "playtimeMinutes": 4520,
    "characters": [],
    "totalMoney": 5000,
    "totalBankMoney": 45000,
    "warnings": 0,
    "bans": [],
    "notes": "Regular player, no issues"
  }
}
```

### Ban Player

**POST /api/players/:id/ban**

Request:
```json
{
  "reason": "Toxic behavior",
  "duration": "permanent"
}
```

Response:
```json
{
  "success": true,
  "data": {
    "id": "player-1",
    "banned": true,
    "reason": "Toxic behavior",
    "duration": "permanent",
    "bannedAt": "2024-03-18T15:30:00Z"
  }
}
```

## Reports API

### List Reports

**GET /api/reports**

Query Parameters:
- `page` (number, default: 1)
- `pageSize` (number, default: 10)
- `status` (string) - Filter by status
- `priority` (string) - Filter by priority

### Create Report

**POST /api/reports**

Request:
```json
{
  "reporter": "player-1",
  "subject": "player-2",
  "category": "griefing",
  "description": "Player was harassing other players",
  "priority": "high"
}
```

### Update Report

**PATCH /api/reports/:id**

Request:
```json
{
  "status": "resolved",
  "resolution": "Warning issued"
}
```

## Error Responses

All errors follow this format:

```json
{
  "success": false,
  "error": {
    "code": "ERROR_CODE",
    "message": "Human readable error message",
    "details": {}
  }
}
```

### Common Error Codes

- `UNAUTHORIZED` (401) - Authentication required
- `FORBIDDEN` (403) - Insufficient permissions
- `NOT_FOUND` (404) - Resource not found
- `VALIDATION_ERROR` (400) - Invalid input
- `RATE_LIMITED` (429) - Too many requests
- `SERVER_ERROR` (500) - Internal server error

## Rate Limiting

API requests are rate limited:
- 100 requests per minute per IP
- 1000 requests per hour per authenticated user

Rate limit headers:
```
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 45
X-RateLimit-Reset: 1710764400
```

## Pagination

All list endpoints support pagination:

Query: `GET /api/players?page=2&pageSize=20`

Response includes:
```json
{
  "meta": {
    "page": 2,
    "pageSize": 20,
    "total": 284,
    "totalPages": 15
  }
}
```

## Filtering & Sorting

Filters use query parameters:
```
GET /api/players?status=online&minPlaytime=1000
```

Sorting (future enhancement):
```
GET /api/players?sortBy=playtime&sortOrder=desc
```

## Webhooks (Future)

Support for webhook subscriptions:
```json
POST /api/webhooks
{
  "url": "https://your-server.com/webhooks/fivem",
  "events": ["player.joined", "player.left", "contract.completed"]
}
```

## Rate Limits by Endpoint

- `GET /api/players` - 10 requests/minute
- `POST /api/players/:id/ban` - 5 requests/minute
- `POST /api/reports` - 20 requests/minute
- Other endpoints - 100 requests/minute
