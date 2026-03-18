-- GTA RP Enterprise - Seed Data

-- Insert sample organizations
INSERT INTO jobs (name, label, description, grade_count) VALUES
    ('trader', 'Trader', 'Stock and commodity trading', 3),
    ('chef', 'Chef', 'Restaurant operations', 5)
ON CONFLICT (name) DO NOTHING;

-- Insert sample players (for testing)
INSERT INTO players (identifier, steam_id, is_whitelisted) VALUES
    ('license:abc123def456', '1100001234567890', true),
    ('license:xyz789uvw012', '1100009876543210', true)
ON CONFLICT (identifier) DO NOTHING;

-- Insert sample characters
INSERT INTO characters (player_id, first_name, last_name, gender, appearance)
SELECT 
    p.id,
    'John',
    'Doe',
    'M',
    '{"head": 0, "face": 0, "torso": 0}'::json
FROM players p
WHERE p.identifier = 'license:abc123def456'
AND NOT EXISTS (SELECT 1 FROM characters WHERE player_id = p.id)
ON CONFLICT DO NOTHING;

-- Insert sample bank accounts
INSERT INTO bank_accounts (character_id, account_type, balance)
SELECT c.id, 'personal', 50000
FROM characters c
WHERE NOT EXISTS (SELECT 1 FROM bank_accounts WHERE character_id = c.id)
ON CONFLICT DO NOTHING;

-- Insert sample inventory items
INSERT INTO inventory_items (character_id, item_name, item_count)
SELECT c.id, 'id_card', 1
FROM characters c
WHERE NOT EXISTS (SELECT 1 FROM inventory_items WHERE character_id = c.id AND item_name = 'id_card')
ON CONFLICT DO NOTHING;

-- Insert sample businesses
INSERT INTO businesses (business_name, business_type, owner_id, balance, is_active)
SELECT c.id, 'restaurant', c.id, 100000, true
FROM characters c
WHERE NOT EXISTS (SELECT 1 FROM businesses WHERE owner_id = c.id)
ON CONFLICT DO NOTHING;

print '^2Database seeded successfully^7'
