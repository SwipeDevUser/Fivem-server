-- Economy System - Initial Seed Data

-- ========================================
-- INITIALIZE FIRST INFLATION ENTRY
-- ========================================
INSERT IGNORE INTO `economy_inflation` (`week`, `current_rate`, `target_rate`, `cumulative_inflation`, `last_update`, `created_at`) VALUES
(1, 0, 3.00, 0, UNIX_TIMESTAMP(), NOW());

-- ========================================
-- ADDITIONAL TEST DATA: Prices Across Categories
-- ========================================
INSERT IGNORE INTO `item_prices` (`item_name`, `category`, `base_price`, `current_price`, `active`) VALUES
-- Food & Beverage
('apple', 'food', 3, 3, 1),
('banana', 'food', 2, 2, 1),
('pizza', 'food', 40, 40, 1),
('burrito', 'food', 12, 12, 1),
('soda', 'food', 6, 6, 1),

-- Weapons
('pistol', 'weapons', 5000, 5000, 1),
('rifle', 'weapons', 12000, 12000, 1),
('shotgun', 'weapons', 8000, 8000, 1),
('ammunition', 'weapons', 50, 50, 1),

-- Vehicles
('car_basic', 'vehicles', 50000, 50000, 1),
('car_sports', 'vehicles', 150000, 150000, 1),
('truck', 'vehicles', 80000, 80000, 1),
('motorcycle', 'vehicles', 30000, 30000, 1),

-- Properties
('apartment_small', 'properties', 100000, 100000, 1),
('apartment_large', 'properties', 250000, 250000, 1),
('house', 'properties', 500000, 500000, 1),
('business', 'properties', 1000000, 1000000, 1),

-- Services
('fuel_liter', 'fuel', 1.5, 1.5, 1),
('repair_service', 'services', 500, 500, 1),
('medical_treatment', 'services', 200, 200, 1),
('taxi_ride', 'services', 50, 50, 1);

-- ========================================
-- INFLATION HISTORY SAMPLE
-- ========================================  
INSERT IGNORE INTO `inflation_history` (`week`, `inflation_rate`, `salary_multiplier`, `price_multiplier`, `monthly_average`) VALUES
(1, 0.0573, 1.000573, 1.000573, 0.0573);

-- ========================================
-- ECONOMY INDICATORS BASELINE
-- ========================================
INSERT IGNORE INTO `economy_indicators` (`indicator_type`, `total_player_wealth`, `money_supply`, `business_revenue`, `transactions_count`, `active_businesses`, `active_players`) VALUES
('baseline', 0, 0, 0, 0, 0, 0);
