/**
 * Comprehensive Mock Data
 * Enterprise-grade test data for all dashboard features
 * Production-ready data structure
 */

import {
  Player,
  Character,
  User,
  Job,
  DrugProduction,
  DrugMarket,
  HitmanContract,
  Report,
  ServerStats,
  ServerHealth,
} from '@/types'
import { allAreas } from '@/data/areas'

// ============================================================================
// ADMIN USERS
// ============================================================================

export const mockAdminUsers: User[] = [
  {
    id: 'admin-1',
    username: 'admin',
    email: 'admin@fivem.local',
    role: 'admin',
    permissions: [
      'players.view',
      'players.manage',
      'players.ban',
      'players.kick',
      'jobs.manage',
      'economy.view',
      'economy.manage',
      'reports.view',
      'reports.manage',
      'audit.view',
      'settings.manage',
    ],
    lastLogin: new Date(Date.now() - 3600000).toISOString(),
    createdAt: new Date(Date.now() - 7776000000).toISOString(),
    status: 'active',
  },
  {
    id: 'mod-1',
    username: 'moderator',
    email: 'mod@fivem.local',
    role: 'moderator',
    permissions: [
      'players.view',
      'players.kick',
      'reports.view',
      'reports.manage',
      'audit.view',
    ],
    lastLogin: new Date(Date.now() - 7200000).toISOString(),
    createdAt: new Date(Date.now() - 86400000).toISOString(),
    status: 'active',
  },
]

// ============================================================================
// PLAYERS
// ============================================================================

export const mockPlayers: Player[] = [
  {
    id: 'player-1',
    steamId: '76561198012345678',
    discordId: '123456789012345678',
    identifier: 'license:1234567890abcdef',
    name: 'John_Doe',
    status: 'online',
    joinedDate: new Date(Date.now() - 2592000000).toISOString(),
    lastSeen: new Date(Date.now() - 300000).toISOString(),
    playtimeMinutes: 4520,
    playerId: 1,
    characters: [],
    totalMoney: 5000,
    totalBankMoney: 45000,
    warnings: 0,
    bans: [],
    notes: 'Regular player, no issues',
  },
  {
    id: 'player-2',
    steamId: '76561198087654321',
    discordId: '987654321098765432',
    identifier: 'license:abcdef1234567890',
    name: 'Jane_Smith',
    status: 'online',
    joinedDate: new Date(Date.now() - 5184000000).toISOString(),
    lastSeen: new Date(Date.now() - 600000).toISOString(),
    playtimeMinutes: 8960,
    playerId: 2,
    characters: [],
    totalMoney: 12000,
    totalBankMoney: 125000,
    warnings: 1,
    bans: [],
    notes: 'Job manager - reliable',
  },
  {
    id: 'player-3',
    steamId: '76561198055555555',
    identifier: 'license:555555555555555',
    name: 'Mike_Johnson',
    status: 'offline',
    joinedDate: new Date(Date.now() - 7776000000).toISOString(),
    lastSeen: new Date(Date.now() - 86400000).toISOString(),
    playtimeMinutes: 14320,
    playerId: 3,
    characters: [],
    totalMoney: 2500,
    totalBankMoney: 250000,
    warnings: 2,
    bans: [],
    notes: 'Long-time player',
  },
]

// ============================================================================
// CHARACTERS
// ============================================================================

export const mockCharacters: Character[] = [
  {
    id: 'char-1',
    playerId: 'player-1',
    firstName: 'John',
    lastName: 'Doe',
    dateOfBirth: '1985-05-15',
    gender: 'M',
    status: 'active',
    level: 45,
    experience: 125000,
    job: 'police',
    jobGrade: 'Officer',
    money: 5000,
    bankMoney: 45000,
    lastPlayed: new Date(Date.now() - 300000).toISOString(),
    createdAt: new Date(Date.now() - 1209600000).toISOString(),
    apartments: [],
    vehicles: [],
  },
]

// ============================================================================
// JOBS
// ============================================================================

export const mockJobs: Job[] = [
  {
    id: 'job-1',
    name: 'police',
    label: 'Police Department',
    description: 'Law enforcement agency',
    type: 'legal',
    maxSlots: 50,
    occupiedSlots: 23,
    boss: mockPlayers[0] || null,
    payment: { baseRate: 750, bonusMultiplier: 1.2, taxRate: 0.15 },
    grades: [
      { grade: 0, name: 'recruit', label: 'Recruit', salary: 750, permissions: ['patrol'] },
    ],
    permissions: ['players.kick'],
    createdAt: new Date().toISOString(),
  },
]

// ============================================================================
// DRUG PRODUCTIONS
// ============================================================================

export const mockDrugProductions: DrugProduction[] = [
  {
    id: 'prod-1',
    name: 'Cocaine Lab',
    label: 'Cocaine Production',
    location: {
      region: allAreas[0].region,
      city: allAreas[0].name,
      coordinates: allAreas[0].coordinates,
    },
    owner: mockPlayers[0] || null,
    productionRate: 50,
    purity: 85,
    status: 'active',
    producedToday: 150,
    totalProduced: 3500,
    nextCycle: new Date(Date.now() + 1800000).toISOString(),
    ingredients: [],
  },
]

// ============================================================================
// DRUG MARKETS
// ============================================================================

export const mockDrugMarkets: DrugMarket[] = [
  {
    id: 'market-1',
    drug: 'Cocaine',
    pricePerGram: 150,
    demandLevel: 'high',
    supply: 450,
    recentTransactions: 82,
    trend: 'up',
  },
]

// ============================================================================
// CONTRACTS
// ============================================================================

export const mockContracts: HitmanContract[] = [
  {
    id: 'contract-1',
    target: mockPlayers[0],
    client: mockPlayers[1] || null,
    assassin: null,
    reward: 50000,
    status: 'pending',
    description: 'Eliminate target',
    deadline: new Date(Date.now() + 604800000).toISOString(),
    progress: 0,
  },
]

// ============================================================================
// REPORTS
// ============================================================================

export const mockReports: Report[] = [
  {
    id: 'report-1',
    reporter: mockPlayers[0],
    subject: mockPlayers[2],
    category: 'griefing',
    description: 'Player was griefing',
    attachments: [],
    status: 'open',
    priority: 'medium',
    createdAt: new Date(Date.now() - 3600000).toISOString(),
  },
]

// ============================================================================
// SERVER STATISTICS
// ============================================================================

export const mockServerStats: ServerStats = {
  totalPlayers: 284,
  onlinePlayers: 87,
  maxPlayers: 128,
  uptime: 2592000,
  fps: 145,
  vcThreads: 32,
  totalCash: 5250000,
  totalBankMoney: 45000000,
  activeJobs: 1,
  activeDrugs: 1,
  pendingContracts: 1,
  completedContracts: 142,
  activeProperties: 156,
  totalTransactions: 8945,
  timestamp: new Date().toISOString(),
}

export const mockServerHealth: ServerHealth = {
  status: 'healthy',
  cpu: 42,
  memory: 58,
  diskSpace: 35,
  networkLatency: 8,
  crashes: 0,
  warnings: [],
}
