'use client'

import { DrugProduction, DrugMarket } from '@/types'
import { useState, useEffect } from 'react'

interface DrugEconomyProps {
  productions: DrugProduction[]
  markets: DrugMarket[]
}

export default function DrugEconomy({ productions, markets }: DrugEconomyProps) {
  const [activeTab, setActiveTab] = useState<'production' | 'market'>('production')
  const [mounted, setMounted] = useState(false)

  useEffect(() => {
    setMounted(true)
  }, [])

  const getStatusColor = (status: string) => {
    switch (status) {
      case 'active':
        return 'bg-green-500/20 text-green-400 border-green-500/30'
      case 'raided':
        return 'bg-red-500/20 text-red-400 border-red-500/30'
      case 'shut_down':
        return 'bg-yellow-500/20 text-yellow-400 border-yellow-500/30'
      default:
        return 'bg-slate-500/20 text-slate-400 border-slate-500/30'
    }
  }

  return (
    <div className="space-y-6">
      {/* Tabs */}
      <div className="flex gap-2 mb-4">
        <button
          onClick={() => setActiveTab('production')}
          className={`px-4 py-2 rounded-lg transition-colors ${
            activeTab === 'production'
              ? 'bg-blue-600 text-white'
              : 'bg-slate-700 text-slate-400 hover:text-slate-100'
          }`}
        >
          Production Facilities
        </button>
        <button
          onClick={() => setActiveTab('market')}
          className={`px-4 py-2 rounded-lg transition-colors ${
            activeTab === 'market'
              ? 'bg-blue-600 text-white'
              : 'bg-slate-700 text-slate-400 hover:text-slate-100'
          }`}
        >
          Market Prices
        </button>
      </div>

      {/* Production Tab */}
      {activeTab === 'production' && (
        <div className="card">
          <h2 className="text-xl font-bold mb-4">Drug Production Facilities</h2>
          <div className="space-y-4">
            {productions.map((prod) => (
              <div
                key={prod.id}
                className="bg-slate-700/50 rounded-lg p-4 border border-slate-600"
              >
                <div className="flex items-start justify-between mb-3">
                  <div>
                    <h3 className="font-semibold text-slate-100">{prod.name}</h3>
                    <p className="text-sm text-slate-400">📍 {prod.location.city}</p>
                  </div>
                  <span
                    className={`px-3 py-1 rounded-full text-xs font-semibold border ${getStatusColor(
                      prod.status
                    )}`}
                  >
                    {prod.status.toUpperCase()}
                  </span>
                </div>

                <div className="grid grid-cols-2 md:grid-cols-4 gap-3 mb-3">
                  <div>
                    <p className="text-xs text-slate-400 uppercase">Production Rate</p>
                    <p className="text-lg font-bold text-green-400">{prod.productionRate}g/c</p>
                  </div>
                  <div>
                    <p className="text-xs text-slate-400 uppercase">Purity</p>
                    <p className="text-lg font-bold text-blue-400">{prod.purity}%</p>
                  </div>
                  <div>
                    <p className="text-xs text-slate-400 uppercase">Today</p>
                    <p className="text-lg font-bold text-purple-400">{prod.producedToday}g</p>
                  </div>
                  <div>
                    <p className="text-xs text-slate-400 uppercase">Total</p>
                    <p className="text-lg font-bold text-slate-300">{prod.totalProduced}g</p>
                  </div>
                </div>

                <div className="text-xs text-slate-400">
                  Owner: {prod.owner?.name || 'Unknown'} • Next cycle:{' '}
                  {mounted ? new Date(prod.nextCycle).toLocaleString() : 'Loading...'}
                </div>
              </div>
            ))}
          </div>
        </div>
      )}

      {/* Market Tab */}
      {activeTab === 'market' && (
        <div className="card">
          <h2 className="text-xl font-bold mb-4">Black Market Prices</h2>
          <div className="overflow-x-auto">
            <table className="w-full text-sm">
              <thead>
                <tr className="border-b border-slate-700">
                  <th className="text-left py-3 px-3">Drug</th>
                  <th className="text-right py-3 px-3">Price/Gram</th>
                  <th className="text-center py-3 px-3">Demand</th>
                  <th className="text-right py-3 px-3">Supply</th>
                  <th className="text-right py-3 px-3">Transactions</th>
                </tr>
              </thead>
              <tbody>
                {markets.map((market) => (
                  <tr
                    key={market.id}
                    className="border-b border-slate-700 hover:bg-slate-700/50"
                  >
                    <td className="py-3 px-3 font-semibold">{market.drug}</td>
                    <td className="py-3 px-3 text-right text-green-400 font-bold">
                      ${market.pricePerGram}
                    </td>
                    <td className="py-3 px-3 text-center">
                      <span
                        className={`px-2 py-1 rounded text-xs font-semibold ${
                          market.demandLevel === 'high'
                            ? 'bg-red-500/30 text-red-300'
                            : market.demandLevel === 'medium'
                            ? 'bg-yellow-500/30 text-yellow-300'
                            : 'bg-green-500/30 text-green-300'
                        }`}
                      >
                        {market.demandLevel.toUpperCase()}
                      </span>
                    </td>
                    <td className="py-3 px-3 text-right text-slate-300">
                      {market.supply} units
                    </td>
                    <td className="py-3 px-3 text-right text-blue-400">{market.recentTransactions}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      )}
    </div>
  )
}
