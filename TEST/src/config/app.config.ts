/**
 * Application Configuration
 * Centralized settings for the FiveM Dashboard
 */

export const config = {
  // App Metadata
  app: {
    name: 'FiveM Admin Dashboard',
    version: '1.0.0',
    description: 'Enterprise admin dashboard for FiveM GTA RP servers',
    author: 'FiveM Development',
  },

  // API Configuration
  api: {
    baseURL: process.env.NEXT_PUBLIC_API_URL || 'http://localhost:3000',
    timeout: 30000,
    retries: 3,
  },

  // Authentication
  auth: {
    tokenExpiry: 3600, // 1 hour
    refreshTokenExpiry: 604800, // 7 days
    cookieName: '__fivem_auth',
    secureCookie: process.env.NODE_ENV === 'production',
    httpOnly: true,
    sameSite: 'Strict' as const,
  },

  // RBAC Configuration
  rbac: {
    defaultRole: 'viewer' as const,
    adminRole: 'admin' as const,
  },

  // Pagination
  pagination: {
    defaultPageSize: 10,
    maxPageSize: 100,
  },

  // Rate Limiting
  rateLimiting: {
    enabled: true,
    windowSeconds: 60,
    maxRequests: 100,
  },

  // Security
  security: {
    enableCSRF: true,
    enableCORS: false,
    corsOrigins: ['http://localhost:3000'],
    enableRateLimit: true,
  },

  // Regions & Geography
  regions: {
    default: 'orlando' as const,
    enabled: ['orlando', 'jacksonville', 'miami', 'daytona'] as const,
  },

  // Real-time Configuration
  realtime: {
    enabled: true,
    provider: 'websocket', // websocket or polling
    pollingIntervalSeconds: 5,
  },

  // Logging
  logging: {
    level: process.env.LOG_LEVEL || 'info',
    format: 'json',
    persistAuditLogs: true,
  },

  // Feature Flags
  features: {
    enableNUI: true,
    enableRealTimeUpdates: true,
    enableAdvancedAnalytics: true,
    enablePlayerTracking: true,
    enableEconomySimulation: true,
  },
} as const

export type Config = typeof config
