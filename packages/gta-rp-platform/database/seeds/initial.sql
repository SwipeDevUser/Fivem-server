-- Seed Data
-- Populates database with initial data

-- Insert test admin
INSERT INTO players (license, username, email, admin_level, is_whitelist) VALUES
    ('char1:abcdef1234567890', 'admin_user', 'admin@example.com', 5, TRUE)
ON CONFLICT DO NOTHING;

-- Insert test jobs
INSERT INTO jobs (character_id, job_name, job_grade, salary) VALUES
    (1, 'police', 0, 2000),
    (1, 'ems', 0, 1500)
ON CONFLICT DO NOTHING;

-- Insert business types reference (if needed)
-- This would be handled in code/config, but if you want it in DB:
INSERT INTO businesses (owner_id, name, business_type, balance) VALUES
    (1, 'Example Business', 'restaurant', 10000)
ON CONFLICT DO NOTHING;
