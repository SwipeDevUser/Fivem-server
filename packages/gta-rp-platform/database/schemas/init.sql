-- Initial Database Schema
-- Creates all base tables for GTA RP Platform

-- Players table
CREATE TABLE IF NOT EXISTS players (
    id SERIAL PRIMARY KEY,
    license TEXT UNIQUE NOT NULL,
    discord_id TEXT UNIQUE,
    username TEXT UNIQUE NOT NULL,
    email TEXT UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP,
    playtime_minutes INT DEFAULT 0,
    ban_status INT DEFAULT 0, -- 0: active, 1: banned, 2: muted
    ban_reason TEXT,
    ban_until TIMESTAMP,
    admin_level INT DEFAULT 0, -- 0: player, 1-5: admin levels
    is_whitelist BOOLEAN DEFAULT FALSE
);

-- Characters table
CREATE TABLE IF NOT EXISTS characters (
    id SERIAL PRIMARY KEY,
    player_id INT NOT NULL REFERENCES players(id),
    firstname TEXT NOT NULL,
    lastname TEXT NOT NULL,
    dob DATE,
    gender INT DEFAULT 0,
    money INT DEFAULT 0,
    bank_money INT DEFAULT 0,
    dirty_money INT DEFAULT 0,
    job TEXT DEFAULT 'unemployed',
    job_grade INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_played TIMESTAMP,
    is_alive BOOLEAN DEFAULT TRUE,
    health INT DEFAULT 200
);

-- Jobs table
CREATE TABLE IF NOT EXISTS jobs (
    id SERIAL PRIMARY KEY,
    character_id INT NOT NULL REFERENCES characters(id),
    job_name TEXT NOT NULL,
    job_grade INT DEFAULT 0,
    salary INT DEFAULT 0,
    hired_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fired_at TIMESTAMP
);

-- Businesses table
CREATE TABLE IF NOT EXISTS businesses (
    id SERIAL PRIMARY KEY,
    owner_id INT NOT NULL REFERENCES players(id),
    name TEXT NOT NULL,
    business_type TEXT NOT NULL, -- restaurant, nightclub, shop, garage, laundromat
    balance INT DEFAULT 0,
    total_revenue INT DEFAULT 0,
    total_expenses INT DEFAULT 0,
    level INT DEFAULT 1,
    active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_accessed TIMESTAMP
);

-- Business Expansions table
CREATE TABLE IF NOT EXISTS business_expansions (
    id SERIAL PRIMARY KEY,
    business_id INT NOT NULL REFERENCES businesses(id),
    expansion_name TEXT NOT NULL,
    purchased_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    cost INT DEFAULT 0
);

-- Inventory table
CREATE TABLE IF NOT EXISTS inventory (
    id SERIAL PRIMARY KEY,
    character_id INT NOT NULL REFERENCES characters(id),
    item_name TEXT NOT NULL,
    quantity INT DEFAULT 0,
    weight DECIMAL(10,2) DEFAULT 0
);

-- Properties table
CREATE TABLE IF NOT EXISTS properties (
    id SERIAL PRIMARY KEY,
    owner_id INT NOT NULL REFERENCES players(id),
    address TEXT NOT NULL,
    property_type TEXT NOT NULL, -- apartment, house, commercial
    price INT NOT NULL,
    is_rented BOOLEAN DEFAULT FALSE,
    rent_price INT DEFAULT 0,
    tenant_id INT REFERENCES players(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Crimes table
CREATE TABLE IF NOT EXISTS crimes (
    id SERIAL PRIMARY KEY,
    player_id INT NOT NULL REFERENCES players(id),
    crime_type TEXT NOT NULL,
    reward INT DEFAULT 0,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status TEXT DEFAULT 'completed', -- committed, caught, completed
    police_notified BOOLEAN DEFAULT FALSE
);

-- Money Laundering table
CREATE TABLE IF NOT EXISTS laundering_history (
    id SERIAL PRIMARY KEY,
    player_id INT NOT NULL REFERENCES players(id),
    method TEXT NOT NULL,
    dirty_amount INT DEFAULT 0,
    clean_amount INT DEFAULT 0,
    fee INT DEFAULT 0,
    duration_seconds INT DEFAULT 0,
    started_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP,
    status TEXT DEFAULT 'pending' -- pending, completed, cancelled
);

-- Transactions table
CREATE TABLE IF NOT EXISTS transactions (
    id SERIAL PRIMARY KEY,
    character_id INT NOT NULL REFERENCES characters(id),
    transaction_type TEXT NOT NULL, -- salary, purchase, crime, business, expense
    amount INT DEFAULT 0,
    description TEXT,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    balance_after INT DEFAULT 0
);

-- Sales History table
CREATE TABLE IF NOT EXISTS sales_history (
    id SERIAL PRIMARY KEY,
    business_id INT NOT NULL REFERENCES businesses(id),
    item_name TEXT NOT NULL,
    quantity INT DEFAULT 0,
    price_per_unit INT DEFAULT 0,
    total_amount INT DEFAULT 0,
    revenue INT DEFAULT 0,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Employees table
CREATE TABLE IF NOT EXISTS employees (
    id SERIAL PRIMARY KEY,
    business_id INT NOT NULL REFERENCES businesses(id),
    character_id INT NOT NULL REFERENCES characters(id),
    position TEXT NOT NULL, -- owner, manager, employee, cashier, chef
    salary INT DEFAULT 0,
    hours_worked INT DEFAULT 0,
    total_earned INT DEFAULT 0,
    hired_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fired_at TIMESTAMP,
    active BOOLEAN DEFAULT TRUE
);

-- Bans table
CREATE TABLE IF NOT EXISTS bans (
    id SERIAL PRIMARY KEY,
    player_id INT NOT NULL REFERENCES players(id),
    reason TEXT NOT NULL,
    banned_by INT REFERENCES players(id),
    banned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ban_until TIMESTAMP,
    is_permanent BOOLEAN DEFAULT FALSE,
    status TEXT DEFAULT 'active' -- active, expired, appealed
);

-- Logs table
CREATE TABLE IF NOT EXISTS logs (
    id SERIAL PRIMARY KEY,
    admin_id INT REFERENCES players(id),
    action TEXT NOT NULL,
    target_id INT REFERENCES players(id),
    details TEXT,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for faster queries
CREATE INDEX idx_players_license ON players(license);
CREATE INDEX idx_players_discord ON players(discord_id);
CREATE INDEX idx_characters_player ON characters(player_id);
CREATE INDEX idx_jobs_character ON jobs(character_id);
CREATE INDEX idx_businesses_owner ON businesses(owner_id);
CREATE INDEX idx_crimes_player ON crimes(player_id);
CREATE INDEX idx_bans_player ON bans(player_id);
CREATE INDEX idx_logs_admin ON logs(admin_id);
CREATE INDEX idx_logs_timestamp ON logs(timestamp);
