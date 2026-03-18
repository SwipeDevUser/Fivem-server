/**
 * Areas / Geography Page
 * Displays all Florida regions and allows filtering by area
 */

'use client'

import { useState } from 'react'
import { allAreas, getAreasByRegion } from '@/data/areas'
import { FloridaRegion } from '@/types'

export default function AreasPage() {
  const [selectedRegion, setSelectedRegion] = useState<FloridaRegion | null>(null)
  const [searchQuery, setSearchQuery] = useState('')

  const regions: FloridaRegion[] = ['orlando', 'jacksonville', 'miami', 'daytona']

  let displayedAreas = allAreas

  if (selectedRegion) {
    displayedAreas = getAreasByRegion(selectedRegion)
  }

  if (searchQuery) {
    displayedAreas = displayedAreas.filter(
      (area) =>
        area.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
        area.description.toLowerCase().includes(searchQuery.toLowerCase())
    )
  }

  return (
    <div className="space-y-8">
      {/* Header */}
      <div>
        <h1 className="text-3xl font-bold text-slate-100 mb-2">Florida Geography</h1>
        <p className="text-slate-400">Complete area taxonomy with regional dynamics</p>
      </div>

      {/* Region Selection */}
      <div className="bg-slate-800 rounded-lg p-6 border border-slate-700">
        <h2 className="text-lg font-semibold text-slate-100 mb-4">Regions</h2>
        <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
          {regions.map((region) => (
            <button
              key={region}
              onClick={() => setSelectedRegion(selectedRegion === region ? null : region)}
              className={`px-4 py-3 rounded-lg font-semibold transition capitalize ${
                selectedRegion === region
                  ? 'bg-blue-600 text-white'
                  : 'bg-slate-700 text-slate-300 hover:bg-slate-600'
              }`}
            >
              {region}
            </button>
          ))}
        </div>
      </div>

      {/* Search */}
      <div className="flex gap-4">
        <input
          type="text"
          placeholder="Search areas..."
          value={searchQuery}
          onChange={(e) => setSearchQuery(e.target.value)}
          className="flex-1 bg-slate-700 border border-slate-600 rounded px-4 py-2 text-slate-100 placeholder-slate-400"
        />
      </div>

      {/* Areas Grid */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        {displayedAreas.map((area) => (
          <div key={area.id} className="bg-slate-800 rounded-lg p-6 border border-slate-700 hover:border-blue-500 transition">
            <div className="mb-4">
              <h3 className="text-lg font-bold text-slate-100">{area.name}</h3>
              <p className="text-xs text-slate-500 capitalize">{area.region}</p>
            </div>

            <p className="text-slate-400 text-sm mb-4">{area.description}</p>

            <div className="space-y-2 text-sm">
              <div className="flex justify-between">
                <span className="text-slate-400">Population:</span>
                <span className="text-slate-200 font-semibold">{area.population}</span>
              </div>
              <div className="flex justify-between">
                <span className="text-slate-400">Properties:</span>
                <span className="text-slate-200 font-semibold">{area.properties}</span>
              </div>
              <div className="flex justify-between">
                <span className="text-slate-400">Crime Rate:</span>
                <span className={`font-semibold ${area.crimeRate > 0.3 ? 'text-red-400' : area.crimeRate > 0.15 ? 'text-yellow-400' : 'text-green-400'}`}>
                  {Math.round(area.crimeRate * 100)}%
                </span>
              </div>
              <div className="flex justify-between">
                <span className="text-slate-400">Prosperity:</span>
                <span className={`font-semibold ${area.prosperity > 0.8 ? 'text-green-400' : area.prosperity > 0.6 ? 'text-blue-400' : 'text-orange-400'}`}>
                  {Math.round(area.prosperity * 100)}%
                </span>
              </div>
            </div>

            <button className="w-full mt-4 px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700 transition text-sm font-semibold">
              View Details
            </button>
          </div>
        ))}
      </div>

      {displayedAreas.length === 0 && (
        <div className="text-center py-12">
          <p className="text-slate-400">No areas found matching your search</p>
        </div>
      )}
    </div>
  )
}
