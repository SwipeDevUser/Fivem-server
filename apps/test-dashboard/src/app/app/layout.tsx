/**
 * App Layout
 * Main authenticated app wrapper with sidebar and top nav
 */

'use client'

import { ReactNode } from 'react'

interface AppLayoutProps {
  children: ReactNode
}

export default function AppLayout({ children }: AppLayoutProps) {
  return (
    <div className="flex h-screen bg-slate-900">
      {/* Sidebar */}
      <aside className="w-64 bg-slate-800 border-r border-slate-700 overflow-y-auto">
        <div className="p-6">
          <h1 className="text-2xl font-bold text-blue-400">FiveM Admin</h1>
        </div>

        <nav className="space-y-1 px-4">
          <NavLink href="/app/overview" icon="📊">
            Overview
          </NavLink>
          <NavLink href="/app/players" icon="👥">
            Players
          </NavLink>
          <NavLink href="/app/characters" icon="🎭">
            Characters
          </NavLink>
          <NavLink href="/app/reports" icon="📋">
            Reports
          </NavLink>
          <NavLink href="/app/moderation" icon="⚖️">
            Moderation
          </NavLink>
          <NavLink href="/app/factions" icon="🏢">
            Factions
          </NavLink>
          <NavLink href="/app/economy" icon="💰">
            Economy
          </NavLink>
          <NavLink href="/app/assets" icon="🏠">
            Assets
          </NavLink>
          <NavLink href="/app/areas" icon="🗺️">
            Areas
          </NavLink>
          <NavLink href="/app/audit" icon="📝">
            Audit Logs
          </NavLink>
          <NavLink href="/app/settings" icon="⚙️">
            Settings
          </NavLink>
          <NavLink href="/app/docs" icon="📚">
            Documentation
          </NavLink>
        </nav>
      </aside>

      {/* Main Content */}
      <div className="flex-1 flex flex-col overflow-hidden">
        {/* Top Nav */}
        <header className="bg-slate-800 border-b border-slate-700 px-8 py-4 flex items-center justify-between">
          <div>
            <h2 className="text-xl font-semibold text-slate-100">Dashboard</h2>
          </div>
          <div className="flex items-center gap-4">
            <button className="px-4 py-2 rounded bg-blue-600 text-white hover:bg-blue-700 transition">
              Search
            </button>
            <button className="px-4 py-2 rounded bg-slate-700 text-slate-300 hover:bg-slate-600 transition">
              Profile
            </button>
          </div>
        </header>

        {/* Content */}
        <main className="flex-1 overflow-auto bg-slate-900 p-8">{children}</main>
      </div>
    </div>
  )
}

function NavLink({ href, icon, children }: { href: string; icon: string; children: ReactNode }) {
  return (
    <a
      href={href}
      className="flex items-center gap-3 px-4 py-2 rounded text-slate-300 hover:bg-slate-700 hover:text-slate-100 transition"
    >
      <span>{icon}</span>
      <span>{children}</span>
    </a>
  )
}
