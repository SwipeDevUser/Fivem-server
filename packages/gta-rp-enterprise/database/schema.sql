-- PostgreSQL Database Schema for GTA RP Enterprise

-- ============================================================================
-- Players Table
-- ============================================================================
CREATE TABLE IF NOT EXISTS players (
    id SERIAL PRIMARY KEY,
    identifier VARCHAR(255) UNIQUE NOT NULL,
    steam_id VARCHAR(255),
    license_id VARCHAR(255),
    xbl_id VARCHAR(255),
    discord_id VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_banned BOOLEAN DEFAULT FALSE,
    is_whitelisted BOOLEAN DEFAULT FALSE,
    ban_reason TEXT,
    ban_date TIMESTAMP,
    unban_date TIMESTAMP
);

CREATE INDEX idx_players_identifier ON players(identifier);
CREATE INDEX idx_players_steam_id ON players(steam_id);
CREATE INDEX idx_players_is_banned ON players(is_banned);

-- ============================================================================
-- Characters Table
-- ============================================================================
CREATE TABLE IF NOT EXISTS characters (
    id SERIAL PRIMARY KEY,
    player_id INTEGER NOT NULL REFERENCES players(id) ON DELETE CASCADE,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    date_of_birth DATE,
    gender VARCHAR(10),
    appearance JSON,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE
);

CREATE INDEX idx_characters_player_id ON characters(player_id);
CREATE INDEX idx_characters_active ON characters(is_active);

