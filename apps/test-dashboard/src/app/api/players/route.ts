/**
 * Players API Route
 * Endpoints: GET /api/players, GET /api/players/[id], PATCH /api/players/[id]
 */

import { NextRequest, NextResponse } from 'next/server'
import { ListResponse, Player, ApiResponse } from '@/types'
import { mockPlayers } from '@/utils/mockData'

// GET /api/players - List all players with pagination and filtering
export async function GET(request: NextRequest) {
  try {
    const searchParams = request.nextUrl.searchParams

    // Pagination
    const page = parseInt(searchParams.get('page') ?? '1')
    const pageSize = parseInt(searchParams.get('pageSize') ?? '10')
    const offset = (page - 1) * pageSize

    // Filtering
    const status = searchParams.get('status')
    const search = searchParams.get('search')?.toLowerCase()

    // Filter players
    let filtered = [...mockPlayers]

    if (status) {
      filtered = filtered.filter((p) => p.status === status)
    }

    if (search) {
      filtered = filtered.filter(
        (p) =>
          p.name.toLowerCase().includes(search) ||
          p.steamId.includes(search) ||
          p.identifier.includes(search)
      )
    }

    // Paginate
    const total = filtered.length
    const paginatedPlayers = filtered.slice(offset, offset + pageSize)

    const response: ListResponse<Player> = {
      success: true,
      data: paginatedPlayers,
      meta: {
        page,
        pageSize,
        total,
        totalPages: Math.ceil(total / pageSize),
      },
    }

    return NextResponse.json(response)
  } catch (error) {
    return NextResponse.json(
      {
        success: false,
        error: {
          code: 'SERVER_ERROR',
          message: 'Failed to fetch players',
        },
      },
      { status: 500 }
    )
  }
}

// PATCH /api/players/[id] - Update player
export async function PATCH(request: NextRequest, { params }: { params: { id: string } }) {
  try {
    const { id } = params
    const body = await request.json()

    // TODO: Validate permissions (players.manage)
    // TODO: Validate input
    // TODO: Update database
    // TODO: Log audit trail

    const player = mockPlayers.find((p) => p.id === id)
    if (!player) {
      return NextResponse.json(
        {
          success: false,
          error: {
            code: 'NOT_FOUND',
            message: 'Player not found',
          },
        },
        { status: 404 }
      )
    }

    const updated = { ...player, ...body }

    const response: ApiResponse<Player> = {
      success: true,
      data: updated,
    }

    return NextResponse.json(response)
  } catch (error) {
    return NextResponse.json(
      {
        success: false,
        error: {
          code: 'SERVER_ERROR',
          message: 'Failed to update player',
        },
      },
      { status: 500 }
    )
  }
}

// POST /api/players/[id]/ban - Ban a player
export async function POST(request: NextRequest, { params }: { params: { id: string } }) {
  try {
    const { id } = params
    const body = await request.json()
    const { reason, duration } = body

    // TODO: Validate permissions (players.ban)
    // TODO: Create ban record
    // TODO: Kick player if online
    // TODO: Log audit trail

    return NextResponse.json({
      success: true,
      data: {
        id,
        banned: true,
        reason,
        duration,
        bannedAt: new Date().toISOString(),
      },
    })
  } catch (error) {
    return NextResponse.json(
      {
        success: false,
        error: {
          code: 'SERVER_ERROR',
          message: 'Failed to ban player',
        },
      },
      { status: 500 }
    )
  }
}
