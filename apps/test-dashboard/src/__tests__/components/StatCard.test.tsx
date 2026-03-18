/**
 * Component Tests
 * Testing UI component rendering and interactions
 */

import React from 'react'
import { render, screen } from '@testing-library/react'
import StatCard from '@/components/dashboard/StatCard'

describe('StatCard Component', () => {
  it('should render title', () => {
    render(
      <StatCard
        title="Test Title"
        value={100}
        icon="🎮"
      />
    )
    expect(screen.getByText('Test Title')).toBeInTheDocument()
  })

  it('should render value', () => {
    render(
      <StatCard
        title="Players"
        value={42}
        icon="👥"
      />
    )
    expect(screen.getByText('42')).toBeInTheDocument()
  })

  it('should render with trend up', () => {
    const { container } = render(
      <StatCard
        title="Trending"
        value={100}
        icon="📈"
        trend={{ value: 5, direction: 'up' }}
      />
    )
    expect(container).toBeInTheDocument()
  })

  it('should render with different color variants', () => {
    const { rerender } = render(
      <StatCard
        title="Test"
        value={100}
        icon="🎮"
        color="blue"
      />
    )
    expect(screen.getByText('Test')).toBeInTheDocument()

    rerender(
      <StatCard
        title="Test"
        value={100}
        icon="🎮"
        color="green"
      />
    )
    expect(screen.getByText('Test')).toBeInTheDocument()
  })
})
