// ============================================================================
// AUTHENTICATION & RBAC
// ============================================================================

export type UserRole = 'admin' | 'moderator' | 'manager' | 'viewer'
export type Permission = 
  | 'players.view'
  | 'players.manage'
  | 'players.ban'
  | 'players.kick'
  | 'jobs.manage'
  | 'economy.view'
  | 'economy.manage'
  | 'reports.view'
  | 'reports.manage'
  | 'audit.view'
  | 'settings.manage'

export interface User {
  id: string
  username: string
  email: string
  role: UserRole
  permissions: Permission[]
  lastLogin: string
  createdAt: string
  status: 'active' | 'inactive' | 'suspended'
}

export interface AuthToken {
  accessToken: string
  refreshToken: string
  expiresIn: number
  tokenType: 'Bearer'
}

export interface AuthContext {
  userId: string
  role: UserRole
  permissions: Permission[]
}

// ============================================================================
// PLAYER & CHARACTER DATA
// ============================================================================

export interface Player {
  id: string
  steamId: string
  discordId?: string
  identifier: string
  name: string
  status: 'online' | 'offline'
  joinedDate: string
  lastSeen: string
  playtimeMinutes: number
  playerId: number
  characters: Character[]
  totalMoney: number
  totalBankMoney: number
  warnings: number
  bans: Ban[]
  notes: string
}

export interface Character {
  id: string
  playerId: string
  firstName: string
  lastName: string
  dateOfBirth: string
  gender: 'M' | 'F'
  status: 'active' | 'inactive' | 'deceased'
  level: number
  experience: number
  job: string
  jobGrade: string
  money: number
  bankMoney: number
  lastPlayed: string
  createdAt: string
  apartments: Apartment[]
  vehicles: Vehicle[]
}

export interface Ban {
  id: string
  playerId: string
  reason: string
  bannedBy: string
  bannedAt: string
  expiresAt?: string
  permanent: boolean
}

// ============================================================================
// JOB & EMPLOYMENT
// ============================================================================

export interface Job {
  id: string
  name: string
  label: string
  description: string
  type: 'legal' | 'illegal'
  maxSlots: number
  occupiedSlots: number
  boss: Player | null
  payment: JobPayment
  grades: JobGrade[]
  permissions: Permission[]
  createdAt: string
}

export interface JobGrade {
  grade: number
  name: string
  label: string
  salary: number // per 30 minutes
  permissions: string[]
}

export interface JobPayment {
  baseRate: number
  bonusMultiplier: number
  taxRate: number
}

// ============================================================================
// PROPERTIES & ASSETS
// ============================================================================

export interface Property {
  id: string
  type: 'apartment' | 'house' | 'business' | 'warehouse'
  label: string
  owner: Player | null
  location: GeoLocation
  price: number
  interior: Interior
  features: PropertyFeature[]
  rentPrice?: number
  rented: boolean
  rentedBy?: Player
  createdAt: string
}

export interface Apartment extends Property {
  type: 'apartment'
  bedrooms: number
  livingSpace: number // sqft
}

export interface Vehicle {
  id: string
  owner: Player
  model: string
  label: string
  color?: string
  plate: string
  location: GeoLocation
  fuel: number
  health: number
  status: 'parked' | 'in_use' | 'impounded'
  createdAt: string
}

export interface Interior {
  id: string
  name: string
  coordinates: Coordinates
  heading: number
  entryCoordinates: Coordinates
}

export interface PropertyFeature {
  id: string
  name: string
  description: string
  enabled: boolean
}

// ============================================================================
// LOCATION & GEOGRAPHY
// ============================================================================

export type FloridaRegion = 'orlando' | 'jacksonville' | 'miami' | 'daytona'

export interface GeoLocation {
  region: FloridaRegion
  city: string
  street?: string
  postalCode?: string
  coordinates: Coordinates
}

export interface Coordinates {
  x: number
  y: number
  z: number
}

export interface Area {
  id: string
  name: string
  region: FloridaRegion
  description: string
  coordinates: Coordinates
  radius: number
  properties: number
  population: number
  crimeRate: number
  prosperity: number
}

// ============================================================================
// ECONOMY & DRUGS
// ============================================================================

export interface DrugProduction {
  id: string
  name: string
  label: string
  location: GeoLocation
  owner: Player | null
  productionRate: number // grams per cycle
  purity: number // 0-100%
  status: 'active' | 'raided' | 'shut_down' | 'inactive'
  producedToday: number
  totalProduced: number
  nextCycle: string
  bustedBy?: User
  bustedAt?: string
  ingredients: DrugIngredient[]
}

