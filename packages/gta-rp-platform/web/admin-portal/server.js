// Admin Portal Backend Server
const express = require('express');
const cors = require('express-cors');
const jwt = require('jsonwebtoken');
const { Pool } = require('pg');
const redis = require('redis');
const http = require('http');
const socketIo = require('socket.io');
require('dotenv').config();

const app = express();
const server = http.createServer(app);
const io = socketIo(server, {
  cors: { origin: '*' }
});

// Middleware
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

// Redis
const redisClient = redis.createClient({
  url: process.env.REDIS_URL
});

redisClient.connect();

// Auth Middleware
const authMiddleware = (req, res, next) => {
  const token = req.headers.authorization?.split(' ')[1];
  
  if (!token) {
    return res.status(401).json({ error: 'No token provided' });
  }

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET || 'secret');
    req.user = decoded;
    next();
  } catch (error) {
    return res.status(401).json({ error: 'Invalid token' });
  }
};

// Routes

// Health Check
app.get('/health', (req, res) => {
  res.json({ status: 'ok', timestamp: new Date() });
});

// Players API
app.get('/api/players', authMiddleware, async (req, res) => {
  try {
    const result = await pool.query('SELECT id, license, username, email, admin_level, ban_status FROM players LIMIT 100');
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.get('/api/players/:id', authMiddleware, async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM players WHERE id = $1', [req.params.id]);
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Player not found' });
    }
    res.json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Ban Player
app.post('/api/players/:id/ban', authMiddleware, async (req, res) => {
  try {
    const { reason, until } = req.body;
    const result = await pool.query(
      'INSERT INTO bans (player_id, reason, banned_by, ban_until) VALUES ($1, $2, $3, $4)',
      [req.params.id, reason, req.user.id, until]
    );
    res.json({ success: true, message: 'Player banned' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Businesses API
app.get('/api/businesses', authMiddleware, async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM businesses LIMIT 100');
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Jobs API
app.get('/api/jobs', authMiddleware, async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM jobs LIMIT 100');
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Logs API
app.get('/api/logs', authMiddleware, async (req, res) => {
  try {
    const limit = req.query.limit || 100;
    const result = await pool.query('SELECT * FROM logs ORDER BY timestamp DESC LIMIT $1', [limit]);
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// WebSocket for Real-time Updates
io.on('connection', (socket) => {
  console.log('Admin connected:', socket.id);

  socket.on('disconnect', () => {
    console.log('Admin disconnected:', socket.id);
  });
});

// Start Server
const PORT = process.env.ADMIN_PORT || 3000;
server.listen(PORT, () => {
  console.log(`✅ Admin Portal API running on port ${PORT}`);
});

module.exports = { app, io };
