-- Inventory System - Database Schema

-- ========================================
-- INVENTORY TABLE
-- ========================================
CREATE TABLE IF NOT EXISTS `inventory` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `user_id` VARCHAR(100) NOT NULL,
  `character_id` INT DEFAULT 0,
  `item_name` VARCHAR(100) NOT NULL,
  `quantity` INT NOT NULL DEFAULT 1,
  `metadata` JSON,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  
  UNIQUE KEY `unique_inventory_item` (`user_id`, `character_id`, `item_name`),
  INDEX `idx_user_id` (`user_id`),
  INDEX `idx_character_id` (`character_id`),
  INDEX `idx_item_name` (`item_name`),
  INDEX `idx_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ========================================
-- DROPPED ITEMS TABLE
-- ========================================
CREATE TABLE IF NOT EXISTS `dropped_items` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `item_name` VARCHAR(100) NOT NULL,
  `quantity` INT NOT NULL DEFAULT 1,
  `position` JSON NOT NULL,  -- {x, y, z}
  `heading` FLOAT DEFAULT 0,
  `metadata` JSON,
  `dropped_by` VARCHAR(100),
  `dropped_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `expires_at` TIMESTAMP,
  `picked_up_by` VARCHAR(100),
  `picked_up_at` TIMESTAMP,
  
  INDEX `idx_item_name` (`item_name`),
  INDEX `idx_dropped_at` (`dropped_at`),
  INDEX `idx_picked_up` (`picked_up_by`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ========================================
-- INVENTORY HISTORY TABLE
-- ========================================
CREATE TABLE IF NOT EXISTS `inventory_history` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `user_id` VARCHAR(100) NOT NULL,
  `character_id` INT DEFAULT 0,
  `action_type` VARCHAR(50) NOT NULL,  -- 'add', 'remove', 'transfer', 'drop', 'use'
  `item_name` VARCHAR(100) NOT NULL,
  `quantity` INT NOT NULL,
  `from_user_id` VARCHAR(100),
  `to_user_id` VARCHAR(100),
  `metadata` JSON,
  `reason` VARCHAR(255),
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  
  INDEX `idx_user_id` (`user_id`),
  INDEX `idx_action_type` (`action_type`),
  INDEX `idx_item_name` (`item_name`),
  INDEX `idx_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ========================================
-- ITEM DEFINITIONS TABLE
-- ========================================
CREATE TABLE IF NOT EXISTS `item_definitions` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(100) NOT NULL UNIQUE,
  `label` VARCHAR(100) NOT NULL,
  `weight` INT NOT NULL DEFAULT 0,
  `category` VARCHAR(50) NOT NULL,
  `usable` TINYINT(1) DEFAULT 0,
  `unique` TINYINT(1) DEFAULT 0,
  `description` TEXT,
  `metadata_schema` JSON,
  `active` TINYINT(1) DEFAULT 1,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  
  INDEX `idx_name` (`name`),
  INDEX `idx_category` (`category`),
  INDEX `idx_active` (`active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ========================================
-- PLAYER INVENTORY STATS
-- ========================================
CREATE TABLE IF NOT EXISTS `inventory_stats` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `user_id` VARCHAR(100) NOT NULL UNIQUE,
  `character_id` INT DEFAULT 0,
  `total_items` INT DEFAULT 0,
  `total_weight` INT DEFAULT 0,
  `last_update` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `items_used` INT DEFAULT 0,
  `items_dropped` INT DEFAULT 0,
  `items_transferred` INT DEFAULT 0,
  
  INDEX `idx_user_id` (`user_id`),
  INDEX `idx_total_weight` (`total_weight`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ========================================
-- INVENTORY LOGS TABLE
-- ========================================
CREATE TABLE IF NOT EXISTS `inventory_logs` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `user_id` VARCHAR(100) NOT NULL,
  `character_id` INT DEFAULT 0,
  `server_id` INT,
  `action` VARCHAR(100) NOT NULL,
  `item_name` VARCHAR(100),
  `quantity` INT,
  `ip_address` VARCHAR(45),
  `log_data` JSON,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  
  INDEX `idx_user_id` (`user_id`),
  INDEX `idx_action` (`action`),
  INDEX `idx_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ========================================
-- STORED PROCEDURE: Log Inventory Action
-- ========================================
DELIMITER $$

DROP PROCEDURE IF EXISTS sp_log_inventory_action$$

CREATE PROCEDURE sp_log_inventory_action(
    IN p_user_id VARCHAR(100),
    IN p_character_id INT,
    IN p_action_type VARCHAR(50),
    IN p_item_name VARCHAR(100),
    IN p_quantity INT,
    IN p_reason VARCHAR(255)
)
BEGIN
    INSERT INTO inventory_history (user_id, character_id, action_type, item_name, quantity, reason)
    VALUES (p_user_id, p_character_id, p_action_type, p_item_name, p_quantity, p_reason);
    
    UPDATE inventory_stats
    SET items_used = items_used + IF(p_action_type = 'use', 1, 0),
        items_dropped = items_dropped + IF(p_action_type = 'drop', 1, 0),
        items_transferred = items_transferred + IF(p_action_type = 'transfer', 1, 0)
    WHERE user_id = p_user_id AND character_id = p_character_id;
END$$

DELIMITER ;

-- ========================================
-- STORED PROCEDURE: Calculate Inventory Weight
-- ========================================
DELIMITER $$

DROP PROCEDURE IF EXISTS sp_calculate_inventory_weight$$

CREATE PROCEDURE sp_calculate_inventory_weight(
    IN p_user_id VARCHAR(100),
    IN p_character_id INT
)
BEGIN
    DECLARE totalWeight INT DEFAULT 0;
    
    SELECT COALESCE(SUM(inv.quantity * COALESCE(id.weight, 0)), 0)
    INTO totalWeight
    FROM inventory inv
    LEFT JOIN item_definitions id ON inv.item_name = id.name
    WHERE inv.user_id = p_user_id AND inv.character_id = p_character_id;
    
    UPDATE inventory_stats
    SET total_weight = totalWeight
    WHERE user_id = p_user_id AND character_id = p_character_id;
END$$

DELIMITER ;

-- ========================================
-- VIEW: Player Inventory Summary
-- ========================================
CREATE OR REPLACE VIEW vw_player_inventory_summary AS
SELECT 
    i.user_id,
    i.character_id,
    COUNT(i.id) as total_items,
    SUM(i.quantity) as total_quantity,
    SUM(id.weight * i.quantity) as total_weight,
    MAX(i.updated_at) as last_updated
FROM inventory i
LEFT JOIN item_definitions id ON i.item_name = id.name
GROUP BY i.user_id, i.character_id;

-- ========================================
-- VIEW: Inventory History by User
-- ========================================
CREATE OR REPLACE VIEW vw_inventory_history_summary AS
SELECT 
    user_id,
    character_id,
    action_type,
    COUNT(*) as action_count,
    SUM(CASE WHEN action_type = 'add' THEN quantity ELSE 0 END) as total_items_added,
    SUM(CASE WHEN action_type = 'remove' THEN quantity ELSE 0 END) as total_items_removed,
    MAX(created_at) as last_action
FROM inventory_history
WHERE created_at >= DATE_SUB(NOW(), INTERVAL 30 DAY)
GROUP BY user_id, character_id, action_type;
