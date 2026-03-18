/**
 * App Overview Page
 * Main dashboard with key metrics and quick access
 */

'use client'

import { mockServerStats, mockServerHealth } from '@/utils/mockData'

export default function OverviewPage() {
  const stats = mockServerStats
  const health = mockServerHealth

  return (
    <div className="space-y-8">
      {/* Server Health */}
      <section className="bg-slate-800 rounded-lg p-6 border border-slate-700">
        <h2 className="text-xl font-bold text-slate-100 mb-4">Server Health</h2>
        <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
          <MetricBox label="Status" value={health.status} />
          <MetricBox label="CPU" value={`${health.cpu}%`} />
          <MetricBox label="Memory" value={`${health.memory}%`} />
          <MetricBox label="Ping" value={`${health.networkLatency}ms`} />
        </div>
      </section>

      {/* Statistics */}
      <section className="bg-slate-800 rounded-lg p-6 border border-slate-700">
        <h2 className="text-xl font-bold text-slate-100 mb-4">Server Statistics</h2>
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
          <StatItem 
            label="Players Online" 
            value={`${stats.onlinePlayers}/${stats.maxPlayers}`} 
            trend={`${Math.round((stats.onlinePlayers / stats.maxPlayers) * 100)}%`}
          />
          <StatItem 
            label="Total Players" 
            value={stats.totalPlayers.toString()} 
            trend="All time"
          />
          <StatItem 
            label="Uptime" 
            value={`${Math.floor(stats.uptime / 86400)} days`} 
            trend="Current session"
          />
        </div>
      </section>

      {/* Economy Overview */}
      <section className="bg-slate-800 rounded-lg p-6 border border-slate-700">
        <h2 className="text-xl font-bold text-slate-100 mb-4">Economy Overview</h2>
        <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
          <StatItem 
            label="Total Cash" 
            value={`$${(stats.totalCash / 1000000).toFixed(1)}M`} 
            trend="In circulation"
          />
          <StatItem 
            label="Total Bank Money" 
            value={`$${(stats.totalBankMoney / 1000000).toFixed(1)}M`} 
            trend="Deposited"
          />
        </div>
      </section>

      {/* Recent Activity */}
      <section className="bg-slate-800 rounded-lg p-6 border border-slate-700">
        <h2 className="text-xl font-bold text-slate-100 mb-4">Activity Summary</h2>
        <div className="space-y-3">
          <ActivityLine label="Active Jobs" value={stats.activeJobs} />
          <ActivityLine label="Active Drug Operations" value={stats.activeDrugs} />
          <ActivityLine label="Pending Contracts" value={stats.pendingContracts} />
          <ActivityLine label="Total Transactions" value={stats.totalTransactions} />
        </div>
      </section>
    </div>
  )
}

function MetricBox({ label, value }: { label: string; value: string }) {
  return (
    <div className="bg-slate-700 rounded p-4 text-center">
      <p className="text-slate-400 text-sm">{label}</p>
      <p className="text-2xl font-bold text-slate-100">{value}</p>
    </div>
  )
}

function StatItem({ label, value, trend }: { label: string; value: string; trend: string }) {
  return (
    <div className="bg-slate-700 rounded-lg p-4">
      <p className="text-slate-400 text-sm">{label}</p>
      <p className="text-3xl font-bold text-blue-400 mt-2">{value}</p>
      <p className="text-xs text-slate-500 mt-2">{trend}</p>
    </div>
  )
}

function ActivityLine({ label, value }: { label: string; value: number }) {
  return (
    <div className="flex items-center justify-between bg-slate-700 rounded px-4 py-2">
      <span className="text-slate-300">{label}</span>
      <span className="text-blue-400 font-semibold">{value}</span>
    </div>
  )
}
