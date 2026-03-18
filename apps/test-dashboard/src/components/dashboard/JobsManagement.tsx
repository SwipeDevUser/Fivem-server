'use client'

import { Job } from '@/types'

interface JobsManagementProps {
  jobs: Job[]
}

export default function JobsManagement({ jobs }: JobsManagementProps) {
  const legalJobs = jobs.filter(j => j.type === 'legal')
  const illegalJobs = jobs.filter(j => j.type === 'illegal')

  const JobsCategorySection = ({ title, jobsList, category }: any) => (
    <div className="mb-6">
      <h3 className="text-lg font-semibold mb-3 text-slate-300">{title}</h3>
      <div className="space-y-2">
        {jobsList.map((job: Job) => (
          <div
            key={job.id}
            className={`p-4 rounded-lg border ${
              category === 'legal'
                ? 'border-blue-500/30 bg-blue-500/10'
                : 'border-red-500/30 bg-red-500/10'
            }`}
          >
            <div className="flex items-center justify-between">
              <div className="flex-1">
                <h4 className="font-semibold text-slate-100">{job.label}</h4>
                <p className="text-sm text-slate-400">Boss: {job.boss?.name || 'N/A'}</p>
              </div>
              <div className="text-right">
                <p className="text-2xl font-bold text-blue-400">{job.occupiedSlots}</p>
                <p className="text-xs text-slate-400">/ {job.maxSlots} slots</p>
              </div>
            </div>
            <div className="mt-2 bg-slate-700 rounded-full h-2 overflow-hidden">
              <div
                className={`h-full ${
                  category === 'legal' ? 'bg-blue-500' : 'bg-red-500'
                }`}
                style={{
                  width: `${Math.min((job.occupiedSlots / job.maxSlots) * 100, 100)}%`,
                }}
              ></div>
            </div>
          </div>
        ))}
      </div>
    </div>
  )

  return (
    <div className="card">
      <h2 className="text-xl font-bold mb-6">Jobs Management</h2>

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">
        <div>
          <JobsCategorySection title="Legal Jobs" jobsList={legalJobs} category="legal" />
        </div>
        <div>
          <JobsCategorySection title="Illegal Jobs" jobsList={illegalJobs} category="illegal" />
        </div>
      </div>

      <div className="grid grid-cols-2 md:grid-cols-4 gap-4 mt-6 pt-6 border-t border-slate-700">
        <div className="text-center">
          <p className="text-2xl font-bold text-blue-400">{legalJobs.length}</p>
          <p className="text-xs text-slate-400 uppercase">Legal Jobs</p>
        </div>
        <div className="text-center">
          <p className="text-2xl font-bold text-red-400">{illegalJobs.length}</p>
          <p className="text-xs text-slate-400 uppercase">Illegal Jobs</p>
        </div>
        <div className="text-center">
          <p className="text-2xl font-bold text-green-400">
            {jobs.reduce((sum, j) => sum + j.occupiedSlots, 0)}
          </p>
          <p className="text-xs text-slate-400 uppercase">Total Players</p>
        </div>
        <div className="text-center">
          <p className="text-2xl font-bold text-purple-400">
            {jobs.reduce((sum, j) => sum + j.maxSlots, 0)}
          </p>
          <p className="text-xs text-slate-400 uppercase">Total Slots</p>
        </div>
      </div>
    </div>
  )
}
