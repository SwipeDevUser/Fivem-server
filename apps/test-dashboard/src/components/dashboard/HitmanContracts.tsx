'use client'

import { HitmanContract } from '@/types'
import { useState, useEffect } from 'react'

interface HitmanContractsProps {
  contracts: HitmanContract[]
}

export default function HitmanContracts({ contracts }: HitmanContractsProps) {
  const [filterStatus, setFilterStatus] = useState<string>('all')
  const [mounted, setMounted] = useState(false)

  useEffect(() => {
    setMounted(true)
  }, [])

  const filteredContracts =
    filterStatus === 'all' ? contracts : contracts.filter(c => c.status === filterStatus)

  const getStatusColor = (status: string) => {
    switch (status) {
      case 'pending':
        return 'bg-yellow-500/20 text-yellow-400 border-yellow-500/30'
      case 'in_progress':
        return 'bg-blue-500/20 text-blue-400 border-blue-500/30'
      case 'completed':
        return 'bg-green-500/20 text-green-400 border-green-500/30'
      case 'failed':
        return 'bg-red-500/20 text-red-400 border-red-500/30'
      case 'cancelled':
        return 'bg-slate-500/20 text-slate-400 border-slate-500/30'
      default:
        return 'bg-slate-500/20 text-slate-400 border-slate-500/30'
    }
  }

  const statusCounts = {
    pending: contracts.filter(c => c.status === 'pending').length,
    in_progress: contracts.filter(c => c.status === 'in_progress').length,
    completed: contracts.filter(c => c.status === 'completed').length,
    failed: contracts.filter(c => c.status === 'failed').length,
    cancelled: contracts.filter(c => c.status === 'cancelled').length,
  }

  return (
    <div className="space-y-6">
      {/* Contract Stats */}
      <div className="grid grid-cols-2 md:grid-cols-5 gap-2">
        {[
          { label: 'Pending', key: 'pending', color: 'yellow' },
          { label: 'In Progress', key: 'in_progress', color: 'blue' },
          { label: 'Completed', key: 'completed', color: 'green' },
          { label: 'Failed', key: 'failed', color: 'red' },
          { label: 'Cancelled', key: 'cancelled', color: 'purple' },
        ].map(({ label, key, color }) => (
          <button
            key={key}
            onClick={() => setFilterStatus(filterStatus === key ? 'all' : key)}
            className={`p-2 rounded-lg text-center transition-colors ${
              filterStatus === key
                ? `bg-${color}-600 text-white`
                : `bg-slate-700 text-slate-300 hover:text-slate-100`
            }`}
          >
            <p className="font-bold text-lg">{statusCounts[key as keyof typeof statusCounts]}</p>
            <p className="text-xs">{label}</p>
          </button>
        ))}
      </div>

      {/* Contracts List */}
      <div className="card">
        <h2 className="text-xl font-bold mb-4">Hitman Contracts</h2>
        <div className="space-y-3">
          {filteredContracts.length > 0 ? (
            filteredContracts.map((contract) => (
              <div
                key={contract.id}
                className="bg-slate-700/50 rounded-lg p-4 border border-slate-600 hover:border-slate-500 transition-colors"
              >
                <div className="flex items-start justify-between mb-3">
                  <div className="flex-1">
                    <div className="flex items-center gap-3">
                      <h3 className="font-semibold text-slate-100">{contract.id}</h3>
                      <span
                        className={`px-3 py-1 rounded-full text-xs font-semibold border ${getStatusColor(
                          contract.status
                        )}`}
                      >
                        {contract.status.replace('_', ' ').toUpperCase()}
                      </span>
                    </div>
                    <p className="text-sm text-slate-400 mt-1">{contract.description}</p>
                  </div>
                  <div className="text-right">
                    <p className="text-2xl font-bold text-green-400">${contract.reward.toLocaleString()}</p>
                    <p className="text-xs text-slate-400">Reward</p>
                  </div>
                </div>

                <div className="grid grid-cols-2 md:grid-cols-4 gap-3 mb-3 py-3 border-y border-slate-600">
                  <div>
                    <p className="text-xs text-slate-400 uppercase">Target</p>
                    <p className="font-semibold text-slate-100">{contract.target.name}</p>
                  </div>
                  <div>
                    <p className="text-xs text-slate-400 uppercase">Assassin</p>
                    <p className="font-semibold text-slate-100">
                      {!contract.assassin ? (
                        <span className="text-yellow-400">Unassigned</span>
                      ) : (
                        contract.assassin.name
                      )}
                    </p>
                  </div>
                  <div>
                    <p className="text-xs text-slate-400 uppercase">Location</p>
                    <p className="font-semibold text-slate-100">-</p>
                  </div>
                  <div>
                    <p className="text-xs text-slate-400 uppercase">Deadline</p>
                    <p className="font-semibold text-slate-100">
                      {mounted ? new Date(contract.deadline).toLocaleDateString() : 'Loading...'}
                    </p>
                  </div>
                </div>

                {/* Progress Bar */}
                {contract.progress !== undefined && (
                  <div>
                    <div className="flex justify-between items-center mb-1">
                      <p className="text-xs text-slate-400">Progress</p>
                      <p className="text-xs font-semibold text-slate-300">{contract.progress}%</p>
                    </div>
                    <div className="bg-slate-800 rounded-full h-2 overflow-hidden">
                      <div
                        className={`h-full ${
                          contract.progress === 100
                            ? 'bg-green-500'
                            : contract.status === 'in_progress'
                            ? 'bg-blue-500'
                            : 'bg-slate-600'
                        }`}
                        style={{ width: `${contract.progress}%` }}
                      ></div>
                    </div>
                  </div>
                )}
              </div>
            ))
          ) : (
            <div className="text-center py-8">
              <p className="text-slate-400">No contracts found</p>
            </div>
          )}
        </div>
      </div>
    </div>
  )
}
