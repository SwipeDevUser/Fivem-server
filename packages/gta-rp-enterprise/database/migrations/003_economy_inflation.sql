-- Economy System Database Migration
-- Creates tables for inflation tracking, job salaries, and economic indicators

-- ========================================
-- INFLATION TRACKING TABLE
-- ========================================
CREATE TABLE IF NOT EXISTS `economy_inflation` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `week` INT NOT NULL,
  `current_rate` DECIMAL(10, 4) NOT NULL DEFAULT 0.00,
  `target_rate` DECIMAL(10, 4) NOT NULL DEFAULT 3.00,
  `cumulative_inflation` DECIMAL(15, 4) NOT NULL DEFAULT 0.00,
  `last_update` BIGINT NOT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  
  UNIQUE KEY `unique_week` (`week`),
  INDEX `idx_created_at` (`created_at`),
  INDEX `idx_current_rate` (`current_rate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ========================================
-- JOB SALARIES TABLE
-- ========================================
CREATE TABLE IF NOT EXISTS `job_salaries` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `job_name` VARCHAR(50) NOT NULL UNIQUE,
  `base_salary` INT NOT NULL,
  `current_salary` INT NOT NULL,
  `last_adjusted` TIMESTAMP,
  `active` TINYINT(1) DEFAULT 1,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  
  INDEX `idx_job_name` (`job_name`),
  INDEX `idx_active` (`active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ========================================
-- ITEM PRICES TABLE
-- ========================================
CREATE TABLE IF NOT EXISTS `item_prices` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `item_name` VARCHAR(100) NOT NULL UNIQUE,
  `category` VARCHAR(50) NOT NULL,
  `base_price` INT NOT NULL,
  `current_price` INT NOT NULL,
  `price_multiplier` DECIMAL(10, 4) DEFAULT 1.0000,
  `last_adjusted` TIMESTAMP,
  `active` TINYINT(1) DEFAULT 1,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  
  INDEX `idx_category` (`category`),
  INDEX `idx_active` (`active`),
  INDEX `idx_item_name` (`item_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ========================================
-- ECONOMY INDICATORS TABLE
-- ========================================
CREATE TABLE IF NOT EXISTS `economy_indicators` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `indicator_type` VARCHAR(50) NOT NULL,
  `total_player_wealth` BIGINT DEFAULT 0,
  `money_supply` BIGINT DEFAULT 0,
  `business_revenue` BIGINT DEFAULT 0,
  `transactions_count` INT DEFAULT 0,
  `average_transaction` DECIMAL(15, 2) DEFAULT 0.00,
  `active_businesses` INT DEFAULT 0,
  `active_players` INT DEFAULT 0,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  
  INDEX `idx_type` (`indicator_type`),
  INDEX `idx_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ========================================
-- INFLATION HISTORY TABLE
-- ========================================
CREATE TABLE IF NOT EXISTS `inflation_history` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `week` INT NOT NULL,
  `inflation_rate` DECIMAL(10, 4) NOT NULL,
  `salary_multiplier` DECIMAL(10, 4) NOT NULL,
  `price_multiplier` DECIMAL(10, 4) NOT NULL,
  `monthly_average` DECIMAL(10, 4),
  `affecting_factors` JSON,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  
  UNIQUE KEY `unique_history_week` (`week`),
  INDEX `idx_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ========================================
-- EXPLOIT DETECTION & AUDIT LOG
-- ========================================
CREATE TABLE IF NOT EXISTS `exploit_logs` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `user_id` VARCHAR(100) NOT NULL,
  `player_name` VARCHAR(100),
  `steam_id` VARCHAR(50),
  `amount` INT NOT NULL,
  `reason` VARCHAR(100) NOT NULL,
  `ip_address` VARCHAR(45),
  `action_taken` VARCHAR(50) DEFAULT 'kicked',
  `status` VARCHAR(50) DEFAULT 'logged',
  `reviewed_by` VARCHAR(100),
  `review_notes` TEXT,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  
  INDEX `idx_user_id` (`user_id`),
  INDEX `idx_steam_id` (`steam_id`),
  INDEX `idx_created_at` (`created_at`),
  INDEX `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ========================================
-- ALTER TRANSACTIONS TABLE (if not exists)
-- ========================================
ALTER TABLE `transactions` 
ADD INDEX IF NOT EXISTS `idx_transaction_type` (`type`),
ADD INDEX IF NOT EXISTS `idx_transaction_amount` (`amount`);

-- ========================================
-- SEED DEFAULT JOB SALARIES
-- ========================================
INSERT IGNORE INTO `job_salaries` (`job_name`, `base_salary`, `current_salary`, `active`) VALUES
  ('police', 5000, 5000, 1),
  ('ems', 4500, 4500, 1),
  ('mechanic', 4000, 4000, 1),
  ('taxi', 3500, 3500, 1),
  ('trucker', 4500, 4500, 1),
  ('construction', 3800, 3800, 1),
  ('electrician', 4200, 4200, 1),
  ('miner', 5000, 5000, 1),
  ('farmer', 3000, 3000, 1),
  ('admin', 10000, 10000, 1);

-- ========================================
-- SEED DEFAULT ITEM PRICES
-- ========================================
INSERT IGNORE INTO `item_prices` (`item_name`, `category`, `base_price`, `current_price`, `active`) VALUES
  ('bread', 'food', 5, 5, 1),
  ('water', 'food', 10, 10, 1),
  ('hamburger', 'food', 15, 15, 1),
  ('coffee', 'food', 8, 8, 1),
  ('phone', 'general', 500, 500, 1),
  ('gps', 'vehicle', 750, 750, 1),
  ('gasoline', 'fuel', 100, 100, 1),
  ('lockpick', 'tools', 25, 25, 1),
  ('bandages', 'medical', 50, 50, 1),
  ('oxygen_mask', 'medical', 75, 75, 1);

-- ========================================
-- STORED PROCEDURE: Calculate Weekly Inflation
-- ========================================
DELIMITER $$

DROP PROCEDURE IF EXISTS sp_calculate_weekly_inflation$$

CREATE PROCEDURE sp_calculate_weekly_inflation()
BEGIN
  DECLARE currentWeek INT;
  DECLARE targetRate DECIMAL(10, 4);
  DECLARE calculatedRate DECIMAL(10, 4);
  
  -- Get current week
  SELECT COALESCE(MAX(week), 0) + 1 INTO currentWeek FROM economy_inflation;
  
  -- Set target rate
  SET targetRate = 3.00;
  
  -- Calculate exponential compound: (1 + 0.03)^(1/52) - 1
  SET calculatedRate = (POW(1.03, 1.0/52.0) - 1) * 100;
  
  -- Insert new inflation record
  INSERT INTO economy_inflation (week, current_rate, target_rate, cumulative_inflation, last_update)
  VALUES (currentWeek, calculatedRate, targetRate, 
    COALESCE((SELECT cumulative_inflation FROM economy_inflation WHERE week = currentWeek - 1), 0) + calculatedRate,
    UNIX_TIMESTAMP());
    
  -- Update salary multipliers
  UPDATE job_salaries 
  SET current_salary = FLOOR(base_salary * (1 + calculatedRate / 100))
  WHERE active = 1;
  
  -- Update price multipliers
  UPDATE item_prices
  SET current_price = FLOOR(base_price * (1 + calculatedRate / 100))
  WHERE active = 1;
  
  -- Record in history
  INSERT INTO inflation_history (week, inflation_rate, salary_multiplier, price_multiplier)
  VALUES (currentWeek, calculatedRate, 1 + calculatedRate / 100, 1 + calculatedRate / 100);
  
END$$

DELIMITER ;

-- ========================================
-- VIEW: Current Economy Status
-- ========================================
CREATE OR REPLACE VIEW vw_economy_status AS
SELECT 
  (SELECT current_rate FROM economy_inflation ORDER BY week DESC LIMIT 1) as current_inflation_rate,
  (SELECT AVG(current_salary) FROM job_salaries WHERE active = 1) as average_salary,
  (SELECT AVG(current_price) FROM item_prices WHERE active = 1) as average_item_price,
  (SELECT SUM(amount) FROM transactions WHERE type = 'salary') as total_salaries_paid,
  (SELECT COUNT(*) FROM players WHERE ban = 0) as active_players,
  (SELECT COUNT(*) FROM transactions WHERE created_at >= DATE_SUB(NOW(), INTERVAL 1 DAY)) as daily_transactions,
  NOW() as snapshot_time;
