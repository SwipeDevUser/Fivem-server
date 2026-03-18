/**
 * Smoke Tests
 * Basic application functionality validation
 */

import { test, expect } from '@playwright/test'

test.describe('Dashboard Smoke Tests', () => {
  test('should load dashboard homepage', async ({ page }) => {
    await page.goto('http://localhost:3000', { waitUntil: 'networkidle' })
    
    // Verify page title
    await expect(page).toHaveTitle(/FiveM Admin Dashboard/)
  })

  test('should display main content', async ({ page }) => {
    await page.goto('http://localhost:3000')
    
    // Wait for main content to load
    const main = page.locator('main')
    await expect(main).toBeVisible({ timeout: 10000 })
  })

  test('should have navigation available', async ({ page }) => {
    await page.goto('http://localhost:3000')
    
    // Look for navigation elements
    const nav = page.locator('nav')
    await expect(nav).toBeVisible({ timeout: 10000 })
  })

  test('should display stat cards on dashboard', async ({ page }) => {
    await page.goto('http://localhost:3000')
    
    // Wait for stat cards to render
    await page.waitForTimeout(2000)
    
    // Look for card elements
    const cards = page.locator('div[class*="card"]')
    const count = await cards.count()
    
    // Should have at least some cards
    expect(count).toBeGreaterThan(0)
  })

  test('should have responsive layout', async ({ page }) => {
    await page.goto('http://localhost:3000')
    
    // Get viewport size
    const size = page.viewportSize()
    expect(size).not.toBeNull()
    
    // Main content should be visible
    const main = page.locator('main')
    await expect(main).toBeVisible()
  })

  test('should render without console errors', async ({ page }) => {
    const errors: string[] = []
    
    page.on('console', msg => {
      if (msg.type() === 'error') {
        errors.push(msg.text())
      }
    })
    
    await page.goto('http://localhost:3000')
    await page.waitForTimeout(2000)
    
    // Should not have critical errors
    const criticalErrors = errors.filter(e => 
      !e.includes('ResizeObserver') &&
      !e.includes('Failed to fetch')
    )
    expect(criticalErrors.length).toBe(0)
  })
})
