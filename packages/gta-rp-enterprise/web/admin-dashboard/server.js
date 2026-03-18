const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const rateLimit = require('express-rate-limit');
const dotenv = require('dotenv');

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(helmet());
app.use(cors({ origin: process.env.ADMIN_PANEL_URL || 'localhost:3000' }));
app.use(express.json());

// Rate limiting
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 100,
  message: 'Too many requests from this IP, please try again later.'
});
app.use(limiter);

// Health check endpoint
app.get('/health', (req, res) => {
  res.json({ status: 'ok', timestamp: new Date().toISOString() });
});

// API Routes
app.get('/api/server/status', (req, res) => {
  res.json({
    name: 'GTA RP Enterprise',
    version: '1.0.0',
    players: 0,
    uptime: process.uptime(),
    timestamp: new Date().toISOString()
  });
});

app.get('/api/server/resources', (req, res) => {
  res.json({
    resources: [
      'core_framework',
      'identity',
      'session',
      'permissions',
      'inventory',
      'economy',
      'jobs',
      'police',
      'ems',
      'housing',
      'vehicles',
      'businesses',
      'ui',
      'notifications',
      'logging',
      'anti_cheat',
      'admin'
    ]
  });
});

// Error handling
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(err.status || 500).json({
    error: process.env.NODE_ENV === 'production' ? 'Internal Server Error' : err.message
  });
});

app.listen(PORT, () => {
  console.log(`Admin Dashboard listening on port ${PORT}`);
});
