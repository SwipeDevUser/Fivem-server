interface StatCardProps {
  title: string
  value: string | number
  icon: string
  color?: 'blue' | 'green' | 'red' | 'purple'
  trend?: {
    value: number
    direction: 'up' | 'down'
  }
}

export default function StatCard({
  title,
  value,
  icon,
  color = 'blue',
  trend,
}: StatCardProps) {
  const colorClasses = {
    blue: 'border-blue-500/30 bg-blue-500/10',
    green: 'border-green-500/30 bg-green-500/10',
    red: 'border-red-500/30 bg-red-500/10',
    purple: 'border-purple-500/30 bg-purple-500/10',
  }

  const textColorClasses = {
    blue: 'text-blue-400',
    green: 'text-green-400',
    red: 'text-red-400',
    purple: 'text-purple-400',
  }

  return (
    <div className={`card border ${colorClasses[color]}`}>
      <div className="flex items-center justify-between">
        <div>
          <p className="stat-label">{title}</p>
          <p className={`stat-value ${textColorClasses[color]}`}>{value}</p>
          {trend && (
            <p className="text-xs mt-2 text-slate-400">
              <span className={trend.direction === 'up' ? 'text-green-400' : 'text-red-400'}>
                {trend.direction === 'up' ? '↑' : '↓'} {Math.abs(trend.value)}%
              </span>
            </p>
          )}
        </div>
        <div className="text-4xl">{icon}</div>
      </div>
    </div>
  )
}
