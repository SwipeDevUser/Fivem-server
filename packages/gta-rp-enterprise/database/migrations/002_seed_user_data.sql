-- Seed data for user management tables

-- Insert test users
INSERT INTO users (license, discord_id) VALUES
    ('license:abc123def456', '123456789'),
    ('license:xyz789uvw012', '987654321'),
    ('license:test1234567', '111111111')
ON DUPLICATE KEY UPDATE discord_id = VALUES(discord_id);

-- Insert test characters
INSERT INTO characters (user_id, first_name, last_name, cash, bank, job) VALUES
    (1, 'John', 'Doe', 5000, 50000, 'police'),
    (1, 'Jane', 'Doe', 2000, 30000, 'unemployed'),
    (2, 'Bob', 'Smith', 10000, 100000, 'mechanic'),
    (3, 'Alice', 'Johnson', 1000, 15000, 'taxi_driver')
ON DUPLICATE KEY UPDATE cash = VALUES(cash), bank = VALUES(bank), job = VALUES(job);

-- Insert test inventory items
INSERT INTO inventory (character_id, item_name, quantity, metadata) VALUES
    (1, 'id_card', 1, JSON_OBJECT('issued_date', '2026-01-01')),
    (1, 'phone', 1, JSON_OBJECT('phone_number', '555-0101')),
    (1, 'wallet', 1, JSON_OBJECT('color', 'black')),
    (2, 'id_card', 1, JSON_OBJECT('issued_date', '2026-01-01')),
    (2, 'backpack', 1, JSON_OBJECT('color', 'blue')),
    (3, 'toolbox', 1, JSON_OBJECT('tools_count', 15)),
    (3, 'wrench', 2, NULL),
    (4, 'phone', 1, JSON_OBJECT('phone_number', '555-0102'))
ON DUPLICATE KEY UPDATE quantity = VALUES(quantity);

-- Insert test transactions
INSERT INTO transactions (character_id, amount, type, description) VALUES
    (1, 500, 'salary', 'Weekly police salary'),
    (1, -200, 'expense', 'Ammo purchase'),
    (2, 250, 'job_payment', 'Taxi fare'),
    (3, 1000, 'job_payment', 'Vehicle repair'),
    (4, 350, 'job_payment', 'Taxi fares'),
    (1, -100, 'fine', 'Speeding ticket'),
    (2, 500, 'payment', 'Received from player');

-- Update character total money from recent transactions
-- This is a view example, not required in seed

PRINT 'Seed data inserted successfully';
