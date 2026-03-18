/**
 * Reports API Route
 * Endpoints for managing player reports
 */

import { NextRequest, NextResponse } from 'next/server'
import { ListResponse, Report, ApiResponse } from '@/types'
import { mockReports } from '@/utils/mockData'

export async function GET(request: NextRequest) {
  try {
    const searchParams = request.nextUrl.searchParams

    // Pagination
    const page = parseInt(searchParams.get('page') ?? '1')
    const pageSize = parseInt(searchParams.get('pageSize') ?? '10')
    const offset = (page - 1) * pageSize

    // Filtering
    const status = searchParams.get('status')
    const priority = searchParams.get('priority')

    // Filter reports
    let filtered = [...mockReports]

    if (status) {
      filtered = filtered.filter((r) => r.status === status)
    }

    if (priority) {
      filtered = filtered.filter((r) => r.priority === priority)
    }

    // Sort by creation date (newest first)
    filtered.sort((a, b) => new Date(b.createdAt).getTime() - new Date(a.createdAt).getTime())

    // Paginate
    const total = filtered.length
    const paginatedReports = filtered.slice(offset, offset + pageSize)

    const response: ListResponse<Report> = {
      success: true,
      data: paginatedReports,
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
          message: 'Failed to fetch reports',
        },
      },
      { status: 500 }
    )
  }
}

export async function POST(request: NextRequest) {
  try {
    const body = await request.json()

    // TODO: Validate input
    // TODO: Create report in database
    // TODO: Send notifications to moderators
    // TODO: Log audit trail

    const newReport: Report = {
      id: `report-${Date.now()}`,
      reporter: body.reporter,
      subject: body.subject,
      category: body.category,
      description: body.description,
      attachments: [],
      status: 'open',
      priority: 'medium',
      createdAt: new Date().toISOString(),
    }

    const response: ApiResponse<Report> = {
      success: true,
      data: newReport,
    }

    return NextResponse.json(response, { status: 201 })
  } catch (error) {
    return NextResponse.json(
      {
        success: false,
        error: {
          code: 'SERVER_ERROR',
          message: 'Failed to create report',
        },
      },
      { status: 500 }
    )
  }
}

// PATCH /api/reports/[id] - Update report
export async function PATCH(request: NextRequest, { params }: { params: { id: string } }) {
  try {
    const { id } = params
    const body = await request.json()

    // TODO: Validate permissions (reports.manage)
    // TODO: Update database
    // TODO: If status changed to resolved, log resolution
    // TODO: Notify relevant parties

    const report = mockReports.find((r) => r.id === id)
    if (!report) {
      return NextResponse.json(
        {
          success: false,
          error: {
            code: 'NOT_FOUND',
            message: 'Report not found',
          },
        },
        { status: 404 }
      )
    }

    const updated = {
      ...report,
      ...body,
      resolvedAt: body.status === 'resolved' ? new Date().toISOString() : undefined,
    }

    const response: ApiResponse<Report> = {
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
          message: 'Failed to update report',
        },
      },
      { status: 500 }
    )
  }
}
