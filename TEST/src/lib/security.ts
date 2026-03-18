/**
 * Security Utilities
 * Input validation, XSS prevention, CSRF protection
 * OWASP Top 10 compliant
 */

import { z } from 'zod'

/**
 * Sanitize user input to prevent XSS
 */
export function sanitizeInput(input: string): string {
  const htmlEscapeMap: Record<string, string> = {
    '&': '&amp;',
    '<': '&lt;',
    '>': '&gt;',
    '"': '&quot;',
    "'": '&#x27;',
    '/': '&#x2F;',
  }
  return input.replace(/[&<>"'/]/g, (char) => htmlEscapeMap[char] || char)
}

/**
 * Validate email format
 */
export const emailSchema = z.string().email('Invalid email format')

/**
 * Validate password strength
 */
export const passwordSchema = z
  .string()
  .min(8, 'Password must be at least 8 characters')
  .regex(/[A-Z]/, 'Password must contain uppercase letter')
  .regex(/[a-z]/, 'Password must contain lowercase letter')
  .regex(/[0-9]/, 'Password must contain number')
  .regex(/[!@#$%^&*]/, 'Password must contain special character')

/**
 * Validate username
 */
export const usernameSchema = z.string().min(3).max(50).regex(/^[a-zA-Z0-9_-]+$/, 'Invalid username')

/**
 * Rate limiting store (in-memory)
 * Production: use Redis
 */
const rateLimitStore = new Map<string, { count: number; resetTime: number }>()

/**
 * Rate limiter middleware
 */
export function rateLimit(
  identifier: string,
  limit: number = 100,
  windowSeconds: number = 60
): boolean {
  const now = Date.now()
  const record = rateLimitStore.get(identifier)

  if (!record || now > record.resetTime) {
    rateLimitStore.set(identifier, {
      count: 1,
      resetTime: now + windowSeconds * 1000,
    })
    return true
  }

  if (record.count >= limit) {
    return false
  }

  record.count++
  return true
}

/**
 * CSRF token generation
 */
export function generateCSRFToken(userId: string): string {
  const timestamp = Date.now()
  const random = Math.random().toString(36).substr(2, 9)
  return `${userId}_${timestamp}_${random}`
}

/**
 * Validate CSRF token
 */
export function validateCSRFToken(token: string, userId: string, maxAge: number = 3600000): boolean {
  const [tokenUserId, timestamp] = token.split('_')

  if (tokenUserId !== userId) {
    return false
  }

  const age = Date.now() - parseInt(timestamp)
  return age < maxAge
}

/**
 * Check for SQL injection patterns (basic)
 */
export function hasSQLInjectionPattern(input: string): boolean {
  const patterns = [
    /(\b(UNION|SELECT|INSERT|UPDATE|DELETE|DROP|CREATE|ALTER)\b)/i,
    /(--|;|\/\*|\*\/)/,
    /(\bOR\b|\bAND\b)\s*1\s*=\s*1/i,
  ]

  return patterns.some((pattern) => pattern.test(input))
}

/**
 * Validate SteamID format
 */
export const steamIdSchema = z.string().regex(/^76561198\d{9}$/, 'Invalid SteamID format')

/**
 * Validate Discord ID
 */
export const discordIdSchema = z.string().regex(/^\d{17,19}$/, 'Invalid Discord ID')

/**
 * Validate player money (non-negative integer)
 */
export const moneySchema = z.number().int().min(0).max(999999999)

/**
 * Security headers for API responses
 */
export const securityHeaders = {
  'X-Content-Type-Options': 'nosniff',
  'X-Frame-Options': 'DENY',
  'X-XSS-Protection': '1; mode=block',
  'Strict-Transport-Security': 'max-age=31536000; includeSubDomains',
  'Content-Security-Policy': "default-src 'self'; script-src 'self' 'unsafe-inline'",
  'Referrer-Policy': 'strict-origin-when-cross-origin',
}

/**
 * Audit log entry
 */
export interface AuditEntry {
  action: string
  actor: string
  resource: string
  resourceId: string
  changes: Record<string, unknown>
  ipAddress: string
  timestamp: string
  status: 'success' | 'failure'
}

/**
 * Log security-sensitive actions
 */
export function logAuditEntry(entry: AuditEntry): void {
  console.log(`[AUDIT] ${entry.timestamp} - ${entry.actor} ${entry.action} on ${entry.resource}:${entry.resourceId}`)
  // TODO: Send to logging service
}

/**
 * Get client IP address
 */
export function getClientIP(request: Request): string {
  const forwarded = request.headers.get('x-forwarded-for')
  if (forwarded) {
    return forwarded.split(',')[0].trim()
  }
  return request.headers.get('x-client-ip') || 'unknown'
}