export interface DrugIngredient {
  id: string
  name: string
  quantity: number
  cost: number
}

export interface DrugMarket {
  id: string
  drug: string
  pricePerGram: number
  demandLevel: 'low' | 'medium' | 'high'
  supply: number
  recentTransactions: number
  trend: 'up' | 'down' | 'stable'
}

export interface Transaction {
  id: string
  type: 'buy' | 'sell' | 'transfer'
  from: Player | null
  to: Player | null
  item: string
  quantity: number
  price: number
  total: number
  timestamp: string
  location: GeoLocation
}

// ============================================================================
// CONTRACTS & SERVICES
// ============================================================================

export interface HitmanContract {
  id: string
  target: Player
  client: Player | null
  assassin: Player | null
  reward: number
  status: 'pending' | 'accepted' | 'in_progress' | 'completed' | 'failed' | 'cancelled'
  description: string
  startedAt?: string
  completedAt?: string
  deadline: string
  evidence?: Evidence[]
  progress: number // 0-100
}

export interface Evidence {
  id: string
  contractId: string
  type: 'screenshot' | 'video' | 'testimony'
  url: string
  timestamp: string
}

// ============================================================================
// REPORTS & MODERATION
// ============================================================================

export interface Report {
  id: string
  reporter: Player
  subject: Player
  category: ReportCategory
  description: string
  attachments: Attachment[]
  status: ReportStatus
  assignedTo?: User
  priority: 'low' | 'medium' | 'high' | 'critical'
  resolution?: string
  createdAt: string
  resolvedAt?: string
}

export type ReportCategory = 
  | 'rulebreak'
  | 'scam'
  | 'griefing'
  | 'exploiting'
  | 'toxic_behavior'
  | 'cheating'
  | 'other'

export type ReportStatus = 
  | 'open'
  | 'assigned'
  | 'investigating'
  | 'resolved'
  | 'dismissed'
  | 'appealed'

export interface Attachment {
  id: string
  filename: string
  url: string
  mimeType: string
  size: number
}

// ============================================================================
// AUDIT & LOGGING
// ============================================================================

export interface AuditLog {
  id: string
  actor: User | null
  action: string
  entity: string
  entityId: string
  changes: Record<string, unknown>
  ipAddress: string
  userAgent: string
  timestamp: string
  status: 'success' | 'failure'
}

// ============================================================================
// SERVER STATISTICS
// ============================================================================

export interface ServerStats {
  totalPlayers: number
  onlinePlayers: number
  maxPlayers: number
  uptime: number // seconds
  fps: number
  vcThreads: number
  totalCash: number
  totalBankMoney: number
  activeJobs: number
  activeDrugs: number
  pendingContracts: number
  completedContracts: number
  activeProperties: number
  totalTransactions: number
  timestamp: string
}

export interface ServerHealth {
  status: 'healthy' | 'degraded' | 'critical'
  cpu: number // percentage
  memory: number // percentage
  diskSpace: number // percentage
  networkLatency: number // ms
  crashes: number
  warnings: number[]
}

// ============================================================================
// DASHBOARD
// ============================================================================

export interface Dashboard {
  stats: ServerStats
  health: ServerHealth
  players: Player[]
  characters: Character[]
  jobs: Job[]
  productions: DrugProduction[]
  markets: DrugMarket[]
  contracts: HitmanContract[]
  reports: Report[]
  auditLogs: AuditLog[]
  areas: Area[]
  properties: Property[]
}

// ============================================================================
// API RESPONSES
// ============================================================================

export interface ApiResponse<T> {
  success: boolean
  data?: T
  error?: ApiError
  meta?: PaginationMeta
}

export interface ApiError {
  code: string
  message: string
  details?: Record<string, unknown>
  timestamp: string
}

export interface PaginationMeta {
  page: number
  pageSize: number
  total: number
  totalPages: number
}

export interface ListResponse<T> extends ApiResponse<T[]> {
  meta: PaginationMeta
}

// ============================================================================
// QUERY FILTERS & SEARCH
// ============================================================================

export interface PlayerFilter {
  search?: string
  status?: 'online' | 'offline'
  job?: string
  region?: FloridaRegion
  minPlaytime?: number
  sortBy?: 'name' | 'playtime' | 'money' | 'lastSeen'
  sortOrder?: 'asc' | 'desc'
}

export interface ReportFilter {
  status?: ReportStatus
  category?: ReportCategory
  priority?: string
  assignedTo?: string
  dateRange?: DateRange
}

export interface DateRange {
  from: string
  to: string
}
