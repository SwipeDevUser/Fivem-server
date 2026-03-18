/**
 * FiveM NUI Bridge
 * Client-side communication layer with FiveM game client
 * Handles SendNUIMessage and RegisterNUICallback
 */

export interface NUIMessage {
  action: string
  data?: Record<string, unknown>
}

export interface NUIResponse {
  success: boolean
  data?: unknown
  error?: string
}

/**
 * Window interface extension for NUI
 */
declare global {
  interface Window {
    PostMessage?: (message: NUIMessage) => void
    invokeLegals?: (action: string, data: Record<string, unknown>) => void
  }
}

/**
 * Send message to FiveM server
 */
export function sendNUIMessage(message: NUIMessage): void {
  if (window.PostMessage) {
    window.PostMessage(message)
  } else if (window.invokeLegals) {
    window.invokeLegals(message.action, message.data || {})
  } else {
    console.warn('NUI bridge not available')
  }
}

/**
 * NUI Callback handler registry
 */
const callbackHandlers: Record<string, (data: unknown) => NUIResponse> = {}

export function registerNUICallback(action: string, handler: (data: unknown) => NUIResponse | Promise<NUIResponse>) {
  callbackHandlers[action] = handler as (data: unknown) => NUIResponse
}

/**
 * Execute NUI callback
 */
export async function invokeNUICallback(action: string, data?: unknown): Promise<NUIResponse> {
  const handler = callbackHandlers[action]
  if (!handler) {
    return { success: false, error: `Unknown callback: ${action}` }
  }

  try {
    const result = await handler(data)
    return result
  } catch (error) {
    return { success: false, error: String(error) }
  }
}

/**
 * Register common NUI callbacks for dashboard
 */
export function registerDashboardCallbacks() {
  // Player info callback
  registerNUICallback('getPlayerInfo', async () => ({
    success: true,
    data: {
      playerId: 1,
      name: 'Player Name',
      job: 'police',
      money: 5000,
      bankMoney: 45000,
    },
  }))

  // Job info callback
  registerNUICallback('getJobInfo', async () => ({
    success: true,
    data: {
      job: 'police',
      grade: 'Officer',
      salary: 1000,
    },
  }))

  // Character info callback
  registerNUICallback('getCharacterInfo', async () => ({
    success: true,
    data: {
      firstName: 'John',
      lastName: 'Doe',
      age: 35,
      level: 45,
    },
  }))

  // Location callback
  registerNUICallback('getCurrentLocation', async () => ({
    success: true,
    data: {
      x: 425.5,
      y: 375.2,
      z: 29.3,
      region: 'orlando',
      area: 'downtown',
    },
  }))

  // Health callback
  registerNUICallback('getPlayerHealth', async () => ({
    success: true,
    data: {
      health: 200,
      armor: 50,
    },
  }))

  // Server info callback
  registerNUICallback('getServerInfo', async () => ({
    success: true,
    data: {
      name: 'FiveM Server',
      version: '1.0.0',
      onlinePlayers: 87,
      maxPlayers: 128,
    },
  }))
}

/**
 * NUI event emitter for client-side updates
 */
export const nuiEvents = {
  onPlayerUpdate: (_callback: (data: unknown) => void) => {
    // Subscribe to player update events
  },
  onLocationChange: (_callback: (data: unknown) => void) => {
    // Subscribe to location change events
  },
  onJobChange: (_callback: (data: unknown) => void) => {
    // Subscribe to job change events
  },
}
