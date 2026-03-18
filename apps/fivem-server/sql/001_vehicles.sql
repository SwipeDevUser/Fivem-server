-- Vehicle Schema
-- Creates the vehicles table for managing player vehicles

CREATE TABLE vehicles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    owner INT,
    plate VARCHAR(20),
    vin VARCHAR(50),
    fuel INT DEFAULT 100,
    condition INT DEFAULT 100
);
