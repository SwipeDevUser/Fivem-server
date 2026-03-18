import type { Metadata } from 'next'
import './globals.css'

export const metadata: Metadata = {
  title: 'FiveM Admin Dashboard',
  description: 'Server management dashboard for FiveM servers',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en" suppressHydrationWarning>
      <body className="bg-slate-900 text-slate-100" suppressHydrationWarning>
        {children}
      </body>
    </html>
  )
}
