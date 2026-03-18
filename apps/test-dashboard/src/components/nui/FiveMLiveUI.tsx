/**
 * FiveM NUI UI Component
 * In-game dashboard UI designed for Chromium Embedded Framework
 * Optimized for in-game rendering and interaction
 */

'use client'

import { useEffect, useState } from 'react'
import { sendNUIMessage, registerNUICallback } from '@/lib/nui-bridge'

interface PlayerUIData {
  name: string
  job: string
  money: number
  bankMoney: number
  health: number
  armor: number
  location: string
}

export default function FiveMLiveUI() {
  const [visible, setVisible] = useState(true)
  const [playerData, setPlayerData] = useState<PlayerUIData | null>(null)
  const [activeTab, setActiveTab] = useState<'info' | 'economy' | 'jobs'>('info')

  useEffect(() => {
    // Register NUI callbacks for live updates
    registerNUICallback('updatePlayerUI', async (data: unknown) => {
      setPlayerData(data as PlayerUIData)
      return { success: true }
    })

    // Hide UI when ESC pressed
    const handleKeyPress = (e: KeyboardEvent) => {
      if (e.key === 'Escape') {
        setVisible(false)
        sendNUIMessage({ action: 'hideUI' })
      }
    }

    window.addEventListener('keydown', handleKeyPress)
    return () => window.removeEventListener('keydown', handleKeyPress)
  }, [])

  if (!visible || !playerData) {
    return null
  }

  return (
    <div className="fixed bottom-4 right-4 w-96 bg-slate-900 rounded-lg border-2 border-blue-500 shadow-2xl z-50 font-sans">
      {/* Header */}
      <div className="bg-blue-600 px-4 py-3 rounded-t-lg flex justify-between items-center">
        <h2 className="text-white font-bold text-lg">Dashboard</h2>
        <button
          onClick={() => {
            setVisible(false)
            sendNUIMessage({ action: 'closeUI' })
          }}
          className="text-white hover:text-slate-200 font-bold text-xl"
        >
          ✕
        </button>
      </div>

      {/* Tabs */}
      <div className="flex gap-0 bg-slate-800 border-b border-slate-700">
        {(['info', 'economy', 'jobs'] as const).map((tab) => (
          <button
            key={tab}
            onClick={() => setActiveTab(tab)}
            className={`flex-1 px-4 py-2 font-semibold text-sm transition capitalize ${
              activeTab === tab
                ? 'bg-blue-600 text-white border-b-2 border-blue-400'
                : 'text-slate-400 hover:text-slate-200'
            }`}
          >
            {tab}
          </button>
        ))}
      </div>

      {/* Content */}
      <div className="p-4 space-y-3 max-h-96 overflow-y-auto">
        {activeTab === 'info' && (
          <div className="space-y-2">
            <InfoRow label="Name" value={playerData.name} />
            <InfoRow label="Job" value={playerData.job} />
            <InfoRow label="Location" value={playerData.location} />
            <HealthBar label="Health" value={playerData.health} max={200} />
            <HealthBar label="Armor" value={playerData.armor} max={100} />
          </div>
        )}

        {activeTab === 'economy' && (
          <div className="space-y-2">
            <MoneyRow label="Cash" value={playerData.money} />
            <MoneyRow label="Bank" value={playerData.bankMoney} />
            <div className="mt-4 p-2 bg-slate-800 rounded text-xs text-slate-400">
              <p>Total Assets: ${(playerData.money + playerData.bankMoney).toLocaleString()}</p>
            </div>
          </div>
        )}

        {activeTab === 'jobs' && (
          <div className="space-y-2">
            <div className="p-3 bg-slate-800 rounded-lg">
              <h3 className="text-slate-100 font-semibold mb-2">{playerData.job}</h3>
              <p className="text-xs text-slate-400">Access job-specific controls</p>
            </div>
          </div>
        )}
      </div>

      {/* Footer */}
      <div className="bg-slate-800 px-4 py-2 rounded-b-lg border-t border-slate-700 text-xs text-slate-500 text-center">
        Press ESC to close
      </div>
    </div>
  )
}

function InfoRow({ label, value }: { label: string; value: string }) {
  return (
    <div className="flex justify-between items-center bg-slate-800 px-3 py-2 rounded text-sm">
      <span className="text-slate-400">{label}</span>
      <span className="text-slate-100 font-semibold">{value}</span>
    </div>
  )
}

function MoneyRow({ label, value }: { label: string; value: number }) {
  return (
    <div className="flex justify-between items-center bg-slate-800 px-3 py-2 rounded text-sm">
      <span className="text-slate-400">{label}</span>
      <span className="text-green-400 font-semibold">${value.toLocaleString()}</span>
    </div>
  )
}

function HealthBar({ label, value, max }: { label: string; value: number; max: number }) {
  const percentage = (value / max) * 100
  const color = percentage > 50 ? 'bg-green-500' : percentage > 25 ? 'bg-yellow-500' : 'bg-red-500'

  return (
    <div className="bg-slate-800 px-3 py-2 rounded">
      <div className="flex justify-between items-center mb-1 text-sm">
        <span className="text-slate-400">{label}</span>
        <span className="text-slate-100 font-semibold">{value}</span>
      </div>
      <div className="w-full bg-slate-700 rounded h-2 overflow-hidden">
        <div className={`h-full ${color} transition-all`} style={{ width: `${percentage}%` }} />
      </div>
    </div>
  )
}
