// FiveM Server API Bridge
// Handles communication between Next.js dashboard and FiveM server
// Place this in src/lib/fivem-api.ts

interface PlayerData {
  id: number;
  name: string;
  joinTime: number;
  identifier: string;
  level: number;
}

interface ServerStats {
  uptime: number;
  playerCount: number;
  maxPlayers: number;
  serverTime: number;
  resources: number;
}

interface JobInfo {
  name: string;
  members: number;
}

interface DrugEconomy {
  [key: string]: {
    price: number;
    supply: number;
  };
}

interface HitmanContract {
  target: string;
  reward: number;
  status: 'active' | 'completed' | 'failed';
}

class FiveMMAPIClient {
  private baseUrl: string;
  private pollInterval: number;

  constructor(baseUrl: string = 'http://localhost:3001', pollInterval: number = 5000) {
    this.baseUrl = baseUrl;
    this.pollInterval = pollInterval;
  }

  /**
   * Get all player stats from the FiveM server
   */
  async getPlayerStats(): Promise<PlayerData[]> {
    try {
      const response = await fetch(`${this.baseUrl}/api/players`, {
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
        },
      });

      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }

      return await response.json();
    } catch (error) {
      console.error('Failed to fetch player stats:', error);
      return [];
    }
  }

  /**
   * Get server statistics
   */
  async getServerStats(): Promise<ServerStats | null> {
    try {
      const response = await fetch(`${this.baseUrl}/api/server/stats`, {
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
        },
      });

      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }

      return await response.json();
    } catch (error) {
      console.error('Failed to fetch server stats:', error);
      return null;
    }
  }

  /**
   * Get job information
   */
  async getJobInfo(): Promise<JobInfo[]> {
    try {
      const response = await fetch(`${this.baseUrl}/api/jobs`, {
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
        },
      });

      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }

      return await response.json();
    } catch (error) {
      console.error('Failed to fetch job info:', error);
      return [];
    }
  }

  /**
   * Get drug economy data
   */
  async getDrugEconomy(): Promise<DrugEconomy> {
    try {
      const response = await fetch(`${this.baseUrl}/api/drugs`, {
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
        },
      });

      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }

      return await response.json();
    } catch (error) {
      console.error('Failed to fetch drug economy:', error);
      return {};
    }
  }

  /**
   * Get hitman contracts
   */
  async getHitmanContracts(): Promise<HitmanContract[]> {
    try {
      const response = await fetch(`${this.baseUrl}/api/contracts`, {
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
        },
      });

      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }

      return await response.json();
    } catch (error) {
      console.error('Failed to fetch contracts:', error);
      return [];
    }
  }

  /**
   * Perform a server action (kick player, execute command, etc.)
   */
  async executeServerAction(
    action: string,
    targetId: number | string,
    params?: Record<string, any>
  ): Promise<{ success: boolean; message: string }> {
    try {
      const response = await fetch(`${this.baseUrl}/api/server/action`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          action,
          targetId,
          ...params,
        }),
      });

      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }

      return await response.json();
    } catch (error) {
      console.error('Failed to execute server action:', error);
      return { success: false, message: 'Failed to execute action' };
    }
  }

  /**
   * Set up polling for real-time data updates
   */
  setupPolling(
    callback: (data: { players: PlayerData[]; stats: ServerStats | null }) => void
  ): () => void {
    const pollData = async () => {
      const players = await this.getPlayerStats();
      const stats = await this.getServerStats();
      callback({ players, stats });
    };

    const intervalId = setInterval(pollData, this.pollInterval);

    // Initial fetch
    pollData();

    // Return cleanup function
    return () => clearInterval(intervalId);
  }
}

// Export singleton instance
export const fiveMAAPIClient = new FiveMMAPIClient();

export type { PlayerData, ServerStats, JobInfo, DrugEconomy, HitmanContract };
