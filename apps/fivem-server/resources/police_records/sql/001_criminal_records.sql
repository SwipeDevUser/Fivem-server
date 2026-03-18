-- Criminal Records Database Schema

-- Criminal Records Table
CREATE TABLE criminal_records (
    id INT AUTO_INCREMENT PRIMARY KEY,
    player_id INT UNIQUE NOT NULL,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    date_of_birth DATE,
    height INT,
    charges TEXT,
    mugshot_url VARCHAR(255),
    status ENUM('clean', 'wanted', 'incarcerated') DEFAULT 'clean',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (player_id) REFERENCES users(id),
    INDEX idx_status (status),
    INDEX idx_player (player_id)
);

-- Warrants Table
CREATE TABLE warrants (
    id INT AUTO_INCREMENT PRIMARY KEY,
    player_id INT NOT NULL,
    issued_by INT,
    reason VARCHAR(255),
    arrest_warrant BOOLEAN DEFAULT TRUE,
    felony BOOLEAN DEFAULT FALSE,
    amount INT DEFAULT 0,
    issued_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    revoked_at TIMESTAMP NULL,
    active BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (player_id) REFERENCES users(id),
    FOREIGN KEY (issued_by) REFERENCES users(id),
    INDEX idx_active (active),
    INDEX idx_player (player_id)
);

-- Arrest History Table
CREATE TABLE arrest_history (
    id INT AUTO_INCREMENT PRIMARY KEY,
    player_id INT NOT NULL,
    arrested_by INT,
    reason VARCHAR(255),
    jail_time INT DEFAULT 0,
    fine INT DEFAULT 0,
    arrested_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    released_at TIMESTAMP NULL,
    FOREIGN KEY (player_id) REFERENCES users(id),
    FOREIGN KEY (arrested_by) REFERENCES users(id),
    INDEX idx_player (player_id),
    INDEX idx_arrested_at (arrested_at)
);

-- Vehicle Plate Lookup Table
CREATE TABLE vehicle_plates (
    id INT AUTO_INCREMENT PRIMARY KEY,
    plate VARCHAR(8) UNIQUE NOT NULL,
    vehicle_name VARCHAR(50),
    owner_id INT,
    color VARCHAR(50),
    status ENUM('registered', 'stolen', 'wanted') DEFAULT 'registered',
    registered_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (owner_id) REFERENCES users(id),
    INDEX idx_plate (plate),
    INDEX idx_owner (owner_id)
);

-- Criminal Charges Table
CREATE TABLE charges (
    id INT AUTO_INCREMENT PRIMARY KEY,
    player_id INT NOT NULL,
    charge VARCHAR(100),
    severity ENUM('felony', 'misdemeanor', 'infraction') DEFAULT 'misdemeanor',
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    resolved BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (player_id) REFERENCES users(id),
    INDEX idx_player (player_id),
    INDEX idx_resolved (resolved)
);
