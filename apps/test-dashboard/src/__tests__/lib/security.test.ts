/**
 * Security Utilities Tests
 * Testing input validation, sanitization, and CSRF protection
 */

import {
  sanitizeInput,
  emailSchema,
  passwordSchema,
  usernameSchema,
  hasSQLInjectionPattern,
  generateCSRFToken,
  rateLimit,
} from '@/lib/security'

describe('Security Utilities', () => {
  describe('sanitizeInput', () => {
    it('should escape XSS script tags', () => {
      const malicious = '<script>alert("xss")</script>Hello'
      const result = sanitizeInput(malicious)
      expect(result).not.toContain('<script>')
      expect(result).toContain('Hello')
    })

    it('should escape HTML tags', () => {
      const input = '<div>Hello</div>'
      const result = sanitizeInput(input)
      expect(result).not.toContain('<div>')
      expect(result).toContain('Hello')
    })

    it('should preserve safe text', () => {
      const safe = 'Hello World'
      expect(sanitizeInput(safe)).toBe('Hello World')
    })

    it('should escape special characters', () => {
      const special = 'Test & < > " \''
      const result = sanitizeInput(special)
      expect(result).toContain('&amp;')
      expect(result).toContain('&lt;')
      expect(result).toContain('&gt;')
    })
  })

  describe('Email Validation', () => {
    it('should validate correct email format', () => {
      const result = emailSchema.safeParse('user@example.com')
      expect(result.success).toBe(true)
    })

    it('should reject invalid email', () => {
      const result = emailSchema.safeParse('invalid-email')
      expect(result.success).toBe(false)
    })

    it('should reject empty email', () => {
      const result = emailSchema.safeParse('')
      expect(result.success).toBe(false)
    })

    it('should reject email without @', () => {
      const result = emailSchema.safeParse('useratexample.com')
      expect(result.success).toBe(false)
    })
  })

  describe('Password Validation', () => {
    it('should accept strong password', () => {
      const result = passwordSchema.safeParse('SecurePass123!')
      expect(result.success).toBe(true)
    })

    it('should reject short password', () => {
      const result = passwordSchema.safeParse('Short1!')
      expect(result.success).toBe(false)
    })

    it('should reject password without uppercase', () => {
      const result = passwordSchema.safeParse('lowercasepass123!')
      expect(result.success).toBe(false)
    })

    it('should reject password without numbers', () => {
      const result = passwordSchema.safeParse('NoNumPassword!')
      expect(result.success).toBe(false)
    })

    it('should reject password without special character', () => {
      const result = passwordSchema.safeParse('NoSpecial123')
      expect(result.success).toBe(false)
    })
  })

  describe('Username Validation', () => {
    it('should accept valid username', () => {
      const result = usernameSchema.safeParse('test_user123')
      expect(result.success).toBe(true)
    })

    it('should reject username with spaces', () => {
      const result = usernameSchema.safeParse('test user')
      expect(result.success).toBe(false)
    })

    it('should reject short username', () => {
      const result = usernameSchema.safeParse('ab')
      expect(result.success).toBe(false)
    })

    it('should accept username with hyphens', () => {
      const result = usernameSchema.safeParse('test-user-123')
      expect(result.success).toBe(true)
    })

    it('should reject username with special chars', () => {
      const result = usernameSchema.safeParse('test@user!')
      expect(result.success).toBe(false)
    })
  })

  describe('SQL Injection Detection', () => {
    it('should detect SQL injection pattern', () => {
      const malicious = "'; DROP TABLE users; --"
      expect(hasSQLInjectionPattern(malicious)).toBe(true)
    })

    it('should detect UNION-based injection', () => {
      const injection = "' UNION SELECT * FROM users --"
      expect(hasSQLInjectionPattern(injection)).toBe(true)
    })

    it('should allow safe SQL strings', () => {
      const safe = "O'Brien"
      expect(hasSQLInjectionPattern(safe)).toBe(false)
    })

    it('should detect DROP keyword', () => {
      const malicious = "DROP TABLE users"
      expect(hasSQLInjectionPattern(malicious)).toBe(true)
    })
  })

  describe('CSRF Token Generation', () => {
    it('should generate token for user', () => {
      const token = generateCSRFToken('user-123')
      expect(token).toBeTruthy()
      expect(typeof token).toBe('string')
      expect(token).toContain('user-123')
    })

    it('should generate different tokens', () => {
      const token1 = generateCSRFToken('user-123')
      const token2 = generateCSRFToken('user-123')
      expect(token1).not.toBe(token2)
    })

    it('should include timestamp in token', () => {
      const token = generateCSRFToken('user-123')
      const parts = token.split('_')
      expect(parts.length).toBe(3)
      expect(isNaN(Number(parts[1]))).toBe(false)
    })
  })

  describe('Rate Limiting', () => {
    it('should allow requests under limit', () => {
      const allowed = rateLimit('test-ip', 3, 1)
      expect(allowed).toBe(true)
    })

    it('should block requests over limit', () => {
      const key = 'test-ip-2'
      rateLimit(key, 2, 60)
      rateLimit(key, 2, 60)
      const blocked = rateLimit(key, 2, 60)
      expect(blocked).toBe(false)
    })

    it('should use default limit of 100', () => {
      const key = 'default-limit-test'
      for (let i = 0; i < 100; i++) {
        expect(rateLimit(key, 100, 60)).toBe(true)
      }
      expect(rateLimit(key, 100, 60)).toBe(false)
    })
  })
})
