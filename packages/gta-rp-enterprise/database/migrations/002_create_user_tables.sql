-- Migration: Create user, character, inventory, and transaction tables

-- Users Table
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    license VARCHAR(100) UNIQUE NOT NULL,
    discord_id VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_license (license),
    INDEX idx_discord_id (discord_id)
);

-- Characters Table
CREATE TABLE IF NOT EXISTS characters (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    cash INT DEFAULT 500,
    bank INT DEFAULT 5000,
    job VARCHAR(50) DEFAULT 'unemployed',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_job (job)
);

-- Inventory Table
CREATE TABLE IF NOT EXISTS inventory (
    id INT AUTO_INCREMENT PRIMARY KEY,
    character_id INT NOT NULL,
    item_name VARCHAR(50) NOT NULL,
    quantity INT DEFAULT 1,
    metadata JSON,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (character_id) REFERENCES characters(id) ON DELETE CASCADE,
    INDEX idx_character_id (character_id),
    INDEX idx_item_name (item_name),
    UNIQUE KEY unique_item (character_id, item_name)
);

-- Transactions Table
CREATE TABLE IF NOT EXISTS transactions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    character_id INT NOT NULL,
    amount INT NOT NULL,
    type VARCHAR(50) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (character_id) REFERENCES characters(id) ON DELETE CASCADE,
    INDEX idx_character_id (character_id),
    INDEX idx_type (type),
    INDEX idx_created_at (created_at)
);

-- Create stored procedure to get character with inventory
DELIMITER $$

CREATE PROCEDURE IF NOT EXISTS GetCharacterInfo(IN char_id INT)
BEGIN
    SELECT 
        c.id,
        c.user_id,
        c.first_name,
        c.last_name,
        c.cash,
        c.bank,
        c.job,
        c.created_at
    FROM characters c
    WHERE c.id = char_id;
    
    SELECT 
        i.item_name,
        i.quantity,
        i.metadata
    FROM inventory i
    WHERE i.character_id = char_id;
END$$

DELIMITER ;

-- Create trigger to update character updated_at on inventory change
DELIMITER $$

CREATE TRIGGER IF NOT EXISTS update_character_on_inventory_change
AFTER INSERT ON inventory
FOR EACH ROW
BEGIN
    UPDATE characters 
    SET updated_at = CURRENT_TIMESTAMP 
    WHERE id = NEW.character_id;
END$$

DELIMITER ;

-- Create view for quick character status
CREATE OR REPLACE VIEW character_status AS
SELECT 
    c.id as character_id,
    c.user_id,
    CONCAT(c.first_name, ' ', c.last_name) as full_name,
    c.cash,
    c.bank,
    (c.cash + c.bank) as total_money,
    c.job,
    COUNT(DISTINCT i.item_name) as inventory_items,
    SUM(i.quantity) as total_items,
    c.created_at
FROM characters c
LEFT JOIN inventory i ON c.id = i.character_id
GROUP BY c.id;

PRINT 'User management tables created successfully';
