'use client'

import Navigation from '@/components/layout/Navigation'
import StatCard from '@/components/dashboard/StatCard'
import PlayerStats from '@/components/dashboard/PlayerStats'
import JobsManagement from '@/components/dashboard/JobsManagement'
import DrugEconomy from '@/components/dashboard/DrugEconomy'
import HitmanContracts from '@/components/dashboard/HitmanContracts'
import { useEffect, useState } from 'react'

import {
  mockServerStats,
  mockPlayers,
  mockJobs,
  mockDrugProductions,
  mockDrugMarkets,
  mockContracts,
} from '@/utils/mockData'

export default function Dashboard() {
  const [mounted, setMounted] = useState(false)
  const stats = mockServerStats

  useEffect(() => {
    setMounted(true)
  }, [])

  return (
    <div className="min-h-screen bg-slate-900">
      <Navigation />

      <main className="max-w-7xl mx-auto px-4 py-8">
        {/* Stats Cards */}
        <div className="grid-responsive mb-8">
          <StatCard
            title="Online Players"
            value={stats.onlinePlayers}
            icon="👥"
            color="blue"
            trend={{ value: 12, direction: 'up' }}
          />
          <StatCard
            title="Total Players"
            value={stats.totalPlayers}
            icon="🎮"
            color="green"
            trend={{ value: 5, direction: 'up' }}
          />
          <StatCard
            title="Active Jobs"
            value={stats.activeJobs}
            icon="💼"
            color="purple"
          />
          <StatCard
            title="Pending Contracts"
            value={stats.pendingContracts}
            icon="🎯"
            color="red"
            trend={{ value: 3, direction: 'up' }}
          />
        </div>

        {/* Money Stats */}
        <div className="grid md:grid-cols-2 gap-4 mb-8">
          <StatCard
            title="Total Cash Circulation"
            value={`$${(stats.totalCash / 1000).toFixed(1)}K`}
            icon="💰"
            color="green"
          />
          <StatCard
            title="Total Bank Money"
            value={`$${(stats.totalBankMoney / 1000).toFixed(1)}K`}
            icon="🏦"
            color="blue"
          />
        </div>

        {/* Main Dashboard Sections */}
        <div className="space-y-8">
          {/* Player Management */}
          <section>
            <PlayerStats players={mockPlayers} />
          </section>

          {/* Jobs Management */}
          <section>
            <JobsManagement jobs={mockJobs} />
          </section>

          {/* Drug Economy */}
          <section>
            <DrugEconomy productions={mockDrugProductions} markets={mockDrugMarkets} />
          </section>

          {/* Hitman Contracts */}
          <section>
            <HitmanContracts contracts={mockContracts} />
          </section>
        </div>
      </main>

      {/* Footer */}
      <footer className="bg-slate-900 border-t border-slate-800 mt-12 py-6">
        <div className="max-w-7xl mx-auto px-4 text-center text-slate-500 text-sm">
          <p>FiveM Server Admin Dashboard • Built with Next.js</p>
          <p className="mt-2">
            Last Updated: {mounted ? new Date().toLocaleString() : 'Loading...'}
          </p>
        </div>
      </footer>
    </div>
  )
}
