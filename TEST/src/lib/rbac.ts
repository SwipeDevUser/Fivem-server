/**
 * Role-Based Access Control (RBAC) Middleware
 * Enforces permission-based access to API endpoints
 */

import { NextRequest, NextResponse } from 'next/server'
import { Permission, UserRole } from '@/types'

// Permission matrix: Role -> Permissions
const rolePermissions: Record<UserRole, Permission[]> = {
  admin: [
    'players.view',
    'players.manage',
    'players.ban',
    'players.kick',
    'jobs.manage',
    'economy.view',
    'economy.manage',
    'reports.view',
    'reports.manage',
    'audit.view',
    'settings.manage',
  ],
  moderator: [
    'players.view',
    'players.kick',
    'reports.view',
    'reports.manage',
    'audit.view',
  ],
  manager: [
    'players.view',
    'jobs.manage',
    'economy.view',
    'reports.view',
  ],
  viewer: [
    'players.view',
    'economy.view',
    'reports.view',
    'audit.view',
  ],
}

interface AuthContext {
  userId: string
  role: UserRole
  permissions: Permission[]
}

/**
 * Extracts and validates JWT from request
 */
export async function validateAuth(request: NextRequest): Promise<AuthContext | null> {
  try {
    const authHeader = request.headers.get('authorization')
    if (!authHeader?.startsWith('Bearer ')) {
      return null
    }

    // TODO: Verify JWT signature
    // TODO: Check token expiration
    // TODO: Extract user info from token

    // Placeholder: Extract from mock token
    const token = authHeader.slice(7)
    if (!token) return null

    // Mock user context
    return {
      userId: 'admin-1',
      role: 'admin',
      permissions: rolePermissions.admin,
    }
  } catch {
    return null
  }
}

/**
 * Middleware factory to check permissions
 */
export function requirePermission(...requiredPermissions: Permission[]) {
  return async (request: NextRequest) => {
    const auth = await validateAuth(request)

    if (!auth) {
      return NextResponse.json(
        {
          success: false,
          error: {
            code: 'UNAUTHORIZED',
            message: 'Authentication required',
          },
        },
        { status: 401 }
      )
    }

    const hasPermission = requiredPermissions.some((perm) => auth.permissions.includes(perm))
    if (!hasPermission) {
      return NextResponse.json(
        {
          success: false,
          error: {
            code: 'FORBIDDEN',
            message: 'Insufficient permissions',
          },
        },
        { status: 403 }
      )
    }

    // Attach auth context to request for route handlers
    ;(request as any).auth = auth
    return null
  }
}

/**
 * Check if user has specific permission
 */
export function hasPermission(auth: AuthContext | null, permission: Permission): boolean {
  if (!auth) return false
  return auth.permissions.includes(permission)
}
