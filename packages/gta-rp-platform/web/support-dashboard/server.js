// Support Dashboard Backend
const express = require('express');
const cors = require('express-cors');
const { Pool } = require('pg');
require('dotenv').config();

const app = express();
app.use(cors());
app.use(express.json());

// Database
const pool = new Pool({
  user: process.env.DB_USER,
  host: process.env.DB_HOST,
  database: process.env.DB_NAME,
  password: process.env.DB_PASSWORD,
  port: process.env.DB_PORT,
});

// Health Check
app.get('/health', (req, res) => {
  res.json({ status: 'ok', timestamp: new Date() });
});

// Reports API
app.get('/api/reports', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM logs ORDER BY timestamp DESC LIMIT 50');
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Player Reports
app.post('/api/reports/player', async (req, res) => {
  try {
    const { reporter_id, target_id, reason, description } = req.body;
    const result = await pool.query(
      'INSERT INTO logs (admin_id, action, target_id, details) VALUES ($1, $2, $3, $4)',
      [reporter_id, 'report', target_id, `${reason}: ${description}`]
    );
    res.json({ success: true, message: 'Report submitted' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Chat Logs
app.get('/api/chatlogs', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM logs LIMIT 200');
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Start
const PORT = process.env.SUPPORT_PORT || 3001;
app.listen(PORT, () => {
  console.log(`✅ Support Dashboard running on port ${PORT}`);
});
