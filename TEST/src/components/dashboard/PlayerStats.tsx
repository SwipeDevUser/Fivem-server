'use client'

import { Player } from '@/types'
import { useState } from 'react'

interface PlayerStatsProps {
  players: Player[]
}

export default function PlayerStats({ players }: PlayerStatsProps) {
  const [sortBy, setSortBy] = useState<'money' | 'playtime' | 'name'>('money')
  const [filterJob, setFilterJob] = useState<string>('all')

  // Get unique jobs from characters
  const uniqueJobs = ['all', ...new Set(
    players
      .flatMap(p => p.characters.map(c => c.job))
      .filter(Boolean)
  )]

  const filteredPlayers = filterJob === 'all' 
    ? players 
    : players.filter(p => p.characters.some(c => c.job === filterJob))

  const sortedPlayers = [...filteredPlayers].sort((a, b) => {
    if (sortBy === 'money') return b.totalMoney - a.totalMoney
    if (sortBy === 'playtime') return b.playtimeMinutes - a.playtimeMinutes
    return a.name.localeCompare(b.name)
  })

  const formatMoney = (amount: number) => `$${amount.toLocaleString()}`
  const formatPlaytime = (minutes: number) => {
    const hours = Math.floor(minutes / 60)
    const mins = minutes % 60
    return `${hours}h ${mins}m`
  }

  return (
    <div className="card">
      <h2 className="text-xl font-bold mb-4">Player Statistics</h2>

      <div className="flex gap-4 mb-4 flex-wrap">
        <div>
          <label className="block text-sm text-slate-400 mb-1">Sort By</label>
          <select
            value={sortBy}
            onChange={(e) => setSortBy(e.target.value as any)}
            className="bg-slate-700 border border-slate-600 px-3 py-1 rounded text-sm"
          >
            <option value="money">Money</option>
            <option value="playtime">Playtime</option>
            <option value="name">Name</option>
          </select>
        </div>
        <div>
          <label className="block text-sm text-slate-400 mb-1">Filter Job</label>
          <select
            value={filterJob}
            onChange={(e) => setFilterJob(e.target.value)}
            className="bg-slate-700 border border-slate-600 px-3 py-1 rounded text-sm"
          >
            {uniqueJobs.map(job => (
              <option key={job} value={job}>
                {job === 'all' ? 'All Jobs' : job}
              </option>
            ))}
          </select>
        </div>
      </div>

      <div className="overflow-x-auto">
        <table className="w-full text-sm">
          <thead>
            <tr className="border-b border-slate-700">
              <th className="text-left py-2 px-2">Name</th>
              <th className="text-left py-2 px-2">Character</th>
              <th className="text-left py-2 px-2">Job</th>
              <th className="text-right py-2 px-2">Cash</th>
              <th className="text-right py-2 px-2">Bank</th>
              <th className="text-right py-2 px-2">Playtime</th>
              <th className="text-center py-2 px-2">Status</th>
            </tr>
          </thead>
          <tbody>
            {sortedPlayers.map((player) => {
              const primaryChar = player.characters[0]
              const jobDisplay = primaryChar?.job || 'Unemployed'
              return (
              <tr key={player.id} className="border-b border-slate-700 hover:bg-slate-700/50">
                <td className="py-3 px-2">{player.name}</td>
                <td className="py-3 px-2">{primaryChar ? `${primaryChar.firstName} ${primaryChar.lastName}` : 'N/A'}</td>
                <td className="py-3 px-2">
                  <span className={`px-2 py-1 rounded text-xs font-semibold ${
                    jobDisplay === 'police' ? 'bg-blue-500/30 text-blue-300' :
                    jobDisplay === 'ems' ? 'bg-green-500/30 text-green-300' :
                    jobDisplay === 'mafia' || jobDisplay === 'gang' ? 'bg-red-500/30 text-red-300' :
                    'bg-slate-600/30 text-slate-300'
                  }`}>
                    {jobDisplay}
                  </span>
                </td>
                <td className="py-3 px-2 text-right text-green-400">{formatMoney(player.totalMoney)}</td>
                <td className="py-3 px-2 text-right text-blue-400">{formatMoney(player.totalBankMoney)}</td>
                <td className="py-3 px-2 text-right">{formatPlaytime(player.playtimeMinutes)}</td>
                <td className="py-3 px-2 text-center">
                  <span className={`inline-block w-2 h-2 rounded-full ${
                    player.status === 'online' ? 'bg-green-500' : 'bg-slate-500'
                  }`}></span>
                </td>
              </tr>
            )
            })}
          </tbody>
        </table>
      </div>

      <div className="mt-4 text-sm text-slate-400">
        Showing {sortedPlayers.length} of {players.length} players
      </div>
    </div>
  )
}
