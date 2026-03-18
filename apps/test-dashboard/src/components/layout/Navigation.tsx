'use client'

import { useState } from 'react'

export default function Navigation() {
  const [activeTab, setActiveTab] = useState('dashboard')

  const tabs = [
    { id: 'dashboard', label: 'Dashboard', icon: '📊' },
    { id: 'players', label: 'Players', icon: '👥' },
    { id: 'jobs', label: 'Jobs', icon: '💼' },
    { id: 'drugs', label: 'Drug Economy', icon: '💊' },
    { id: 'contracts', label: 'Hitman Contracts', icon: '🎯' },
  ]

  return (
    <nav className="bg-slate-900 border-b border-slate-700 sticky top-0 z-50">
      <div className="max-w-7xl mx-auto px-4">
        <div className="flex items-center justify-between h-16">
          <div className="flex items-center gap-8">
            <h1 className="text-2xl font-bold text-blue-400">FiveM Admin</h1>
            <div className="hidden md:flex gap-1">
              {tabs.map(tab => (
                <button
                  key={tab.id}
                  onClick={() => setActiveTab(tab.id)}
                  className={`px-4 py-2 rounded-lg transition-colors flex items-center gap-2 ${
                    activeTab === tab.id
                      ? 'bg-blue-600 text-white'
                      : 'text-slate-400 hover:text-slate-100'
                  }`}
                >
                  <span>{tab.icon}</span>
                  <span>{tab.label}</span>
                </button>
              ))}
            </div>
          </div>
          <div className="text-sm text-slate-400">Server Status: Online</div>
        </div>
      </div>
    </nav>
  )
}