-- ============================================================================
-- Jobs Table
-- ============================================================================
CREATE TABLE IF NOT EXISTS jobs (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL,
    description TEXT,
    label VARCHAR(100),
    grade_count INTEGER DEFAULT 10,
    is_active BOOLEAN DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS job_grades (
    id SERIAL PRIMARY KEY,
    job_id INTEGER NOT NULL REFERENCES jobs(id) ON DELETE CASCADE,
    grade INTEGER NOT NULL,
    label VARCHAR(100),
    salary INTEGER DEFAULT 0,
    is_management BOOLEAN DEFAULT FALSE,
    UNIQUE(job_id, grade)
);

-- ============================================================================
-- Player Jobs Table
-- ============================================================================
CREATE TABLE IF NOT EXISTS player_jobs (
    id SERIAL PRIMARY KEY,
    character_id INTEGER NOT NULL REFERENCES characters(id) ON DELETE CASCADE,
    job_id INTEGER NOT NULL REFERENCES jobs(id) ON DELETE CASCADE,
    grade INTEGER DEFAULT 1,
    started_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(character_id, job_id)
);

-- ============================================================================
-- Inventory Items Table
-- ============================================================================
CREATE TABLE IF NOT EXISTS inventory_items (
    id SERIAL PRIMARY KEY,
    character_id INTEGER NOT NULL REFERENCES characters(id) ON DELETE CASCADE,
    item_name VARCHAR(100) NOT NULL,
    item_count INTEGER DEFAULT 1,
    item_metadata JSON,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(character_id, item_name)
);

-- ============================================================================
-- Bank Accounts Table
-- ============================================================================
CREATE TABLE IF NOT EXISTS bank_accounts (
    id SERIAL PRIMARY KEY,
    character_id INTEGER NOT NULL REFERENCES characters(id) ON DELETE CASCADE,
    account_type VARCHAR(50) DEFAULT 'personal',
    balance BIGINT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================================
-- Transactions Table
-- ============================================================================
CREATE TABLE IF NOT EXISTS transactions (
    id SERIAL PRIMARY KEY,
    character_id INTEGER NOT NULL REFERENCES characters(id) ON DELETE CASCADE,
    transaction_type VARCHAR(50),
    amount BIGINT,
    balance_before BIGINT,
    balance_after BIGINT,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_transactions_character_id ON transactions(character_id);
CREATE INDEX idx_transactions_created_at ON transactions(created_at);

-- ============================================================================
-- Bank Employees Table
-- ============================================================================
CREATE TABLE IF NOT EXISTS bank_employees (
    id SERIAL PRIMARY KEY,
    player_id INTEGER NOT NULL REFERENCES players(id) ON DELETE CASCADE,
    salary INTEGER DEFAULT 0,
    position VARCHAR(50),
    hired_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================================
-- Properties Table
-- ============================================================================
CREATE TABLE IF NOT EXISTS properties (
    id SERIAL PRIMARY KEY,
    property_name VARCHAR(255) NOT NULL,
    property_type VARCHAR(50),
    location_x FLOAT,
    location_y FLOAT,
    location_z FLOAT,
    owner_id INTEGER REFERENCES characters(id) ON DELETE SET NULL,
    purchase_price INTEGER,
    is_approved BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================================
-- Businesses Table
-- ============================================================================
CREATE TABLE IF NOT EXISTS businesses (
    id SERIAL PRIMARY KEY,
    business_name VARCHAR(255) NOT NULL,
    business_type VARCHAR(50),
    owner_id INTEGER NOT NULL REFERENCES characters(id) ON DELETE CASCADE,
    location_x FLOAT,
    location_y FLOAT,
    location_z FLOAT,
    balance BIGINT DEFAULT 0,
    established_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE
);

-- ============================================================================
-- Police Records Table
-- ============================================================================
CREATE TABLE IF NOT EXISTS police_records (
    id SERIAL PRIMARY KEY,
    character_id INTEGER NOT NULL REFERENCES characters(id) ON DELETE CASCADE,
    officer_id INTEGER REFERENCES characters(id) ON DELETE SET NULL,
    charge VARCHAR(255),
    description TEXT,
    fine_amount INTEGER,
    jail_time INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP
);

-- ============================================================================
-- Admin Logs Table
-- ============================================================================
CREATE TABLE IF NOT EXISTS admin_logs (
    id SERIAL PRIMARY KEY,
    admin_id INTEGER NOT NULL REFERENCES characters(id) ON DELETE SET NULL,
    action VARCHAR(100),
    target_id INTEGER REFERENCES characters(id) ON DELETE SET NULL,
    details TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_admin_logs_admin_id ON admin_logs(admin_id);
CREATE INDEX idx_admin_logs_created_at ON admin_logs(created_at);

-- ============================================================================
-- Bans Table
-- ============================================================================
CREATE TABLE IF NOT EXISTS bans (
    id SERIAL PRIMARY KEY,
    identifier VARCHAR(255) UNIQUE NOT NULL,
    reason TEXT,
    ban_level VARCHAR(50) DEFAULT 'permanent',
    ban_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    unban_date TIMESTAMP,
    banned_by INTEGER REFERENCES players(id) ON DELETE SET NULL
);

-- ============================================================================
-- Sessions Table
-- ============================================================================
CREATE TABLE IF NOT EXISTS sessions (
    id VARCHAR(255) PRIMARY KEY,
    player_id INTEGER NOT NULL REFERENCES players(id) ON DELETE CASCADE,
    character_id INTEGER REFERENCES characters(id) ON DELETE CASCADE,
    token VARCHAR(500),
    expires_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE
);

CREATE INDEX idx_sessions_player_id ON sessions(player_id);
CREATE INDEX idx_sessions_expires_at ON sessions(expires_at);

-- ============================================================================
-- Audit Logs Table
-- ============================================================================
CREATE TABLE IF NOT EXISTS audit_logs (
    id SERIAL PRIMARY KEY,
    table_name VARCHAR(100),
    record_id INTEGER,
    action VARCHAR(50),
    old_values JSON,
    new_values JSON,
    changed_by VARCHAR(255),
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_audit_logs_table_name ON audit_logs(table_name);
CREATE INDEX idx_audit_logs_changed_at ON audit_logs(changed_at);

-- ============================================================================
-- Create default jobs
-- ============================================================================
INSERT INTO jobs (name, label, description, grade_count) VALUES
    ('police', 'Police Officer', 'Law enforcement', 10),
    ('ems', 'EMS Officer', 'Emergency Medical Services', 5),
    ('mechanic', 'Mechanic', 'Vehicle repair and customization', 5),
    ('taxi', 'Taxi Driver', 'Taxi service', 3),
    ('bus', 'Bus Driver', 'Public transportation', 3),
    ('business_owner', 'Business Owner', 'Business management', 1)
ON CONFLICT (name) DO NOTHING;

-- ============================================================================
-- Insert default job grades
-- ============================================================================
INSERT INTO job_grades (job_id, grade, label, salary, is_management) 
SELECT id, grade, label, salary, is_management FROM (
    SELECT 1 as job_id, 1 as grade, 'Cadet' as label, 500 as salary, false as is_management
    UNION SELECT 1, 2, 'Officer', 750, false
    UNION SELECT 1, 3, 'Senior Officer', 1000, false
    UNION SELECT 1, 4, 'Sergeant', 1500, true
    UNION SELECT 1, 5, 'Lieutenant', 2000, true
    UNION SELECT 1, 6, 'Captain', 2500, true
    UNION SELECT 1, 7, 'Major', 3000, true
) as grades
WHERE NOT EXISTS (SELECT 1 FROM job_grades WHERE job_id = grades.job_id)
ON CONFLICT DO NOTHING;

print '^2Database schema initialized successfully^7'
